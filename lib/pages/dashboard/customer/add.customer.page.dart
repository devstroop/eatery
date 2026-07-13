import 'package:eatery_core/widgets/app_dialog.dart';
import 'package:eatery_core/widgets/app_page_shell.dart';
import 'package:eatery_core/theme/app_typography.dart';
import 'package:eatery/references.dart';
import 'package:eatery_core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eatery_core/providers/order_provider.dart';

Color _pageColor = AppColors.primary;

class AddCustomerPage extends ConsumerStatefulWidget {
  const AddCustomerPage({Key? key, this.addressRequired = false})
    : super(key: key);
  final bool addressRequired;

  @override
  ConsumerState<AddCustomerPage> createState() => _AddCustomerPageState();
}

class _AddCustomerPageState extends ConsumerState<AddCustomerPage> {
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
    FocusNode(),
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _focusNodes[0].requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppPageShell(
      title: 'Add Customer',
      color: _pageColor,
      actions: [
        if (_focusNodes.any((element) => element.hasFocus))
          IconButton(
            icon: const Icon(Icons.done),
            onPressed: () {
              FocusScope.of(context).unfocus();
            },
          ),
      ],
      child: InkWell(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                LabeledCustomTextFormField(
                  controller: _controllerCustomerPhone,
                  label: 'Phone Number (*required)',
                  themeColor: _pageColor,
                  foregroundColor: AppColors.black600,
                  keyboardType: TextInputType.phone,
                  hint: 'Enter phone number',
                  focusNode: _focusNodes[0],
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (value) {
                    _focusNodes[1].requestFocus();
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Phone number is required';
                    } else if (ref
                            .read(customerRepositoryProvider)
                            .getCustomerByPhone(value) !=
                        null) {
                      return 'Phone number already exists';
                    }
                    return null;
                  },
                ),
                SpacingStyle.defaultVerticalSpacing,
                LabeledCustomTextFormField(
                  controller: _controllerCustomerName,
                  label: 'Customer Name',
                  themeColor: _pageColor,
                  foregroundColor: AppColors.black600,
                  hint: 'Enter customer name',
                  textInputAction: TextInputAction.next,
                  focusNode: _focusNodes[1],
                  onFieldSubmitted: (value) {
                    _focusNodes[2].requestFocus();
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Customer name is required';
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
                  focusNode: _focusNodes[3],
                  onFieldSubmitted: (value) {
                    _focusNodes[4].requestFocus();
                  },
                  validator: (value) {
                    if (widget.addressRequired) {
                      if (value == null || value.isEmpty) {
                        return 'Address is required';
                      }
                    }
                    return null;
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
                  focusNode: _focusNodes[4],
                  onFieldSubmitted: (value) {
                    _focusNodes[4].unfocus();
                  },
                ),
                SpacingStyle.defaultVerticalSpacing,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: isActive,
                      activeColor: _pageColor,
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
        child: AppButton.primary(
          onPressed: () async {
            final isValid = _formKey.currentState!.validate();
            if (!isValid) {
              return;
            }
            _formKey.currentState!.save();

            Customer customer = Customer(
              name: _controllerCustomerName.text,
              phone: _controllerCustomerPhone.text,
              address: _controllerCustomerAddress.text,
              landmark: _controllerCustomerLandmark.text,
              isActive: isActive,
            );
            await ref
                .read(customerRepositoryProvider)
                .saveCustomer(customer)
                .then((value) {
                  AppDialog.showMessage(
                    context,
                    message: 'Customer added successfully',
                    type: MessageType.success,
                  ).then((value) => Navigator.pop(this.context, customer));
                })
                .onError((error, stackTrace) {
                  AppDialog.showMessage(
                    context,
                    message: error.toString(),
                    type: MessageType.error,
                  );
                });
          },
          label: 'Save',
        ),
      ),
    );
  }
}
