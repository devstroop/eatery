library eatery_core;

/// Models
export 'data/models/eatery_db.dart';

/// Database
export 'data/database/eatery_db_shim.dart';
export 'data/database/eatery_database.dart';
export 'data/database/native/eatery_store.dart';
export 'data/database/native/eatery_store_interface.dart';
export 'data/database/native/eatery_schema.dart';
export 'data/database/native/schema_migrator.dart';
export 'data/database/native/store_config.dart';

/// Sync
export 'data/sync/sync.dart';
export 'data/sync/sync_service.dart';
export 'data/sync/sync_client.dart';
export 'data/sync/sync_server.dart';
export 'data/sync/sync_message.dart';
export 'data/sync/op_log_entry.dart';
export 'data/sync/op_log_service.dart';
export 'data/sync/mdns_service.dart';

/// Theme
export 'theme/app_colors.dart';
export 'theme/app_shadows.dart';
export 'theme/app_spacing.dart';
export 'theme/app_typography.dart';
export 'theme/app_theme.dart';

/// Extensions
export 'extensions/double_ext.dart';
export 'extensions/string_ext.dart';

/// Providers
export 'providers/database_provider.dart';
export 'providers/company_provider.dart';
export 'providers/order_provider.dart';
export 'providers/product_provider.dart';
export 'providers/cart_provider.dart';
export 'providers/printer_provider.dart';
export 'providers/auth_session.dart';

/// Repositories
export 'data/repositories/company_repository.dart';
export 'data/repositories/company_repository_sqlite.dart';
export 'data/repositories/customer_repository.dart';
export 'data/repositories/customer_repository_sqlite.dart';
export 'data/repositories/dining_table_repository.dart';
export 'data/repositories/dining_table_repository_sqlite.dart';
export 'data/repositories/order_repository.dart';
export 'data/repositories/order_repository_sqlite.dart';
export 'data/repositories/payment_repository.dart';
export 'data/repositories/payment_repository_sqlite.dart';
export 'data/repositories/printer_repository.dart';
export 'data/repositories/product_repository.dart';
export 'data/repositories/product_repository_sqlite.dart';
export 'data/repositories/sqlite_preference_store.dart';
export 'data/repositories/staff_repository.dart';
export 'data/repositories/staff_repository_sqlite.dart';
export 'data/repositories/subscription_repository.dart';
export 'data/repositories/subscription_repository_sqlite.dart';
export 'data/repositories/tax_repository.dart';
export 'data/repositories/tax_repository_sqlite.dart';

/// Core widgets
export 'widgets/widgets.dart';

/// Utils
export 'utils/device_id.dart';
export 'utils/responsive.dart';
