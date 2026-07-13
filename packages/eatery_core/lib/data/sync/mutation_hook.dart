/// Signature for a function that records a data mutation.
///
/// [entityType] is the singular noun (e.g. "order", "product", "customer").
/// [entityId] is the primary-key value of the affected row.
/// [operation] is "save" or "delete".
/// [data] is the full entity map (or just the id for deletes).
typedef MutationHookCallback = void Function(
  String entityType,
  int entityId,
  String operation,
  Map<String, dynamic> data,
);

MutationHookCallback? _mutationHook;

/// Registers the global mutation hook.
///
/// Called once by [SyncCoordinator] during initialization. Cleared on dispose.
void setMutationHook(MutationHookCallback hook) {
  _mutationHook = hook;
}

/// Clears the global mutation hook (called on coordinator dispose).
void clearMutationHook() {
  _mutationHook = null;
}

/// Records a mutation through the active hook, if set.
///
/// Safe to call from any repository method after a successful write. No-ops
/// when sync is not active, so there is zero coupling between repositories
/// and the sync layer.
void notifyMutation(
  String entityType,
  int entityId,
  String operation,
  Map<String, dynamic> data,
) {
  _mutationHook?.call(entityType, entityId, operation, Map<String, dynamic>.of(data));
}
