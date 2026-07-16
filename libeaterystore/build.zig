const std = @import("std");

/// build.zig for libeaterystore — a small native data store that embeds
/// SQLite and exposes a tiny, stable C ABI over dart:ffi.
///
/// Mirrors the SoftEtherApp/libsoftether build conventions:
///   zig build shared-lib   -> libeaterystore.{dylib,so} / eaterystore.dll
///   zig build static-lib   -> libeaterystore.a (mobile embedding)
///
/// SQLite is compiled from the vendored amalgamation in deps/sqlite.
pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{
        .preferred_optimize_mode = .ReleaseFast,
    });

    const target_os = target.result.os.tag;
    const target_abi = target.result.abi;
    const target_arch = target.result.cpu.arch;
    const is_android =
        target_os == .linux and (target_abi == .android or target_abi == .androideabi);

    // Optional: link SQLCipher for AES-256 at-rest encryption.
    //   zig build shared-lib -Denable-encryption
    // Requires libsqlcipher installed (brew install sqlcipher on macOS).
    const enable_encryption = b.option(bool, "enable-encryption", "Link SQLCipher instead of plain SQLite") orelse false;

    // Compile flags for the SQLite amalgamation (unused when encryption is on).
    const sqlite_flags = [_][]const u8{
        "-DSQLITE_ENABLE_FTS5=1",
        "-DSQLITE_ENABLE_JSON1=1",
        "-DSQLITE_ENABLE_RTREE=1",
        "-DSQLITE_DQS=0",
        "-DSQLITE_THREADSAFE=1",
        "-DSQLITE_DEFAULT_MEMSTATUS=0",
        "-DSQLITE_DEFAULT_WAL_SYNCHRONOUS=1",
        "-DSQLITE_LIKE_DOESNT_MATCH_BLOBS=1",
        "-DSQLITE_MAX_EXPR_DEPTH=0",
        "-DSQLITE_OMIT_DEPRECATED=1",
        "-DSQLITE_OMIT_SHARED_CACHE=1",
        "-DSQLITE_USE_ALLOCA=1",
        "-DSQLITE_ENABLE_COLUMN_METADATA=1",
        // Compile-time FK enforcement — replaces runtime PRAGMA foreign_keys=ON.
        // Ensures FK constraints survive connection loss. Existing databases
        // with orphaned rows will fail on INSERT/UPDATE after upgrading.
        "-DSQLITE_DEFAULT_FOREIGN_KEYS=1",
    };

    // ------------------------------------------------------------------
    // Shared library (Flutter FFI on desktop: macOS/Linux/Windows)
    // ------------------------------------------------------------------
    const shared_lib = b.addLibrary(.{
        .linkage = .dynamic,
        .name = "eaterystore",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/store.zig"),
            .target = target,
            .optimize = optimize,
            .strip = optimize != .Debug and target_os != .macos,
        }),
    });
    configure(b, shared_lib, &sqlite_flags, target_os, is_android, target_arch, enable_encryption);
    if (target_os == .macos) {
        shared_lib.headerpad_max_install_names = true;
    }
    const install_shared = b.addInstallArtifact(shared_lib, .{});
    const shared_step = b.step("shared-lib", "Build shared library (libeaterystore.dylib/.so/.dll)");
    shared_step.dependOn(&install_shared.step);

    // ------------------------------------------------------------------
    // Static library (mobile embedding: iOS/Android)
    // ------------------------------------------------------------------
    const static_lib = b.addLibrary(.{
        .linkage = .static,
        .name = "eaterystore",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/store.zig"),
            .target = target,
            .optimize = optimize,
            .strip = optimize != .Debug,
        }),
    });
    configure(b, static_lib, &sqlite_flags, target_os, is_android, target_arch, enable_encryption);
    const install_static = b.addInstallArtifact(static_lib, .{});
    const static_step = b.step("static-lib", "Build static library (libeaterystore.a)");
    static_step.dependOn(&install_static.step);

    // Default `zig build` installs the shared library.
    b.installArtifact(shared_lib);
}

/// Attach the SQLite backend (plain or SQLCipher), SDK/NDK include paths,
/// library paths, and finally link libc. linkLibC provides the libc library
/// dependency (resolved by the linker) and is needed for both shared and
/// static libraries — the linker resolves what it can and defers the rest.
fn configure(
    b: *std.Build,
    lib: *std.Build.Step.Compile,
    sqlite_flags: []const []const u8,
    target_os: std.Target.Os.Tag,
    is_android: bool,
    arch: std.Target.Cpu.Arch,
    enable_encryption: bool,
) void {
    lib.addIncludePath(b.path("include"));

    if (enable_encryption) {
        // SQLCipher — drop-in replacement, same C API.
        // Defines SQLCIPHER so store.zig calls sqlite3_key() on open.
        lib.root_module.addCMacro("SQLCIPHER", "1");
        // Homebrew-installed SQLCipher on macOS.
        if (target_os == .macos) {
            for ([_][]const u8{
                "/opt/homebrew/opt/sqlcipher/include",
                "/usr/local/opt/sqlcipher/include",
                "/opt/homebrew/include",
                "/usr/local/include",
            }) |p| {
                if (std.fs.cwd().access(p, .{})) |_| {
                    lib.addIncludePath(.{ .cwd_relative = p });
                    break;
                } else |_| continue;
            }
            for ([_][]const u8{
                "/opt/homebrew/opt/sqlcipher/lib",
                "/usr/local/opt/sqlcipher/lib",
            }) |p| {
                if (std.fs.cwd().access(p, .{})) |_| {
                    lib.addLibraryPath(.{ .cwd_relative = p });
                    break;
                } else |_| continue;
            }
        }
        lib.linkSystemLibrary2("sqlcipher", .{ .use_pkg_config = .no });
    } else {
        // Plain SQLite amalgamation.
        lib.addIncludePath(b.path("deps/sqlite"));
        lib.addCSourceFile(.{
            .file = b.path("deps/sqlite/sqlite3.c"),
            .flags = sqlite_flags,
        });
    }

    if (is_android) setupAndroidNdk(b, lib, arch);
    if (target_os == .ios) {
        setupIosSdk(b, lib);
    }
    lib.linkLibC();
}

/// Resolve the iOS SDK include and library paths. Checks `IOS_SDK_PATH` env var
/// first (set by CI workflows via `xcrun`), then falls back to the standard
/// Xcode location. Adds both include and library paths so linkLibC can find
/// iOS platform headers and libc stubs (same pattern as WorxVPN-App).
fn setupIosSdk(b: *std.Build, lib: *std.Build.Step.Compile) void {
    // Mirror WorxVPN-App approach: hardcode the standard Xcode path.
    // GitHub macOS runners (macos-15) have Xcode at the standard location.
    _ = b;
    lib.addSystemIncludePath(.{
        .cwd_relative = "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk/usr/include",
    });
    lib.addLibraryPath(.{
        .cwd_relative = "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk/usr/lib",
    });
}

/// Configure the Android NDK sysroot (bionic libc headers, arch libs and CRT
/// objects) so SQLite/libc compile for Android. Requires `ANDROID_NDK_HOME`;
/// honours optional `ANDROID_API_LEVEL` (default 21). Mirrors the approach in
/// SoftEtherApp/libsoftether/build.zig, without the OpenSSL bits.
fn setupAndroidNdk(b: *std.Build, step: *std.Build.Step.Compile, arch: std.Target.Cpu.Arch) void {
    const ndk_home = std.process.getEnvVarOwned(b.allocator, "ANDROID_NDK_HOME") catch {
        std.log.err("ANDROID_NDK_HOME must be set for Android builds", .{});
        std.process.exit(1);
    };

    const host_triple = switch (@import("builtin").os.tag) {
        .macos => blk: {
            const arch_triple = switch (@import("builtin").target.cpu.arch) {
                .aarch64 => "darwin-aarch64",
                else => "darwin-x86_64",
            };
            const prebuilt = std.fs.path.join(b.allocator, &.{
                ndk_home, "toolchains", "llvm", "prebuilt", arch_triple,
            }) catch break :blk "darwin-x86_64";
            if (std.fs.cwd().access(prebuilt, .{})) |_| break :blk arch_triple else |_| break :blk "darwin-x86_64";
        },
        .linux => "linux-x86_64",
        .windows => "windows-x86_64",
        else => {
            std.log.err("Unsupported host OS for Android cross-build", .{});
            std.process.exit(1);
        },
    };

    const sysroot = std.fs.path.join(b.allocator, &.{
        ndk_home, "toolchains", "llvm", "prebuilt", host_triple, "sysroot",
    }) catch return;

    const usr_include = std.fs.path.join(b.allocator, &.{ sysroot, "usr", "include" }) catch return;
    step.addSystemIncludePath(.{ .cwd_relative = usr_include });

    const arch_triple = switch (arch) {
        .aarch64 => "aarch64-linux-android",
        .arm => "arm-linux-androideabi",
        .x86_64 => "x86_64-linux-android",
        else => {
            std.log.err("Unsupported Android arch", .{});
            std.process.exit(1);
        },
    };

    const arch_include = std.fs.path.join(b.allocator, &.{ usr_include, arch_triple }) catch return;
    step.addSystemIncludePath(.{ .cwd_relative = arch_include });

    const api_level = if (std.process.getEnvVarOwned(b.allocator, "ANDROID_API_LEVEL")) |lvl|
        lvl
    else |_|
        "21";

    const ndk_lib_dir = std.fs.path.join(b.allocator, &.{ sysroot, "usr", "lib", arch_triple, api_level }) catch return;
    step.addLibraryPath(.{ .cwd_relative = ndk_lib_dir });

    // Generate a libc config so zig can find CRT objects (crtbegin_so.o, etc.).
    const libc_config = std.fmt.allocPrint(b.allocator,
        \\include_dir={s}
        \\sys_include_dir={s}
        \\crt_dir={s}
        \\msvc_lib_dir=
        \\kernel32_lib_dir=
        \\gcc_dir=
    , .{ usr_include, arch_include, ndk_lib_dir }) catch return;

    const conf_name = std.fmt.allocPrint(b.allocator, "android-libc-{s}.conf", .{@tagName(arch)}) catch return;
    const conf_path = std.fs.path.join(b.allocator, &.{ ".zig-cache", conf_name }) catch return;
    std.fs.cwd().makePath(".zig-cache") catch {};
    const f = std.fs.cwd().createFile(conf_path, .{}) catch {
        std.log.err("Failed to write libc config to {s}", .{conf_path});
        std.process.exit(1);
    };
    defer f.close();
    f.writeAll(libc_config) catch return;
    step.setLibCFile(.{ .cwd_relative = conf_path });
}
