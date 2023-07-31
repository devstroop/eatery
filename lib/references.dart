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
export 'package:permission_handler/permission_handler.dart';
export 'package:external_path/external_path.dart';
export 'package:fluttertoast/fluttertoast.dart';
// Google packages
export 'package:googleapis_auth/auth_io.dart';
// Internal references
export './constants/style/color_style.dart';
export './constants/style/spacing_style.dart';
export './constants/validators/gstin_validator.dart';
export './constants/utils/app_file_system.dart';
// Internal references
export './widgets/imageWidgets/leading.imageWidget.dart';
export './widgets/labels/caption.label.dart';
export './widgets/posWidgets/circularCategory.posWidget.dart';
export './widgets/card/menu.card.dart';
export './widgets/buttons/upload.button.dart';
export './widgets/card/diningTableSelection.card.dart';
export './widgets/badges/foodType.badge.dart';
export './widgets/textFields/search.textField.dart';
export './widgets/switches/toggle.switch.dart';
// Internal references
export './components/bottom_view_grip.dart';
export './components/secondary_button.dart';
export './components/custom_text_from_field.dart';
export './components/selectable_card.dart';
export './components/bottomsheets/forgot_password_bottomsheet.dart';
export './components/bottomsheets/upgrade_to_access_bottomsheet.dart';
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
export './components/bottomsheets/upload_image_bottomsheet.dart';
export './components/bottomsheets/help_bottom_sheet.dart';
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
export './pages/dashboard/components/dashboardHeader.dart';
export './pages/dashboard/components/notifications/upgrade.notification.dart';
// Internal references
export './pages/dashboard/product/kitchenDishes/addKitchenDish.page.dart';
export './pages/dashboard/product/kitchenDishes/editKitchenDish.page.dart';
export './pages/dashboard/product/kitchenDishes/kitchenDishes.page.dart';
// Internal references
export './pages/dashboard/product/inventoryItem/addInventoryItem.page.dart';
export './pages/dashboard/product/inventoryItem/editInventoryItem.page.dart';
export './pages/dashboard/product/inventoryItem/inventoryItems.page.dart';
// Internal references
export './pages/dashboard/product/productCategory/addProductCategory.page.dart';
export './pages/dashboard/product/productCategory/editProductCategory.page.dart';
export './pages/dashboard/product/productCategory/productCategories.page.dart';
// Internal references
export './pages/dashboard/product/search_product.delegate.dart';

// Internal references
export './pages/dashboard/diningTable/category/addDiningTableCategory.page.dart';
export './pages/dashboard/diningTable/category/editDiningTableCategory.page.dart';
export './pages/dashboard/diningTable/category/diningTableCategories.page.dart';
// Internal references
export './pages/dashboard/diningTable/addDiningTable.page.dart';
export './pages/dashboard/diningTable/editDiningTable.page.dart';
export './pages/dashboard/diningTable/diningTables.page.dart';
// Internal references
export './pages/dashboard/customer/addCustomer.page.dart';
export './pages/dashboard/customer/editCustomer.page.dart';
export './pages/dashboard/customer/customers.page.dart';
export './pages/dashboard/customer/search_customer.delegate.dart';
// Internal references
export './pages/dashboard/staff/staffs.page.dart';
export './pages/dashboard/staff/addStaff.page.dart';
export './pages/dashboard/staff/editStaff.page.dart';
// Internal references
export './pages/dashboard/help/help.page.dart';
// Internal references
export './pages/dashboard/importExport/importExport.page.dart';
// Internal references
export './pages/dashboard/transaction/transactions.page.dart';
export './pages/dashboard/transaction/transactionDetails.page.dart';
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
export './pages/createCompany/createCompany.page.dart';
export './pages/createCompany/components/body1.dart';
export './pages/createCompany/components/body2.dart';
export './pages/createCompany/components/body3.dart';
export './pages/createCompany/components/body4.dart';
export './pages/createCompany/components/body5.dart';
export './pages/createCompany/components/body6.dart';
export './pages/createCompany/components/createCompany.bottomAppBar.dart';
export './pages/createCompany/createCompanyResult.page.dart';
// Internal references
export './pages/dashboard/settings/settings.page.dart';
export './pages/dashboard/settings/company/showCompany.page.dart';
export './pages/dashboard/settings/company/editCompany.page.dart';
export './pages/dashboard/settings/taxSlab/addTaxSlab.page.dart';
export './pages/dashboard/settings/taxSlab/editTaxSlab.page.dart';
export './pages/dashboard/settings/taxSlab/taxSlabs.page.dart';
export './pages/dashboard/settings/currency/showCurrencyRegion.page.dart';
// Internal references
export './pages/backupRestore/backupRestore.page.dart';
// Internal references
export 'pages/dashboard/utility/imageLibrary.page.dart';
export './widgets/containers/image.container.dart';
export './widgets/dialogs/showConfirmationDialog.dart';

