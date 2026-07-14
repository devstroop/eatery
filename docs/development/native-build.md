# Native Build (Zig/SQLite)

## Location

The native SQLite library lives at `libeaterystore/`:

```
libeaterystore/
  build.zig              # Build definition
  build.zig.zon          # Zig package manifest
  deps/sqlite/           # Vendored SQLite amalgamation (v3.47.0)
    sqlite3.c
    sqlite3.h
  include/eaterystore.h  # C ABI contract (documentation)
  src/store.zig          # C ABI implementation
  scripts/build.sh       # Platform-aware build script
```

## Prerequisites

- **Zig 0.15+** — required. Verify:

  ```bash
  zig version
  # Expected: 0.15.x
  ```

## Build

```bash
cd libeaterystore

# Auto-detect host platform
./scripts/build.sh

# Or explicitly:
zig build shared-lib     # -> zig-out/lib/libeaterystore.dylib (.so / .dll)
zig build static-lib     # -> zig-out/lib/libeaterystore.a (mobile embedding)
```

## Output

| Platform | Shared | Static |
|----------|--------|--------|
| macOS | `libeaterystore.dylib` | `libeaterystore.a` |
| Linux | `libeaterystore.so` | `libeaterystore.a` |
| Windows | `eaterystore.dll` | `eaterystore.lib` |
| Android | `libeaterystore.so` (per ABI) | — |
| iOS | — | `libeaterystore.a` (via `DynamicLibrary.process()`) |

## What It Does

The library embeds the **SQLite amalgamation** (v3.47.0) with these features enabled:

- FTS5 full-text search
- JSON1 JSON functions
- RTREE spatial indexing
- WAL mode (default synchronous = 1)
- Thread-safe mode

It exposes a **generic SQL gateway** via stable C ABI �� not typed per-entity calls:

| Symbol | Purpose |
|--------|---------|
| `es_open` | Open/create a DB file, returns opaque handle |
| `es_close` | Close the store |
| `es_exec` | Run INSERT/UPDATE/DELETE/DDL, returns affected rows |
| `es_query` | Run SELECT, returns JSON array of row objects (caller frees) |
| `es_last_error` | Last error message |
| `es_free` | Free buffer returned by `es_query` |
| `es_version` | Version string |

Data crosses the FFI boundary as JSON strings — params as a JSON array, results as a JSON array of row objects.

## Dart FFI Bindings

Located in `packages/eatery_core/lib/data/database/native/`:

| File | Content |
|------|---------|
| `eatery_store_bindings.dart` | Low-level FFI bindings + platform loader |
| `eatery_store.dart` | `EateryStore` wrapper (`execute`, `query`, `queryScalar`) |
| `eatery_schema.dart` | SQL schema initialization for migrated entities |
| `schema_migrator.dart` | Incremental schema migrations |
| `store_config.dart` | Feature flags (`kUseSqliteProductStore`, etc.) |

## Platform Bundling

`scripts/build.sh` places the artifact where Flutter expects it:

| Platform | Wiring |
|----------|--------|
| macOS | `macos/Podfile` copies `.dylib` into `Frameworks` |
| Android | Gradle task cross-compiles per ABI into `jniLibs` |
| Windows | `CMakeLists.txt` copies `.dll` next to the runner |
| iOS | Static `.a` linked via Xcode (requires one-time setup) |
| Linux | `.so` loaded at runtime |

## Cross-Compilation

From macOS, build for all targets:

```bash
./scripts/build.sh macos     # native
./scripts/build.sh ios       # aarch64-ios
./scripts/build.sh android   # all Android ABIs (requires ANDROID_NDK_HOME)
./scripts/build.sh linux     # x86_64-linux, aarch64-linux
./scripts/build.sh windows   # x86_64-windows
```

## Why Zig

- **Single binary** — no CMake, no Makefile, no autotools
- **Fast compile times** — full rebuild in <2 seconds
- **Excellent C interop** — `extern fn` is a first-class language feature
- **Cross-compilation** — single toolchain for all 5 platforms
- **Simple deployment** — one `build.zig`, one source file

## See Also

- [libeaterystore README](../../libeaterystore/README.md) — detailed FFI documentation
- [C ABI header](../../libeaterystore/include/eaterystore.h) — full API reference
- [Setup guide](setup.md) — environment setup for all platforms
