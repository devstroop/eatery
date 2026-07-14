# Getting Started

> Prerequisites: Flutter 3.41+, Dart 3.11+, Zig 0.15+, Melos

## Clone

```bash
git clone https://github.com/anomalyco/eatery.git
cd eatery
```

## Bootstrap

```bash
melos bootstrap
```

This installs dependencies for all workspace packages (`apps/*`, `packages/*`).

## Code Generation

```bash
melos run generate
```

Runs `build_runner` with `--delete-conflicting-outputs` on `eatery_core`. Generates `*.freezed.dart` and `*.g.dart` files.

For watch mode:

```bash
melos run generate:watch
```

## Analyze

```bash
melos run analyze
```

Runs `dart analyze` across all packages. Keep this clean — zero errors, no fatal warnings.

## Test

```bash
melos run test
```

Runs `flutter test` in every workspace package.

## Run the Admin App

```bash
cd apps/eatery_admin && flutter run
```

Or directly from root (if the workspace resolves correctly):

```bash
flutter run
```

## Run Companion Apps

```bash
cd apps/eatery_waiter && flutter run
cd apps/eatery_kds && flutter run
cd apps/eatery_display && flutter run
```

## Platform-Specific Setup

### macOS

```bash
cd macos && pod install
```

### Windows

Install Visual Studio 2022+ with "Desktop development with C++" workload. The `eaterystore.dll` is wired via `windows/CMakeLists.txt`.

### Linux

```bash
sudo apt install build-essential cmake libgtk-3-dev liblzma-dev
```

## Native Zig/SQLite Library

```bash
cd libeaterystore && ./scripts/build.sh
```

Or directly:

```bash
cd libeaterystore && zig build shared-lib
```

Output: `libeaterystore.dylib` (macOS), `libeaterystore.so` (Linux/Android), `eaterystore.dll` (Windows).

## IDE Setup

### VS Code

Recommended extensions:
- **Dart** (dart-code.dart-code)
- **Flutter** (dart-code.flutter)
- **Zig** (ziglang.vscode-zig)

`.vscode/launch.json` is included — select "Eatery" configuration.

### IntelliJ / Android Studio

Install the **Dart** and **Flutter** plugins. Open the root `eatery/` folder — Melos workspace is detected automatically.

## Common Issues

| Issue | Solution |
|-------|----------|
| `flutter: No such file or directory` | Run `melos bootstrap` |
| Build errors on generated files | Run `melos run generate` |
| `zig: command not found` | Install Zig 0.15+ (see [docs/development/setup.md](development/setup.md)) |
| `melos: command not found` | `dart pub global activate melos` |
| Native lib not found | `cd libeaterystore && ./scripts/build.sh` |
| `pod install` fails | `sudo gem install cocoapods` then retry |

## Next Steps

- [Architecture Overview](architecture-overview.md)
- [Setup Deep Dive](../development/setup.md)
- [Contributing](../CONTRIBUTING.md)
