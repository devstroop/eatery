import 'package:eatery/references.dart';

Color _pageColor = ColorStyle.primary;

class AddCustomerPage extends StatefulWidget {
  const AddCustomerPage({Key? key, this.addressRequired = false}) : super(key: key);
  final bool addressRequired;

  @override
  State<AddCustomerPage> createState() => _AddCustomerPageState();
}

class _AddCustomerPageState extends State<AddCustomerPage> {
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _pageColor,
        foregroundColor: Colors.white,
        title: const Text('Add Customer'),
        actions: [
          // When textbox is on focus, show done button
          if(_focusNodes[0].hasFocus || _focusNodes[1].hasFocus || _focusNodes[2].hasFocus || _focusNodes[3].hasFocus || _focusNodes[4].hasFocus)
            IconButton(onPressed: (){
              _focusNodes[0].unfocus();
              _focusNodes[1].unfocus();
              _focusNodes[2].unfocus();
              _focusNodes[3].unfocus();
              _focusNodes[4].unfocus();
            }, icon: const Icon(Icons.done)),
        ],
      ),
      body: InkWell(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                LabeledCustomTextFromField(
                  controller: _controllerCustomerPhone,
                  label: 'Phone Number (*required)',
                  themeColor: _pageColor,
                  foregroundColor: ColorStyle.text200,
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
                    }
                    if (value.length < 10) {
                      return 'Phone number must be 10 digits';
                    }
                    return null;
                  },
                ),
                SpacingStyle.defaultVerticalSpacing,
                LabeledCustomTextFromField(
                  controller: _controllerCustomerName,
                  label: 'Customer Name',
                  themeColor: _pageColor,
                  foregroundColor: ColorStyle.text200,
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
                LabeledCustomTextFromField(
                  controller: _controllerCustomerAddress,
                  label: 'Address',
                  themeColor: _pageColor,
                  foregroundColor: ColorStyle.text200,
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
                LabeledCustomTextFromField(
                  controller: _controllerCustomerLandmark,
                  label: 'Landmark (Optional)',
                  themeColor: _pageColor,
                  foregroundColor: ColorStyle.text200,
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
                        onChanged: (value) {
                          setState(() {
                            isActive = value ?? false;
                          });
                        }),
                    const SizedBox(
                      width: 6.0,
                    ),
                    Text(
                      'Active',
                      style: TextStyle(
                        color: ColorStyle.text200,
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: PrimaryButton(
          color: _pageColor,
          onPressed: () async {
            if (_controllerCustomerName.text.isEmpty) {
              showSnackBar(context, 'Customer Name is required');
              return;
            }
            final isValid = _formKey.currentState!.validate();
            if (!isValid) {
              return;
            }
            _formKey.currentState!.save();

            try {
              Customer customer = Customer(
                name: _controllerCustomerName.text,
                phone: _controllerCustomerPhone.text,
                address: _controllerCustomerAddress.text,
                landmark: _controllerCustomerLandmark.text,
                isActive: isActive,
              );
              EateryDB.instance.customerBox!
                  .add(customer)
                  .whenComplete(() {
                showSnackBar(context, 'Customer added successfully');
                Navigator.pop(context, customer);
              });
            } catch (_) {
              showSnackBar(context, 'Failed to add customer');
            }
          },
          child: const Text('Save'),
        ),
      ),
    );
  }
}
