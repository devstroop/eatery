# Setup

> Detailed environment setup for developing Eatery.

## Prerequisites

| Tool | Version | Purpose |
|------|---------|---------|
| Flutter | 3.41+ | UI framework |
| Dart | 3.11+ (bundled with Flutter) | Language |
| Zig | 0.15+ | Native SQLite library build |
| Melos | 8.x | Monorepo management |

## Flutter SDK

### Using FVM (Recommended)

```bash
# Install fvm
dart pub global activate fvm

# Install Flutter 3.41
fvm install 3.41.5
fvm global 3.41.5

# Verify
fvm flutter --version
```

### Manual Installation

1. Download from [flutter.dev](https://flutter.dev)
2. Extract to `~/flutter`
3. Add to `PATH`:
   ```bash
   export PATH="$PATH:$HOME/flutter/bin"
   ```

## Dart SDK

Dart is bundled with Flutter. Verify:

```bash
dart --version
# Expected: Dart 3.11+
```

## Melos

```bash
dart pub global activate melos
```

Verify:

```bash
melos --version
# Expected: 8.x
```

## Zig

```bash
# macOS (Homebrew)
brew install zig

# Linux / Windows
# Download from https://ziglang.org/download/
```

Verify:

```bash
zig version
# Expected: 0.15+
```

## Platform Toolchains

### iOS / macOS

- Xcode 16+ (from Mac App Store)
- CocoaPods: `sudo gem install cocoapods`
- iOS 18+ SDK

### Android

- Android Studio Ladybug+ (2024.x)
- Android SDK 35+
- NDK 27+ (required for native library cross-compilation)
- Set `ANDROID_NDK_HOME`:
  ```bash
  export ANDROID_NDK_HOME=$HOME/Library/Android/sdk/ndk/27.x.x
  ```

### Windows

- Visual Studio 2022+ with "Desktop development with C++" workload
- Windows 10/11 SDK

### Linux

```bash
sudo apt install build-essential cmake libgtk-3-dev liblzma-dev pkg-config
```

## Building from Source

### 1. Clone

```bash
git clone https://github.com/anomalyco/eatery.git
cd eatery
```

### 2. Get Dependencies

```bash
flutter pub get
```

> ℹ️ `packages/eatery_core` is a `path:` dependency so its dependencies are resolved at the root level.

### 3. Build Native Library

```bash
cd libeaterystore
./scripts/build.sh       # auto-detects host platform
# or: zig build shared-lib
```

For cross-compilation:

```bash
./scripts/build.sh macos     # macOS .dylib
./scripts/build.sh linux     # Linux .so
./scripts/build.sh windows   # Windows .dll
./scripts/build.sh android   # Android .so (all ABIs)
./scripts/build.sh ios       # iOS .a (static)
```

### 4. Code Generation

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 5. Analyze

```bash
flutter analyze --no-fatal-infos --no-fatal-warnings lib/
```

### 6. Test

```bash
# Root package tests (admin app logic)
flutter test

# Core library tests (models, sync, repositories, database)
flutter test packages/eatery_core/test/
```

The core tests are run separately because `packages/eatery_core` is a path dependency, not a workspace member.

### 7. Run

```bash
flutter run
```

## Debug vs Release Builds

```bash
# Debug (hot reload enabled)
flutter run

# Release
flutter run --release

# Profile (performance testing)
flutter run --profile

# Platform-specific builds
melos run build:admin     # macOS debug build
flutter build apk         # Android
flutter build ios         # iOS
flutter build macos       # macOS
flutter build windows     # Windows
flutter build linux       # Linux
```

## Running on Specific Platforms

### macOS

```bash
cd macos && pod install && cd ..
flutter run -d macos
```

### iOS

```bash
cd ios && pod install && cd ..
flutter run -d ios
```

### Android

Ensure a device is connected or emulator is running:

```bash
flutter run -d android
```

### Windows

```bash
flutter run -d windows
```

### Linux

```bash
flutter run -d linux
```

## Hot Reload / Hot Restart

Hot reload works during `flutter run` debug sessions. For stateful widget changes that affect `ProviderScope`, use hot restart (Cmd+Shift+\ in VS Code, R in terminal).

## Troubleshooting

| Problem | Solution |
|---------|----------|
| `melos bootstrap` fails | Check network, run `flutter pub cache repair` |
| Native library loading fails | Run `cd libeaterystore && ./scripts/build.sh` |
| `Android NDK not found` | Set `ANDROID_NDK_HOME` environment variable |
| `pod install` fails | Run `pod repo update` first |
| Code gen conflicts | `melos run generate` uses `--delete-conflicting-outputs` |
