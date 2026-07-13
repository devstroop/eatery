# libeaterystore

A tiny native data store that embeds **SQLite** and exposes a stable **C ABI**
for Flutter/Dart over `dart:ffi`. Built with **Zig**, mirroring the
`SoftEtherApp/libsoftether` conventions.

This is the spike that replaces Hive with SQLite. Three entity groups are
migrated so far — `Product`/`ProductCategory`, `Customer`, and
`Order`/`OrderProduct` (foreign-key related, with `ON DELETE CASCADE` and
transactions) — proving the pattern generalizes. The FFI surface is a *generic
SQL gateway* (open / exec / query / transaction) rather than typed per-entity
calls, so the same native library scales to every entity in the app with **no
new native code**.

## Layout

```
libeaterystore/
  build.zig            # zig build shared-lib | static-lib
  build.zig.zon
  deps/sqlite/         # vendored SQLite amalgamation (sqlite3.c/.h, v3.47.0)
  include/eaterystore.h# C contract (documentation)
  src/store.zig        # C ABI implementation
```

## Build

```bash
cd libeaterystore
zig build shared-lib     # -> zig-out/lib/libeaterystore.dylib (.so / .dll)
zig build static-lib     # -> zig-out/lib/libeaterystore.a  (mobile embedding)
```

Requires Zig 0.15.x.

## C ABI (see `include/eaterystore.h`)

| Symbol           | Purpose                                                    |
|------------------|------------------------------------------------------------|
| `es_open`        | Open/create a DB file, returns opaque handle               |
| `es_close`       | Close the store                                            |
| `es_exec`        | Run INSERT/UPDATE/DELETE/DDL, returns affected rows (-1 on error) |
| `es_query`       | Run SELECT, returns a JSON array of row objects (caller frees via `es_free`) |
| `es_last_error`  | Last error message                                         |
| `es_free`        | Free a buffer returned by `es_query`                       |
| `es_version`     | Version string                                             |

Values cross the boundary as JSON:
* **params** — a JSON array bound positionally to `?` placeholders,
  e.g. `["Espresso", 3.5, true, null]`
* **results** — a JSON array of row objects

Type mapping: `null`↔NULL, `int`↔INTEGER, `double`↔REAL, `bool`→INTEGER (0/1),
`String`↔TEXT. Whole-number REAL values are emitted with a trailing `.0` so
they round-trip as Dart `double`.

## Dart side

* `lib/data/database/native/eatery_store_bindings.dart` — low-level FFI bindings + platform loader
* `lib/data/database/native/eatery_store.dart` — `EateryStore` wrapper (`execute` / `query` / `queryScalar`)
* `lib/data/database/native/eatery_schema.dart` — `product` / `product_category` / `customer` / `orders` / `order_product` schema
* `lib/data/repositories/product_repository_sqlite.dart` — `SqliteProductRepository implements ProductRepository`
* `lib/data/repositories/customer_repository_sqlite.dart` — `SqliteCustomerRepository implements CustomerRepository`
* `lib/data/repositories/order_repository_sqlite.dart` — `SqliteOrderRepository implements OrderRepository` (FK cascade + line items)
* `lib/data/database/native/store_config.dart` — `kUseSqliteProductStore` / `kUseSqliteCustomerStore` / `kUseSqliteOrderStore` feature flags

The swap happens in the repository providers; no UI code changes.
`EateryStore.transaction()` wraps atomic multi-row writes. `SqliteCustomerRepository`
also demonstrates incremental migration: `getOutstandingAmount` still reads
Hive-backed Orders/Payments while pure-customer operations go through SQLite.

## Platform bundling

A helper script builds the right artifact per platform and places it where the
Flutter build expects:

```bash
scripts/build.sh macos     # libeaterystore.dylib  (bundled by macos/Podfile)
scripts/build.sh android   # libeaterystore.so     -> android jniLibs (all ABIs)
scripts/build.sh windows   # eaterystore.dll        (copied by windows/CMakeLists.txt)
scripts/build.sh ios        # libeaterystore.a       (link into Runner, see below)
scripts/build.sh linux     # libeaterystore.so
```

Cross-compilation from macOS is verified for **all** targets: macOS, Linux
(x86_64/aarch64), Windows (x86_64), Android (arm64-v8a / armeabi-v7a / x86_64)
and iOS (arm64 static).

| Platform | Wiring | Status |
|----------|--------|--------|
| macOS    | `macos/Podfile` `post_install` copies the dylib into `Frameworks` (`@rpath`) | ✅ built + run |
| Android  | `android/app/build.gradle` `buildEateryStore` task cross-compiles per ABI into `jniLibs` | ✅ native `.so` verified; APK build blocked by the app's pre-existing Gradle-plugin migration (unrelated) |
| Windows  | `windows/CMakeLists.txt` copies `eaterystore.dll` next to the runner + installs it | ⚙️ wired (needs a Windows host to verify) |
| iOS      | Build the static `.a` and link it into the Runner (one-time Xcode step below) | ⚙️ `.a` builds; needs the link step + on-device test |
| Web      | Not supported (no `dart:ffi`; would require a SQLite WASM build) | ❌ out of scope |

### iOS: link the static library (one-time)

The FFI loader uses `DynamicLibrary.process()` on iOS, so the static lib must be
linked into the app binary:

1. `scripts/build.sh ios` → produces `zig-out/lib/libeaterystore.a`.
2. In Xcode, add `libeaterystore.a` to the **Runner** target's *Link Binary With
   Libraries* phase (or set `OTHER_LDFLAGS = -force_load .../libeaterystore.a`
   and add its folder to *Library Search Paths*). `-force_load` keeps all
   symbols so `DynamicLibrary.process()` can resolve them.
3. For the simulator, build the matching slice
   (`zig build static-lib -Dtarget=aarch64-ios-simulator`).


## Tests

```bash
flutter test test/data/database/eatery_store_test.dart
flutter test test/data/repositories/product_repository_sqlite_test.dart
flutter test test/data/repositories/customer_repository_sqlite_test.dart
flutter test test/data/repositories/order_repository_sqlite_test.dart
```

## Follow-ups (post-spike)

* Finish the Android APK path (the app's Android module needs the Flutter
  declarative Gradle-plugin migration — unrelated to this store).
* Verify Windows/iOS on their native hosts; complete the iOS link step.
* Move heavy queries to a background isolate (avoid main-isolate jank).
* Optional **SQLCipher** swap for at-rest encryption (compile-time flag).
* Generate schemas/repositories for the remaining entities.
