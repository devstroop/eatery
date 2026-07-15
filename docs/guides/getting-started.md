# Getting Started

> Prerequisites: Flutter 3.41+, Dart 3.11+, Zig 0.15+

## Clone

```bash
git clone https://github.com/anomalyco/eatery.git
cd eatery
```

## Get Dependencies

```bash
flutter pub get
```

> ℹ️ `packages/eatery_core` is a `path:` dependency so its dependencies are resolved at the root level.

## Build Native SQLite Library

```bash
cd libeaterystore
./scripts/build.sh       # auto-detects host platform
# or: zig build shared-lib
```

Output: `libeaterystore.dylib` (macOS), `libeaterystore.so` (Linux/Android), `eaterystore.dll` (Windows).

## Code Generation

```bash
dart run build_runner build --delete-conflicting-outputs
```

Generates `*.freezed.dart` and `*.g.dart` model files.

## Analyze

```bash
flutter analyze --no-fatal-infos --no-fatal-warnings lib/
```

## Test

```bash
# Root package tests (admin app logic)
flutter test

# Core library tests (models, sync, repositories, database)
flutter test packages/eatery_core/test/
```

The core tests are run separately because `packages/eatery_core` is a path dependency, not a workspace member.

## Run the App

```bash
flutter run
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

## IDE Setup

### VS Code

Recommended extensions:
- **Dart** (dart-code.dart-code)
- **Flutter** (dart-code.flutter)
- **Zig** (ziglang.vscode-zig)

`.vscode/launch.json` is included — select "Eatery" configuration.

### IntelliJ / Android Studio

Install the **Dart** and **Flutter** plugins. Open the root `eatery/` folder.

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
