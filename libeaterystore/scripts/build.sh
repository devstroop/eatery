#!/usr/bin/env bash
# build.sh — build the libeaterystore native artifact for a target platform and
# place it where the Flutter platform build expects it.
#
# Usage:
#   scripts/build.sh macos     # libeaterystore.dylib (bundled by macos/Podfile)
#   scripts/build.sh windows   # eaterystore.dll (copied by windows/CMakeLists)
#   scripts/build.sh android   # libeaterystore.so -> android jniLibs (all ABIs)
#   scripts/build.sh ios        # libeaterystore.a (link into Runner, see README)
#   scripts/build.sh linux     # libeaterystore.so (x86_64)
#
# Requires Zig 0.15.x. Android additionally requires ANDROID_NDK_HOME.
set -euo pipefail

cd "$(dirname "$0")/.."          # -> libeaterystore/
LIB_ROOT="$(pwd)"
APP_ROOT="$(cd .. && pwd)"       # -> eatery/

command -v zig >/dev/null 2>&1 || { echo "ERROR: zig not found in PATH"; exit 1; }

PLATFORM="${1:-macos}"
echo "=== build libeaterystore ($PLATFORM) ==="

case "$PLATFORM" in
  macos)
    zig build shared-lib
    echo "Built: zig-out/lib/libeaterystore.dylib (bundled via macos/Podfile)"
    ;;

  linux)
    zig build shared-lib -Dtarget=x86_64-linux-gnu --release=fast
    echo "Built: zig-out/lib/libeaterystore.so"
    ;;

  windows)
    zig build shared-lib -Dtarget=x86_64-windows-gnu --release=fast
    echo "Built: zig-out/bin/eaterystore.dll (copied via windows/CMakeLists.txt)"
    ;;

  ios)
    zig build static-lib -Dtarget=aarch64-ios --release=fast
    echo "Built: zig-out/lib/libeaterystore.a (device arm64)."
    echo "Link it into the Runner target (see libeaterystore/README.md)."
    ;;

  android)
    : "${ANDROID_NDK_HOME:?ANDROID_NDK_HOME must be set for Android builds}"
    API="${ANDROID_API_LEVEL:-22}"
    declare -a ABIS=(
      "arm64-v8a:aarch64-linux-android"
      "armeabi-v7a:arm-linux-androideabi"
      "x86_64:x86_64-linux-android"
    )
    for pair in "${ABIS[@]}"; do
      abi="${pair%%:*}"; tgt="${pair##*:}"
      ANDROID_API_LEVEL="$API" zig build shared-lib -Dtarget="$tgt" --release=fast
      dest="$APP_ROOT/android/app/src/main/jniLibs/$abi"
      mkdir -p "$dest"
      cp -f zig-out/lib/libeaterystore.so "$dest/"
      echo "Placed: android/app/src/main/jniLibs/$abi/libeaterystore.so"
    done
    ;;

  *)
    echo "Unknown platform: $PLATFORM"
    echo "Use one of: macos | linux | windows | ios | android"
    exit 1
    ;;
esac

echo "=== done ($PLATFORM) ==="
