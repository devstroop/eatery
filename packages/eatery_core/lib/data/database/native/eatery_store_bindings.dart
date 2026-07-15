import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';

/// Opaque native store handle (Zig `*Store`).
final class EsStore extends Opaque {}

// ---------------------------------------------------------------------------
// Native (C) signatures
// ---------------------------------------------------------------------------

typedef _EsOpenNative = Pointer<EsStore> Function(Pointer<Utf8> path);
typedef EsOpenDart = Pointer<EsStore> Function(Pointer<Utf8> path);

typedef _EsCloseNative = Void Function(Pointer<EsStore> store);
typedef EsCloseDart = void Function(Pointer<EsStore> store);

typedef _EsKeyNative =
    Void Function(Pointer<EsStore> store, Pointer<Uint8> key, Int32 keyLen);
typedef EsKeyDart =
    void Function(Pointer<EsStore> store, Pointer<Uint8> key, int keyLen);

typedef _EsExecNative =
    LongLong Function(
      Pointer<EsStore> store,
      Pointer<Utf8> sql,
      Pointer<Utf8> paramsJson,
    );
typedef EsExecDart =
    int Function(
      Pointer<EsStore> store,
      Pointer<Utf8> sql,
      Pointer<Utf8> paramsJson,
    );

typedef _EsQueryNative =
    Pointer<Utf8> Function(
      Pointer<EsStore> store,
      Pointer<Utf8> sql,
      Pointer<Utf8> paramsJson,
    );
typedef EsQueryDart =
    Pointer<Utf8> Function(
      Pointer<EsStore> store,
      Pointer<Utf8> sql,
      Pointer<Utf8> paramsJson,
    );

typedef _EsLastErrorNative = Pointer<Utf8> Function(Pointer<EsStore> store);
typedef EsLastErrorDart = Pointer<Utf8> Function(Pointer<EsStore> store);

typedef _EsFreeNative = Void Function(Pointer<Utf8> ptr);
typedef EsFreeDart = void Function(Pointer<Utf8> ptr);

typedef _EsVersionNative = Pointer<Utf8> Function();
typedef EsVersionDart = Pointer<Utf8> Function();

typedef _EsBackupNative =
    Int32 Function(Pointer<EsStore> store, Pointer<Utf8> targetPath);
typedef EsBackupDart =
    int Function(Pointer<EsStore> store, Pointer<Utf8> targetPath);

typedef _EsVacuumNative = Int32 Function(Pointer<EsStore> store);
typedef EsVacuumDart = int Function(Pointer<EsStore> store);

typedef _EsOptimizeNative = Int32 Function(Pointer<EsStore> store);
typedef EsOptimizeDart = int Function(Pointer<EsStore> store);

/// Low-level `dart:ffi` bindings for libeaterystore.
///
/// This is intentionally thin — the higher-level [EateryStore] wrapper adds
/// JSON marshaling and Dart-friendly types on top.
class EateryStoreBindings {
  EateryStoreBindings(DynamicLibrary lib)
    : esOpen = lib.lookupFunction<_EsOpenNative, EsOpenDart>('es_open'),
      esClose = lib.lookupFunction<_EsCloseNative, EsCloseDart>('es_close'),
      esKey = lib.lookupFunction<_EsKeyNative, EsKeyDart>('es_key'),
      esExec = lib.lookupFunction<_EsExecNative, EsExecDart>('es_exec'),
      esQuery = lib.lookupFunction<_EsQueryNative, EsQueryDart>('es_query'),
      esBackup = lib.lookupFunction<_EsBackupNative, EsBackupDart>('es_backup'),
      esVacuum = lib.lookupFunction<_EsVacuumNative, EsVacuumDart>('es_vacuum'),
      esOptimize = lib.lookupFunction<_EsOptimizeNative, EsOptimizeDart>(
        'es_optimize',
      ),
      esLastError = lib.lookupFunction<_EsLastErrorNative, EsLastErrorDart>(
        'es_last_error',
      ),
      esFree = lib.lookupFunction<_EsFreeNative, EsFreeDart>('es_free'),
      esVersion = lib.lookupFunction<_EsVersionNative, EsVersionDart>(
        'es_version',
      );

  final EsOpenDart esOpen;
  final EsCloseDart esClose;
  final EsKeyDart esKey;
  final EsExecDart esExec;
  final EsQueryDart esQuery;
  final EsBackupDart esBackup;
  final EsVacuumDart esVacuum;
  final EsOptimizeDart esOptimize;
  final EsLastErrorDart esLastError;
  final EsFreeDart esFree;
  final EsVersionDart esVersion;

  /// Loads libeaterystore for the current platform, mirroring the
  /// SoftEtherApp loader conventions (bundle path first, dev fallback last).
  static DynamicLibrary load() {
    if (Platform.isMacOS) {
      // 1. App bundle: Runner.app/Contents/Frameworks (via @rpath)
      // 2. System path
      // 3. Dev fallback: zig build output
      for (final name in const [
        'libeaterystore.dylib',
        '@rpath/libeaterystore.dylib',
      ]) {
        try {
          return DynamicLibrary.open(name);
        } catch (_) {}
      }
      return DynamicLibrary.open(
        'libeaterystore/zig-out/lib/libeaterystore.dylib',
      );
    } else if (Platform.isLinux) {
      try {
        return DynamicLibrary.open('libeaterystore.so');
      } catch (_) {
        return DynamicLibrary.open(
          'libeaterystore/zig-out/lib/libeaterystore.so',
        );
      }
    } else if (Platform.isAndroid) {
      return DynamicLibrary.open('libeaterystore.so');
    } else if (Platform.isWindows) {
      try {
        return DynamicLibrary.open('eaterystore.dll');
      } catch (_) {
        return DynamicLibrary.open(
          'libeaterystore/zig-out/bin/eaterystore.dll',
        );
      }
    } else if (Platform.isIOS) {
      // Static lib linked into the app binary → symbols are in the process.
      return DynamicLibrary.process();
    }
    throw UnsupportedError('Unsupported platform: ${Platform.operatingSystem}');
  }
}
