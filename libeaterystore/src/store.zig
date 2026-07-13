//! libeaterystore — a tiny native data store that embeds SQLite and exposes a
//! stable C ABI for Flutter/Dart over dart:ffi.
//!
//! The surface is a *generic SQL gateway* (open / exec / query) rather than a
//! typed per-entity API. This keeps the ABI tiny and stable so it scales to
//! every entity in the app without any new native code. Values cross the
//! boundary as JSON: parameters as a JSON array, query results as a JSON array
//! of row objects.
//!
//! See include/eaterystore.h for the C contract.

const std = @import("std");

const c = @cImport({
    @cInclude("sqlite3.h");
});

/// Opaque store handle handed back to Dart.
const Store = struct {
    db: *c.sqlite3,
    err_buf: [1024]u8,
};

const alloc = std.heap.c_allocator;

// ============================================================================
// Lifecycle
// ============================================================================

export fn es_open(path: [*:0]const u8) ?*Store {
    var db: ?*c.sqlite3 = null;
    const flags = c.SQLITE_OPEN_READWRITE | c.SQLITE_OPEN_CREATE | c.SQLITE_OPEN_FULLMUTEX;
    const rc = c.sqlite3_open_v2(path, &db, flags, null);
    if (rc != c.SQLITE_OK) {
        if (db != null) _ = c.sqlite3_close(db);
        return null;
    }

    const store = alloc.create(Store) catch {
        _ = c.sqlite3_close(db);
        return null;
    };
    store.db = db.?;
    store.err_buf[0] = 0;

    // Sensible defaults for a local, single-process app database.
    _ = c.sqlite3_exec(
        store.db,
        "PRAGMA journal_mode=WAL; PRAGMA foreign_keys=ON; PRAGMA busy_timeout=5000;",
        null,
        null,
        null,
    );
    return store;
}

export fn es_close(store: ?*Store) void {
    const s = store orelse return;
    _ = c.sqlite3_close(s.db);
    alloc.destroy(s);
}

// ============================================================================
// Execute (INSERT / UPDATE / DELETE / DDL)
// ============================================================================

export fn es_exec(store: ?*Store, sql: [*:0]const u8, params_json: ?[*:0]const u8) c_longlong {
    const s = store orelse return -1;

    // Parse params once and keep them alive for the whole call so that bound
    // text pointers (SQLITE_STATIC) remain valid through sqlite3_step.
    var parsed = parseParams(s, params_json) catch return -1;
    defer if (parsed) |*p| p.deinit();

    const sql_slice = std.mem.span(sql);
    var tail: [*c]const u8 = sql_slice.ptr;
    const end: [*c]const u8 = sql_slice.ptr + sql_slice.len;
    var first = true;
    var total_changes: c_longlong = 0;

    while (@intFromPtr(tail) < @intFromPtr(end)) {
        var stmt: ?*c.sqlite3_stmt = null;
        var next_tail: [*c]const u8 = null;
        const remaining: c_int = @intCast(@intFromPtr(end) - @intFromPtr(tail));
        const rc = c.sqlite3_prepare_v2(s.db, tail, remaining, &stmt, &next_tail);
        if (rc != c.SQLITE_OK) {
            setErrorFromDb(s);
            return -1;
        }
        // Trailing whitespace / comment yields a null statement — done.
        const st = stmt orelse break;

        // Bind params to the first statement only.
        if (first) {
            if (!applyParams(s, st, parsed)) {
                _ = c.sqlite3_finalize(st);
                return -1;
            }
            first = false;
        }

        const step_rc = c.sqlite3_step(st);
        if (step_rc != c.SQLITE_DONE and step_rc != c.SQLITE_ROW) {
            setErrorFromDb(s);
            _ = c.sqlite3_finalize(st);
            return -1;
        }
        _ = c.sqlite3_finalize(st);
        total_changes += @intCast(c.sqlite3_changes(s.db));
        tail = next_tail;
    }
    return total_changes;
}

// ============================================================================
// Query (SELECT) -> JSON array of row objects
// ============================================================================

export fn es_query(store: ?*Store, sql: [*:0]const u8, params_json: ?[*:0]const u8) ?[*:0]u8 {
    const s = store orelse return null;

    var parsed = parseParams(s, params_json) catch return null;
    defer if (parsed) |*p| p.deinit();

    var stmt: ?*c.sqlite3_stmt = null;
    const rc = c.sqlite3_prepare_v2(s.db, sql, -1, &stmt, null);
    if (rc != c.SQLITE_OK) {
        setErrorFromDb(s);
        return null;
    }
    const st = stmt orelse {
        setError(s, "empty statement");
        return null;
    };
    defer _ = c.sqlite3_finalize(st);

    if (!applyParams(s, st, parsed)) return null;

    var buf: std.ArrayListUnmanaged(u8) = .{};
    defer buf.deinit(alloc);
    buf.append(alloc, '[') catch return oom(s);

    const ncol = c.sqlite3_column_count(st);
    var row_index: usize = 0;
    while (true) {
        const step_rc = c.sqlite3_step(st);
        if (step_rc == c.SQLITE_DONE) break;
        if (step_rc != c.SQLITE_ROW) {
            setErrorFromDb(s);
            return null;
        }
        if (row_index > 0) buf.append(alloc, ',') catch return oom(s);
        row_index += 1;

        buf.append(alloc, '{') catch return oom(s);
        var ci: c_int = 0;
        while (ci < ncol) : (ci += 1) {
            if (ci > 0) buf.append(alloc, ',') catch return oom(s);
            const name = c.sqlite3_column_name(st, ci);
            appendJsonString(&buf, std.mem.span(name)) catch return oom(s);
            buf.append(alloc, ':') catch return oom(s);
            appendColumn(&buf, st, ci) catch return oom(s);
        }
        buf.append(alloc, '}') catch return oom(s);
    }
    buf.append(alloc, ']') catch return oom(s);

    // Copy into a C-owned NUL-terminated buffer (released by es_free).
    const out = std.c.malloc(buf.items.len + 1) orelse return oom(s);
    const out_bytes: [*]u8 = @ptrCast(out);
    @memcpy(out_bytes[0..buf.items.len], buf.items);
    out_bytes[buf.items.len] = 0;
    return @ptrCast(out_bytes);
}

// ============================================================================
// Errors / memory / version
// ============================================================================

export fn es_last_error(store: ?*Store) [*:0]const u8 {
    const s = store orelse return "invalid store handle";
    return @ptrCast(&s.err_buf);
}

export fn es_free(ptr: ?[*:0]u8) void {
    if (ptr) |p| std.c.free(p);
}

export fn es_version() [*:0]const u8 {
    return "eaterystore 0.1.0 (sqlite " ++ c.SQLITE_VERSION ++ ")";
}

// ============================================================================
// Internal helpers
// ============================================================================

fn oom(s: *Store) ?[*:0]u8 {
    setError(s, "out of memory");
    return null;
}

fn setError(store: *Store, msg: []const u8) void {
    const n = @min(msg.len, store.err_buf.len - 1);
    @memcpy(store.err_buf[0..n], msg[0..n]);
    store.err_buf[n] = 0;
}

fn setErrorFromDb(store: *Store) void {
    const msg = c.sqlite3_errmsg(store.db);
    setError(store, std.mem.span(msg));
}

/// Parse `params_json` into a JSON value. Returns null when there are no
/// params, an error (with store error set) when the JSON is invalid.
fn parseParams(store: *Store, params_json: ?[*:0]const u8) !?std.json.Parsed(std.json.Value) {
    const pj = params_json orelse return null;
    const slice = std.mem.span(pj);
    if (slice.len == 0) return null;
    return std.json.parseFromSlice(std.json.Value, alloc, slice, .{}) catch {
        setError(store, "invalid params_json (not valid JSON)");
        return error.InvalidParams;
    };
}

/// Bind a parsed params array to the statement's positional `?` placeholders.
/// Uses SQLITE_STATIC (null destructor); the caller guarantees `parsed`
/// outlives the statement's execution.
fn applyParams(store: *Store, stmt: *c.sqlite3_stmt, parsed: ?std.json.Parsed(std.json.Value)) bool {
    const p = parsed orelse return true;
    switch (p.value) {
        .array => |arr| {
            for (arr.items, 0..) |v, i| bindValue(stmt, @intCast(i + 1), v);
            return true;
        },
        .null => return true,
        else => {
            setError(store, "params_json must be a JSON array");
            return false;
        },
    }
}

fn bindValue(stmt: *c.sqlite3_stmt, idx: c_int, v: std.json.Value) void {
    switch (v) {
        .null => _ = c.sqlite3_bind_null(stmt, idx),
        .bool => |b| _ = c.sqlite3_bind_int(stmt, idx, if (b) 1 else 0),
        .integer => |n| _ = c.sqlite3_bind_int64(stmt, idx, n),
        .float => |f| _ = c.sqlite3_bind_double(stmt, idx, f),
        .number_string => |ns| {
            if (std.fmt.parseInt(i64, ns, 10)) |n| {
                _ = c.sqlite3_bind_int64(stmt, idx, n);
            } else |_| {
                const f = std.fmt.parseFloat(f64, ns) catch 0;
                _ = c.sqlite3_bind_double(stmt, idx, f);
            }
        },
        // SQLITE_STATIC (null): the parsed JSON owns this memory and outlives
        // the statement execution, so SQLite need not copy it.
        .string => |st| _ = c.sqlite3_bind_text(stmt, idx, st.ptr, @intCast(st.len), null),
        // Nested arrays/objects are not expected as bind params in the spike.
        .array, .object => _ = c.sqlite3_bind_null(stmt, idx),
    }
}

fn appendColumn(buf: *std.ArrayListUnmanaged(u8), stmt: *c.sqlite3_stmt, ci: c_int) !void {
    switch (c.sqlite3_column_type(stmt, ci)) {
        c.SQLITE_INTEGER => {
            var tmp: [24]u8 = undefined;
            const str = try std.fmt.bufPrint(&tmp, "{d}", .{c.sqlite3_column_int64(stmt, ci)});
            try buf.appendSlice(alloc, str);
        },
        c.SQLITE_FLOAT => {
            var tmp: [40]u8 = undefined;
            const str = try std.fmt.bufPrint(&tmp, "{d}", .{c.sqlite3_column_double(stmt, ci)});
            try buf.appendSlice(alloc, str);
            // Zig prints e.g. 4.0 as "4"; Dart's jsonDecode would then read it
            // back as an int. Force a fractional part so REAL columns always
            // round-trip as a double when the printed form is integer-looking.
            var int_like = str.len > 0;
            for (str) |d| {
                if ((d < '0' or d > '9') and d != '-') {
                    int_like = false;
                    break;
                }
            }
            if (int_like) try buf.appendSlice(alloc, ".0");
        },
        c.SQLITE_TEXT => {
            const ptr = c.sqlite3_column_text(stmt, ci);
            const len: usize = @intCast(c.sqlite3_column_bytes(stmt, ci));
            const bytes: []const u8 = @as([*]const u8, @ptrCast(ptr))[0..len];
            try appendJsonString(buf, bytes);
        },
        // NULL and (unsupported) BLOB both serialize as JSON null.
        else => try buf.appendSlice(alloc, "null"),
    }
}

fn appendJsonString(buf: *std.ArrayListUnmanaged(u8), s: []const u8) !void {
    const hex = "0123456789abcdef";
    try buf.append(alloc, '"');
    for (s) |ch| {
        switch (ch) {
            '"' => try buf.appendSlice(alloc, "\\\""),
            '\\' => try buf.appendSlice(alloc, "\\\\"),
            '\n' => try buf.appendSlice(alloc, "\\n"),
            '\r' => try buf.appendSlice(alloc, "\\r"),
            '\t' => try buf.appendSlice(alloc, "\\t"),
            0x08 => try buf.appendSlice(alloc, "\\b"),
            0x0C => try buf.appendSlice(alloc, "\\f"),
            else => {
                if (ch < 0x20) {
                    try buf.appendSlice(alloc, "\\u00");
                    try buf.append(alloc, hex[(ch >> 4) & 0xF]);
                    try buf.append(alloc, hex[ch & 0xF]);
                } else {
                    try buf.append(alloc, ch);
                }
            },
        }
    }
    try buf.append(alloc, '"');
}
