/// Domain-coupled widgets that still live in the package layer.
///
/// These depend on providers, models, or sync logic and will be
/// migrated to the app layer in a future stage once their
/// dependencies are resolved.
library;

export 'floor_plan_widget.dart';
export 'modifier_sheet.dart';
export 'sync_host_settings_sheet.dart';
export 'sync_status_chip.dart';
