# ADR 003: Zig for Native Code

**Date:** During Phase 2 (native SQLite store spike)

**Status:** Accepted

## Context

The app needed an embeddable, cross-platform SQLite library accessible from Flutter/Dart via `dart:ffi`. The requirements:

- Embed SQLite (no system dependency)
- Cross-compile for 5 platforms (Android, iOS, macOS, Windows, Linux)
- Expose a stable C ABI for Dart FFI binding
- Fast compile times for development iteration
- Minimal build system complexity

## Decision

Use **Zig 0.15+** to build `libeaterystore`, a native library that embeds SQLite and exposes a generic SQL gateway via C ABI.

## Consequences

### Positive

- **Single build.zig:** One build file replaces CMakeLists.txt + Makefile + autotools
- **Fast compile times:** Full rebuild in <2 seconds (SQLite amalgamation + wrapper)
- **Excellent C interop:** `extern fn` and `@cImport` are first-class Zig features
- **Cross-compilation:** Single `zig build` command targets any platform from any host
- **Simple deployment:** One Zig binary, no runtime dependencies, no system SQLite
- **Proven pattern:** Mirrors the `SoftEtherApp/libsoftether` conventions used elsewhere

### Negative

- **Toolchain requirement:** All developers must install Zig 0.15+ to build
- **Limited ecosystem:** Fewer libraries and less community support than C/Rust
- **FFI serialization overhead:** Data crosses the Dart↔C boundary as JSON strings
- **Learning curve:** Team needs basic Zig familiarity for debugging/contributing

## Alternatives Considered

| Solution | Pros | Cons |
|----------|------|------|
| **C (CMake)** | Universal, every platform has a C compiler | CMake complexity, slow compile of SQLite amalgamation, manual cross-compilation setup per platform |
| **Rust** | Memory safety, excellent FFI, Cargo ecosystem | Heavier toolchain (rustc + cargo), slower compile times, larger binary, more complex FFI setup |
| **C++** | Familiar to most developers | Very slow compile times for SQLite amalgamation, CMake complexity, no memory safety guarantees |
| **Go** | Simple cross-compilation | CGo overhead, larger binaries, GC pause concerns for embedded use |
| **Pure Dart** | No native build needed | No `dart:ffi` → no SQLite; would need to use a pure-Dart SQL library (much slower) |

## Why Not OS-System SQLite

System SQLite varies by platform (version, compile flags, availability). Embedding the amalgamation guarantees identical behavior across all platforms and removes system dependencies.

## Compile Flags

SQLite is compiled with these flags for optimal embedded use:

```
SQLITE_ENABLE_FTS5=1      # Full-text search
SQLITE_ENABLE_JSON1=1     # JSON functions
SQLITE_ENABLE_RTREE=1     # Spatial indexing
SQLITE_DQS=0              # Disable double-quoted string literals
SQLITE_THREADSAFE=1       # Thread-safe mode
SQLITE_DEFAULT_MEMSTATUS=0
SQLITE_DEFAULT_WAL_SYNCHRONOUS=1
SQLITE_OMIT_DEPRECATED=1
SQLITE_OMIT_SHARED_CACHE=1
SQLITE_USE_ALLOCA=1
```

## Build Command

```bash
cd libeaterystore
zig build shared-lib   # -> zig-out/lib/libeaterystore.dylib (.so / .dll)
zig build static-lib   # -> zig-out/lib/libeaterystore.a (mobile embedding)
```
