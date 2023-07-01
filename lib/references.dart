// External packages by dart
export 'dart:io';
export 'dart:convert';
// External packages by flutter
export 'package:flutter/material.dart';
export 'package:flutter/services.dart';
export 'package:flutter/rendering.dart';
// External packages by devstroop
export 'package:eatery_db/eatery_db.dart';
export 'package:devdart_windows_hdsn/devdart_windows_hdsn.dart';
export 'package:devdart_windows_hdsn/drive.dart';
// External refs by devstroop (*deprecated)
export 'package:eatery_components/others/bottom_sheet.grip.dart';
export 'package:eatery_components/titles/page.title.dart';
export 'package:eatery_components/buttons/primary.button.dart';
export 'package:eatery_components/bottomsheets/tax_slab.bottomsheet.dart';
// Integrated packages
export './support/bluetooth_thermal_printer/bluetooth_thermal_printer.dart';
// External packages
export 'package:path/path.dart';
export 'package:path_provider/path_provider.dart';
export 'package:flutter_native_splash/flutter_native_splash.dart';
export 'package:file_picker/file_picker.dart';
export 'package:image_picker/image_picker.dart';
export 'package:flutter_archive/flutter_archive.dart';
export 'package:platform_device_id/platform_device_id.dart';
export 'package:url_launcher/url_launcher.dart';
export 'package:sn_progress_dialog/sn_progress_dialog.dart';
export 'package:currency_picker/currency_picker.dart';
export 'package:clipboard/clipboard.dart';
export 'package:lottie/lottie.dart';
export 'package:number_to_words/number_to_words.dart';
export 'package:date_time_picker/date_time_picker.dart';
export 'package:flutter_svg/svg.dart';
export 'package:flutter_secure_storage/flutter_secure_storage.dart';
export 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';
// Google packages
export 'package:googleapis_auth/auth_io.dart';
// Internal references
export './constants/style/color_style.dart';
export './constants/style/spacing_style.dart';
export './constants/validators/gstin_validator.dart';
export './constants/utils/app_file_system.dart';
// Internal references
export './widgets/image_widgets/leading.image_widget.dart';
export './widgets/labels/caption.label.dart';
export './widgets/pos_widgets/circular_category.pos_widget.dart';
export './widgets/card/menu.card.dart';
export './widgets/buttons/upload.button.dart';
export './widgets/card/dining_table_selection.card.dart';
export './widgets/badges/foodType.badge.dart';
export './widgets/text_fields/search.textField.dart';
export './widgets/switches/toggle.switch.dart';
// Internal references
export './components/bottom_sheets/forgot_password_bottomsheet.dart';
export './components/bottom_sheets/upgrade_to_access_bottomsheet.dart';
export './components/bottom_sheets/upload_image_bottomsheet.dart';
export './components/bottom_sheets/help_bottom_sheet.dart';
export './components/bottom_view_grip.dart';
export './components/secondary_button.dart';
export './components/custom_text_from_field.dart';
export './components/selectable_card.dart';
export './components/labeled_custom_text_from_field.dart';
export './components/notification_widget.dart';
export './components/pos_category_widget.dart';
export './components/dialog_box.dart';
export './components/menu_tile.dart';
export './components/checkout_product_card.dart';
export './components/custom_button.dart';
export './components/pos_waiter_card.dart';
export './components/pos_order_type_selection_button.dart';
export './components/special_button.dart';
export './components/product_card.dart';
export './components/loaders/loading_screen.dart';
export './components/custom_dialog_box.dart';
// Internal references
export './constants/global_variables.dart';
export './constants/utils/utils.dart';
export './constants/utils/file_utils.dart';
export './constants/utils/email_validator.dart';
export './constants/validators/phone_validator.dart';
export './constants/plugins/license.dart';
export './constants/utils/calculations.dart';
export './constants/extensions/string_extension.dart';
// Internal references
export './services/utility/library_image.dart';
export './services/utility/generate.dart';
export './services/cloud/google_drive.dart';
export './services/printing/print_invoice.dart';
export './services/utility/share.dart';
export './services/cloud/secure_storage.dart';
// Internal references
export './pages/activation/upgrade.page.dart';
// Internal references
export './pages/dashboard/dashboard.page.dart';
// Internal references
export './pages/dashboard/components/dashboard_header.dart';
export './pages/dashboard/components/notifications/upgrade.notification.dart';
// Internal references
export './pages/dashboard/product/kitchenDishes/add_kitchen_dish.page.dart';
export './pages/dashboard/product/kitchenDishes/edit_kitchen_dish.page.dart';
export './pages/dashboard/product/kitchenDishes/kitchen_dishes.page.dart';
// Internal references
export './pages/dashboard/product/inventoryItem/add_inventory_item.page.dart';
export './pages/dashboard/product/inventoryItem/edit_inventory_item.page.dart';
export './pages/dashboard/product/inventoryItem/inventory_items.page.dart';
// Internal references
export './pages/dashboard/product/productCategory/add_product_category.page.dart';
export './pages/dashboard/product/productCategory/edit_product_category.page.dart';
export './pages/dashboard/product/productCategory/product_categories.page.dart';
// Internal references
export './pages/dashboard/dining_table/category/add_dining_table_category.page.dart';
export './pages/dashboard/dining_table/category/edit_dining_table_category.page.dart';
export './pages/dashboard/dining_table/category/dining_table_categories.page.dart';
// Internal references
export './pages/dashboard/dining_table/add_dining_table.page.dart';
export './pages/dashboard/dining_table/edit_dining_table.page.dart';
export './pages/dashboard/dining_table/dining_tables.page.dart';
// Internal references
export './pages/dashboard/stock/stocks.page.dart';
// Internal references
export './pages/dashboard/master/add_master.page.dart';
export './pages/dashboard/master/edit_master.page.dart';
export './pages/dashboard/master/masters.page.dart';
// Internal references
export './pages/dashboard/user/users.page.dart';
export './pages/dashboard/user/addUser.page.dart';
export './pages/dashboard/user/editUser.page.dart';
// Internal references
export './pages/dashboard/help/help.page.dart';
// Internal references
export './pages/dashboard/importExport/importExport.page.dart';
// Internal references
export './pages/dashboard/transaction/transactions.page.dart';
export './pages/dashboard/transaction/transactionDetails.page.dart';
export './pages/dashboard/transaction/printSalesReport.page.dart';
// Internal references
export './pages/dashboard/pos/pointOfSale.page.dart';
export './pages/dashboard/pos/checkout.page.dart';
export './pages/dashboard/pos/orderConfirmation.page.dart';
// Internal references
export './pages/dashboard/pos/views/cart.view.dart';
export './pages/dashboard/pos/views/dininigTableSelection.view.dart';
export './pages/dashboard/pos/views/kProduct.view.dart';
export './pages/dashboard/pos/views/waiterSelection.view.dart';
// Internal references
export './pages/authentication/login.page.dart';
export './pages/authentication/logout.page.dart';
// Internal references
export './pages/dashboard/utility/calculator.page.dart';
// Internal references
export './pages/create_company/create_company.page.dart';
export './pages/create_company/components/body1.dart';
export './pages/create_company/components/body2.dart';
export './pages/create_company/components/body3.dart';
export './pages/create_company/components/body4.dart';
export './pages/create_company/components/body5.dart';
export './pages/create_company/components/body6.dart';
export './pages/create_company/components/create_company.bottom_app_bar.dart';
export './pages/create_company/create_company_result.page.dart';
// Internal references
export './pages/dashboard/settings/settings.page.dart';
export './pages/dashboard/settings/company/show_company.page.dart';
export './pages/dashboard/settings/company/edit_company.page.dart';
export './pages/dashboard/settings/taxSlab/add_tax_slab.page.dart';
export './pages/dashboard/settings/taxSlab/edit_tax_slab.page.dart';
export './pages/dashboard/settings/taxSlab/tax_slabs.page.dart';
export './pages/dashboard/settings/currency/show_currency_region.page.dart';
// Internal references
export './pages/backup_restore/backup_restore.page.dart';
// Internal references
export './widgets/bottomSheets/image_library.bottomsheet.dart';
export './widgets/containers/image.container.dart';
export './widgets/dialogs/show_confirmation_dialog.dart';


export 'package:uicons/uicons.dart';