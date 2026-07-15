/// Signature for a function that records a data mutation.
///
/// [entityType] is the singular noun (e.g. "order", "product", "customer").
/// [entityId] is the primary-key value of the affected row.
/// [operation] is "save" or "delete".
/// [data] is the full entity map (or just the id for deletes).
typedef MutationHookCallback =
    void Function(
      String entityType,
      int entityId,
      String operation,
      Map<String, dynamic> data,
    );

/// A scoped, non‑global mutation hook that repositories call after writes.
///
/// Instead of a top-level mutable variable (which would cause cross‑talk
/// between multiple [SyncCoordinator] instances), the hook is stored on a
/// dedicated object that callers hold by reference.  [notifyMutation] is
/// re‑exported as a convenient free function that forwards to
/// [MutationHook.instance].
///
/// During normal operation only one hook is active, but tests or code that
/// spawns multiple coordinators will not interfere with each other because
/// each coordinator creates its own [MutationHook].
class MutationHook {
  MutationHookCallback? _callback;

  /// Sets the mutation callback.
  void set(MutationHookCallback cb) => _callback = cb;

  /// Clears the mutation callback.
  void clear() => _callback = null;

  /// Forwards [notifyMutation] to the local callback.
  void notify(
    String entityType,
    int entityId,
    String operation,
    Map<String, dynamic> data,
  ) {
    _callback?.call(entityType, entityId, operation, Map.of(data));
  }

  // ── Singleton that backs the free‑function API ──

  static MutationHook? _instance;

  /// Returns the active [MutationHook], creating a default one if needed.
  static MutationHook get instance {
    _instance ??= MutationHook();
    return _instance!;
  }

  /// Replaces the shared hook instance (used by [SyncCoordinator]).
  static void install(MutationHook hook) => _instance = hook;

  /// Resets the shared instance to a fresh hook (used on coordinator dispose).
  static void reset() {
    _instance?.clear();
    _instance = null;
  }

  // ── Convenience that delegates to [instance.notify] ──

  /// Records a mutation through the active hook, if set.
  ///
  /// Safe to call from any repository method after a successful write. No-ops
  /// when sync is not active, so there is zero coupling between repositories
  /// and the sync layer.
  static void notifyMutation(
    String entityType,
    int entityId,
    String operation,
    Map<String, dynamic> data,
  ) {
    instance._callback?.call(
      entityType,
      entityId,
      operation,
      Map<String, dynamic>.of(data),
    );
  }
}

/// Convenience re‑export so call sites can keep writing `notifyMutation(...)`.
void notifyMutation(
  String entityType,
  int entityId,
  String operation,
  Map<String, dynamic> data,
) => MutationHook.notifyMutation(entityType, entityId, operation, data);

/// Registers the global mutation hook.
@Deprecated('Use MutationHook.instance.set(...) instead')
void setMutationHook(MutationHookCallback hook) {
  MutationHook.instance.set(hook);
}

/// Clears the global mutation hook.
@Deprecated('Use MutationHook.instance.clear() or MutationHook.reset() instead')
void clearMutationHook() {
  MutationHook.instance.clear();
}
