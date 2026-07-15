import 'package:eatery_core/data/models/eatery_db.dart';
import 'package:eatery_core/data/sync/sync_coordinator.dart';

/// Helpers to track entity mutations through the sync coordinator.
///
/// Usage: after a successful repository save/delete, call [trackSave],
/// [trackDelete], etc. with the updated entity and coordinator.
class MutationTracker {
  /// Logs a "create" or "update" op after an entity save.
  static void trackSave({
    required SyncCoordinator coordinator,
    required String entityType,
    required Object entity,
    Object? previousEntity,
  }) {
    final data = _entityToMap(entity);
    final prevData = previousEntity != null
        ? _entityToMap(previousEntity)
        : null;
    final id = _entityId(entity);
    if (id == null) return;

    coordinator.trackMutation(
      entityType: entityType,
      entityId: id,
      operation: prevData != null ? 'update' : 'create',
      data: data,
      prevData: prevData,
    );
  }

  /// Logs a "delete" or "void" op.
  static void trackDelete({
    required SyncCoordinator coordinator,
    required String entityType,
    required int entityId,
    Map<String, dynamic>? lastData,
  }) {
    coordinator.trackMutation(
      entityType: entityType,
      entityId: entityId,
      operation: 'delete',
      data: lastData ?? {},
    );
  }

  // ── Private helpers ──

  static Map<String, dynamic> _entityToMap(Object entity) {
    if (entity is Map) return entity as Map<String, dynamic>;
    try {
      // All freezed models expose toJson() as a real instance method.
      // toMap() is an extension method and can't be dispatched via dynamic.
      return (entity as dynamic).toJson() as Map<String, dynamic>;
    } catch (_) {
      return {};
    }
  }

  static int? _entityId(Object entity) {
    if (entity is Order) return entity.id;
    if (entity is OrderProduct) return entity.id;
    if (entity is Product) return entity.id;
    if (entity is Customer) return entity.id;
    if (entity is DiningTable) return entity.id;
    if (entity is Company) return entity.id;
    if (entity is Staff) return entity.id;
    if (entity is Payment) return entity.id;
    if (entity is TaxSlab) return entity.id;
    if (entity is Subscription) return entity.id;
    if (entity is ProductCategory) return entity.id;
    if (entity is DiningTableCategory) return entity.id;
    try {
      return (entity as dynamic).id as int?;
    } catch (_) {
      return null;
    }
  }
}
