# Quickstart

Get Eatery running in 5 minutes.

## Prerequisites

- Flutter SDK ≥ 3.41 (`flutter --version`)
- Visual Studio 2022 (Windows) or Xcode (macOS)
- Git

## Setup

```bash
cd eatery
flutter pub get
```

## Run

```bash
# Windows (primary dev target)
flutter run -d windows

# macOS
flutter run -d macos

# Android (emulator or device)
flutter run

# Role override (dev only)
flutter run -d windows --dart-define=role=waiter
```

## First Launch

1. App shows **Role Picker** — tap "I'm Staff" (Admin)
2. **Main Screen** — tap "Set up my restaurant" or "Try Demo"
3. **Setup Wizard** — create company, set currency
4. **Login** — use PIN `1234` (demo) or your own

## Key Commands

| Command | Purpose |
|---------|---------|
| `flutter pub run build_runner build` | Regenerate freezed/json models |
| `flutter pub run build_runner watch` | Auto-regenerate on file change |
| `flutter test` | Run test suite |
| `flutter analyze` | Static analysis |
| `r` (hot reload) | Reload in running Flutter app |
| `R` (hot restart) | Full restart |

## Demo Data

Tap **"Try Demo"** on the main screen. Seeds:
- 1 company, 5 employees
- 25 products, 5 categories
- 8 dining tables
- Sample orders & customers

Login with any employee PIN `1234`.

## Known Issues

- `Dart Socket ERROR: reusePort not supported for Windows` — harmless, multicast discovery fails gracefully on Windows
- First build takes ~2 minutes (Zig FFI native compile)
