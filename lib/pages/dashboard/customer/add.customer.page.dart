import 'package:eatery_core/theme/app_typography.dart';
import 'package:eatery/references.dart';
import 'package:eatery_core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eatery_core/providers/order_provider.dart';

Color _pageColor = AppColors.primary;

class AddCustomerPage extends ConsumerStatefulWidget {
  const AddCustomerPage({super.key, this.addressRequired = false});
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
      bottomAction: AppButton.primary(
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
      child: InkWell(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                AppFormField(
                  controller: _controllerCustomerPhone,
                  label: 'Phone Number (*required)',
                  keyboardType: TextInputType.phone,
                  hint: 'Enter phone number',
                  focusNode: _focusNodes[0],
                  focusNext: _focusNodes[1],
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
                AppFormField(
                  controller: _controllerCustomerName,
                  label: 'Customer Name',
                  hint: 'Enter customer name',
                  focusNode: _focusNodes[1],
                  focusNext: _focusNodes[2],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Customer name is required';
                    }
                    return null;
                  },
                ),
                AppFormField(
                  controller: _controllerCustomerAddress,
                  label: 'Address',
                  keyboardType: TextInputType.streetAddress,
                  hint: 'Enter full address',
                  multiline: true,
                  focusNode: _focusNodes[2],
                  focusNext: _focusNodes[3],
                  validator: (value) {
                    if (widget.addressRequired) {
                      if (value == null || value.isEmpty) {
                        return 'Address is required';
                      }
                    }
                    return null;
                  },
                ),
                AppFormField(
                  controller: _controllerCustomerLandmark,
                  label: 'Landmark (Optional)',
                  hint: 'Enter landmark',
                  focusNode: _focusNodes[3],
                  onFieldSubmitted: (value) {
                    _focusNodes[3].unfocus();
                  },
                ),
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
                      style: AppTypography.bodyLarge.copyWith(
                        color: AppColors.black600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
