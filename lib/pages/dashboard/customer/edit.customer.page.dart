import 'package:eatery_core/widgets/app_dialog.dart';
import 'package:eatery_core/widgets/app_page_shell.dart';
import 'package:eatery_core/theme/app_typography.dart';
import 'package:eatery/references.dart';
import 'package:eatery_core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eatery_core/providers/order_provider.dart';

Color _pageColor = AppColors.primary;

class EditCustomerPage extends ConsumerStatefulWidget {
  const EditCustomerPage({Key? key, required this.customer}) : super(key: key);
  final Customer customer;

  @override
  ConsumerState<EditCustomerPage> createState() => _EditCustomerPageState();
}

class _EditCustomerPageState extends ConsumerState<EditCustomerPage> {
  bool isActive = true;
  final TextEditingController _controllerCustomerName = TextEditingController();
  final TextEditingController _controllerCustomerPhone =
      TextEditingController();
  final TextEditingController _controllerCustomerAddress =
      TextEditingController();
  final TextEditingController _controllerCustomerLandmark =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final List<FocusNode> _focusNodes = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
  ];

  @override
  initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        _controllerCustomerName.text = widget.customer.name ?? '';
        _controllerCustomerPhone.text = widget.customer.phone;
        _controllerCustomerAddress.text = widget.customer.address ?? '';
        _controllerCustomerLandmark.text = widget.customer.landmark ?? '';
        isActive = widget.customer.isActive;
      });

      _focusNodes[0].requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppPageShell(
      title: 'Edit Customer',
      color: _pageColor,
      actions: [
        if (_focusNodes[0].hasFocus ||
            _focusNodes[1].hasFocus ||
            _focusNodes[2].hasFocus ||
            _focusNodes[3].hasFocus)
          IconButton(
            icon: const Icon(Icons.done),
            onPressed: () {
              FocusScope.of(context).unfocus();
            },
          ),
      ],
      child: InkWell(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                LabeledCustomTextFormField(
                  controller: _controllerCustomerName,
                  label: 'Customer Name',
                  themeColor: _pageColor,
                  foregroundColor: AppColors.black600,
                  hint: 'Enter customer name',
                  focusNode: _focusNodes[0],
                  onFieldSubmitted: (v) {
                    _focusNodes[1].requestFocus();
                  },
                ),
                const SizedBox(height: 6.0),
                LabeledCustomTextFormField(
                  controller: _controllerCustomerPhone,
                  label: 'Phone Number',
                  themeColor: _pageColor,
                  foregroundColor: AppColors.black600,
                  keyboardType: TextInputType.phone,
                  hint: 'Enter phone number',
                  focusNode: _focusNodes[1],
                  onFieldSubmitted: (v) {
                    _focusNodes[2].requestFocus();
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Phone number is required';
                    } else {
                      final existing = ref
                          .read(customerRepositoryProvider)
                          .getCustomerByPhone(value.trim());
                      if (existing != null &&
                          existing.id != widget.customer.id) {
                        return 'Phone number already exists';
                      }
                    }
                    return null;
                  },
                ),
                SpacingStyle.defaultVerticalSpacing,
                LabeledCustomTextFormField(
                  controller: _controllerCustomerAddress,
                  label: 'Address',
                  themeColor: _pageColor,
                  foregroundColor: AppColors.black600,
                  keyboardType: TextInputType.streetAddress,
                  hint: 'Enter full address',
                  multiline: true,
                  focusNode: _focusNodes[2],
                  onFieldSubmitted: (v) {
                    _focusNodes[3].requestFocus();
                  },
                ),
                SpacingStyle.defaultVerticalSpacing,
                LabeledCustomTextFormField(
                  controller: _controllerCustomerLandmark,
                  label: 'Landmark (Optional)',
                  themeColor: _pageColor,
                  foregroundColor: AppColors.black600,
                  keyboardType: TextInputType.text,
                  hint: 'Enter landmark',
                  multiline: true,
                  focusNode: _focusNodes[3],
                  onFieldSubmitted: (v) {
                    _focusNodes[4].requestFocus();
                  },
                ),
                SpacingStyle.defaultVerticalSpacing,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: isActive,
                      onChanged: (value) {
                        setState(() {
                          isActive = value ?? false;
                        });
                      },
                    ),
                    const SizedBox(width: 6.0),
                    Text(
                      'Active',
                      style: AppTypography.bodyLarge.copyWith(color: AppColors.black600),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: AppColors.white,
        child: AppButton.primary(
          onPressed: () async {
            if (!_formKey.currentState!.validate()) {
              return;
            }
            _formKey.currentState!.save();

            final customer = widget.customer.copyWith(
              name: _controllerCustomerName.text,
              phone: _controllerCustomerPhone.text,
              address: _controllerCustomerAddress.text,
              landmark: _controllerCustomerLandmark.text,
              isActive: isActive,
            );
            ref
                .read(customerRepositoryProvider)
                .saveCustomer(customer)
                .then(
                  (value) => AppDialog.showMessage(
                    context,
                    message: 'Customer updated successfully',
                    type: MessageType.success,
                    onConfirm: () {
                      Navigator.pop(context);
                    },
                  ),
                )
                .onError(
                  (error, stackTrace) => AppDialog.showMessage(
                    context,
                    message: 'Error updating customer',
                    type: MessageType.error,
                    onConfirm: () {
                      Navigator.pop(context);
                    },
                  ),
                );
          },
          label: 'Save',
        ),
      ),
    );
  }
}
