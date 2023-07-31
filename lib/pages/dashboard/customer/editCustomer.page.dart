import 'package:eatery_db/eatery_db.dart';
import 'package:eatery/services/utility/show_snack_bar.dart';
import 'package:eatery/constants/style/color_style.dart';
import '../../../components/labeled_custom_text_from_field.dart';
import '../../../constants/style/spacing_style.dart';
import '../../../widgets/buttons/primary.button.dart';

Color _pageColor = ColorStyle.primary;

class EditCustomerPage extends StatefulWidget {
  const EditCustomerPage({Key? key, required this.customerId})
      : super(key: key);
  final int customerId;

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
  Customer? customer;

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
      customer = EateryDB.instance.customerBox!.get(widget.customerId);
      setState(() {
        _controllerCustomerName.text = customer?.name ?? '';
        _controllerCustomerPhone.text = customer?.phone ?? '';
        _controllerCustomerAddress.text = customer?.address ?? '';
        _controllerCustomerLandmark.text = customer?.landmark ?? '';
        isActive = customer?.isActive ?? false;
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
            if (_controllerCustomerName.text.isEmpty) {
              showSnackBar(context, 'Customer Name is required');
              return;
            }
            final isValid = _formKey.currentState!.validate();
            if (!isValid) {
              return;
            }
            _formKey.currentState!.save();

            customer?.name = _controllerCustomerName.text;
            customer?.phone = _controllerCustomerPhone.text;
            customer?.address = _controllerCustomerAddress.text;
            customer?.landmark = _controllerCustomerLandmark.text;
            customer?.isActive = isActive;

            try {
              EateryDB.instance.customerBox!
                  .put(
                widget.customerId,
                customer!,
              )
                  .whenComplete(() {
                showSnackBar(context, 'Customer updated successfully');
                Navigator.pop(context);
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
