import 'dart:async';
import 'dart:isolate';
import 'eatery_store.dart';

void _storeIsolateEntryPoint(dynamic message) {
  final initMsg = message as List<Object?>;
  final sendPort = initMsg[0] as SendPort;
  final dbPath = initMsg[1] as String;

  late EateryStore store;
  try {
    store = EateryStore.open(dbPath);
  } catch (e) {
    sendPort.send({'id': -1, 'error': 'Failed to open store: $e'});
    return;
  }

  sendPort.send({'id': 0, 'value': 'ready'});

  final cmdPort = ReceivePort();
  sendPort.send(cmdPort.sendPort);

  cmdPort.listen((raw) {
    final req = raw as Map<String, Object?>;
    final id = req['id'] as int;
    final method = req['method'] as String;
    final args = req['args'] as List<Object?>?;
    void ok(Object? v) => sendPort.send({'id': id, 'value': v});
    void err(String e) => sendPort.send({'id': id, 'error': e});
    try {
      switch (method) {
        case 'execute':
          ok(
            store.execute(
              args![0] as String,
              args.length > 1 ? args[1] as List<Object?>? : null,
            ),
          );
          break;
        case 'query':
          ok(
            store.query(
              args![0] as String,
              args.length > 1 ? args[1] as List<Object?>? : null,
            ),
          );
          break;
        case 'queryScalar':
          ok(
            store.queryScalar(
              args![0] as String,
              args.length > 1 ? args[1] as List<Object?>? : null,
            ),
          );
          break;
        case 'version':
          ok(store.version);
          break;
        case 'setKey':
          try {
            store.setKey(args![0] as String);
            ok('ok');
          } catch (e) {
            err('setKey failed: $e');
          }
          break;
        case 'backup':
          try {
            store.backup(args![0] as String);
            ok('ok');
          } catch (e) {
            err('backup failed: $e');
          }
          break;
        case 'transaction':
          _txn(store, args![0] as List<Map<String, Object?>>, ok, err);
          return;
        case 'close':
          store.close();
          ok('closed');
          cmdPort.close();
          return;
        default:
          err('Unknown method: $method');
      }
    } catch (e) {
      err(e.toString());
    }
  });
}

void _txn(
  EateryStore store,
  List<Map<String, Object?>> cmds,
  void Function(Object?) ok,
  void Function(String) err,
) {
  try {
    store.execute('BEGIN IMMEDIATE');
    for (final c in cmds) {
      store.execute(c['sql'] as String, c['params'] as List<Object?>?);
    }
    store.execute('COMMIT');
    ok('ok');
  } catch (e) {
    try {
      store.execute('ROLLBACK');
    } catch (_) {}
    err('Transaction failed: $e');
  }
}

/// Isolate-backed wrapper around [EateryStore].
///
/// All calls are async — the main isolate never blocks on FFI.
class EateryStoreIsolate {
  EateryStoreIsolate._(this._sendPort, this._receivePort, this._isolate);

  SendPort _sendPort;
  final ReceivePort _receivePort;
  final Isolate _isolate;
  int _nextId = 1;
  final Map<int, Completer<Map<String, Object?>>> _pending = {};
  String? _cachedVersion;

  static Future<EateryStoreIsolate> open(String path) async {
    final rp = ReceivePort();
    final iso = await Isolate.spawn(_storeIsolateEntryPoint, [
      rp.sendPort,
      path,
    ]);
    final proxy = EateryStoreIsolate._(rp.sendPort, rp, iso);
    final cmdPortCompleter = Completer<SendPort>();

    // Single .listen() handles everything: initial messages + responses.
    rp.listen((raw) {
      if (raw is SendPort && !cmdPortCompleter.isCompleted) {
        cmdPortCompleter.complete(raw);
        return;
      }
      // Skip the initial 'ready' signal.
      if (raw is Map<String, Object?> && raw['id'] == 0) return;

      final resp = raw as Map<String, Object?>;
      final id = resp['id'] as int;
      final c = proxy._pending.remove(id);
      if (c != null) {
        if (resp['error'] != null) {
          c.completeError(EateryStoreException(resp['error'] as String));
        } else {
          c.complete(resp);
        }
      }
    });
    // Wait for the isolate's command SendPort, then use it for all future calls.
    final cmdPort = await cmdPortCompleter.future;
    proxy._sendPort = cmdPort;
    return proxy;
  }

  Future<String> get version async {
    if (_cachedVersion != null) return _cachedVersion!;
    final resp = await _call('version');
    return _cachedVersion = resp['value'] as String;
  }

  Future<int> execute(String sql, [List<Object?>? params]) async {
    final resp = await _call('execute', [sql, params]);
    return resp['value'] as int;
  }

  Future<List<Map<String, Object?>>> query(
    String sql, [
    List<Object?>? params,
  ]) async {
    final resp = await _call('query', [sql, params]);
    return (resp['value'] as List<dynamic>)
        .map((e) => (e as Map<String, dynamic>).cast<String, Object?>())
        .toList();
  }

  Future<Object?> queryScalar(String sql, [List<Object?>? params]) async {
    final resp = await _call('queryScalar', [sql, params]);
    return resp['value'];
  }

  Future<void> transaction(List<Map<String, Object?>> commands) async {
    await _call('transaction', [commands]);
  }

  Future<void> close() async {
    await _call('close');
    _receivePort.close();
    _isolate.kill(priority: Isolate.immediate);
  }

  Future<Map<String, Object?>> _call(String method, [List<Object?>? args]) {
    final id = _nextId++;
    final c = Completer<Map<String, Object?>>();
    _pending[id] = c;
    _sendPort.send(<String, Object?>{'id': id, 'method': method, 'args': args});
    return c.future;
  }
}
