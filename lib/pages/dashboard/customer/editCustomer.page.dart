import 'package:eatery/references.dart';

Color _pageColor = ColorStyle.primary;

class EditCustomerPage extends StatefulWidget {
  const EditCustomerPage({Key? key, required this.customer}) : super(key: key);
  final Customer customer;

  @override
  State<EditCustomerPage> createState() => _EditCustomerPageState();
}

class _EditCustomerPageState extends State<EditCustomerPage> {
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
        _controllerCustomerName.text = widget.customer.name;
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
    final appBar = AppBar(
      backgroundColor: _pageColor,
      foregroundColor: Colors.white,
      title: const Text('Edit Customer'),
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
    );
    return Scaffold(
      appBar: appBar,
      body: InkWell(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                LabeledCustomTextFromField(
                  controller: _controllerCustomerName,
                  label: 'Customer Name',
                  themeColor: _pageColor,
                  foregroundColor: ColorStyle.text200,
                  hint: 'Enter customer name',
                  focusNode: _focusNodes[0],
                  onFieldSubmitted: (v) {
                    _focusNodes[1].requestFocus();
                  },
                ),
                const SizedBox(
                  height: 6.0,
                ),
                LabeledCustomTextFromField(
                  controller: _controllerCustomerPhone,
                  label: 'Phone Number',
                  themeColor: _pageColor,
                  foregroundColor: ColorStyle.text200,
                  keyboardType: TextInputType.phone,
                  hint: 'Enter phone number',
                  focusNode: _focusNodes[1],
                  onFieldSubmitted: (v) {
                    _focusNodes[2].requestFocus();
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
                  focusNode: _focusNodes[2],
                  onFieldSubmitted: (v) {
                    _focusNodes[3].requestFocus();
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
        color: ColorStyle.backgroundColorAlter,
        child: PrimaryButton(
          color: _pageColor,
          onPressed: () async {
            if (!_formKey.currentState!.validate()) {
              return;
            }
            _formKey.currentState!.save();

            EateryDB.instance.customerBox!.values
                .where((element) => element.id == widget.customer.id)
                .first
              ..name = _controllerCustomerName.text
              ..phone = _controllerCustomerPhone.text
              ..address = _controllerCustomerAddress.text
              ..landmark = _controllerCustomerLandmark.text
              ..isActive = isActive
              ..save()
              .then((value) => showMessageDialog(
                  context,
                  'Customer updated successfully',
                  MessageType.success,
                  () {
                    Navigator.pop(context);
                  }
              )).onError((error, stackTrace) => showMessageDialog(
                  context,
                  'Error updating customer',
                  MessageType.error,
                  () {
                    Navigator.pop(context);
                  }
              ));


          },
          child: const Text('Save'),
        ),
      ),
    );
  }
}
