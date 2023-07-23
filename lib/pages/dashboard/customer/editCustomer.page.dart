import 'package:eatery_db/eatery_db.dart';
import 'package:eatery/services/utility/show_snack_bar.dart';
import 'package:eatery/constants/style/color_style.dart';
import '../../../components/labeled_custom_text_from_field.dart';
import '../../../constants/style/spacing_style.dart';
import '../../../widgets/buttons/primary.button.dart';

Color _pageColor = ColorStyle.primary;

class EditCustomerPage extends StatefulWidget {
  const EditCustomerPage({Key? key, required this.customerId}) : super(key: key);
  final int customerId;

  @override
  State<EditCustomerPage> createState() => _EditCustomerPageState();
}

class _EditCustomerPageState extends State<EditCustomerPage> {
  bool isActive = true;
  final TextEditingController _controllerCustomerName = TextEditingController();
  final TextEditingController _controllerCustomerPhone =
      TextEditingController();
  final TextEditingController _controllerCustomerEmail =
      TextEditingController();
  final TextEditingController _controllerCustomerAddress =
      TextEditingController();
  final TextEditingController _controllerCustomerLandmark =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Customer? customer;

  @override
  initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      customer = EateryDB.instance.customerBox!.get(widget.customerId);
      setState(() {
        _controllerCustomerName.text = customer?.name ?? '';
        _controllerCustomerPhone.text = customer?.phone ?? '';
        _controllerCustomerEmail.text = customer?.email ?? '';
        _controllerCustomerAddress.text = customer?.address ?? '';
        _controllerCustomerLandmark.text = customer?.landmark ?? '';
        isActive = customer?.isActive ?? false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      backgroundColor: _pageColor,
      foregroundColor: Colors.white,
      title: const Text('Edit Customer'),
      actions: [
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Delete Customer'),
                  content: const Text(
                      'Are you sure you want to delete this customer?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        // widget.customer.delete()
                        //     .whenComplete(() {
                        //   Navigator.pop(context);
                        //   Navigator.pop(context);
                        //   setState(() {});
                        // });
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                );
              },
            );
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
                ),
                SpacingStyle.defaultVerticalSpacing,
                LabeledCustomTextFromField(
                    controller: _controllerCustomerEmail,
                    label: 'Email Address',
                    hint: 'Enter email address',
                    themeColor: _pageColor,
                    foregroundColor: ColorStyle.text200,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value!.trim().isEmpty) return 'Email cannot be blank';
                      if (!value.trim().isValidEmail()) {
                        return 'Email address is not valid';
                      }
                      return null;
                    }),
                SpacingStyle.defaultVerticalSpacing,
                LabeledCustomTextFromField(
                  controller: _controllerCustomerAddress,
                  label: 'Address',
                  themeColor: _pageColor,
                  foregroundColor: ColorStyle.text200,
                  keyboardType: TextInputType.streetAddress,
                  hint: 'Enter full address',
                  multiline: true,
                ),
                SpacingStyle.defaultVerticalSpacing,
                LabeledCustomTextFromField(
                  controller: _controllerCustomerLandmark,
                  label: 'Landmark (Optional)',
                  themeColor: _pageColor,
                  foregroundColor: ColorStyle.text200,
                  keyboardType: TextInputType.text,
                  hint: 'Enter landmark',
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
            customer?.email = _controllerCustomerEmail.text;
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
