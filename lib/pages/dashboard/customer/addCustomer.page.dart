import '../../../references.dart';

Color _pageColor = ColorStyle.primary;

class AddCustomerPage extends StatefulWidget {
  const AddCustomerPage({Key? key}) : super(key: key);

  @override
  State<AddCustomerPage> createState() => _AddCustomerPageState();
}

class _AddCustomerPageState extends State<AddCustomerPage> {
  bool isActive = true;
  final TextEditingController _controllerCustomerName = TextEditingController();
  final TextEditingController _controllerCustomerPhone =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: _pageColor,
          foregroundColor: Colors.white,
          title: const Text('Add Customer'),
          leading: IconButton(
            icon: Icon(UIcons.regularStraight.arrow_left),
            onPressed: () {
              Navigator.pop(context);
            },
          )),
      body: Padding(
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
                hint: 'Enter Customer Name',
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
                hint: 'Enter Phone Number',
              ),
              const SizedBox(
                height: 6.0,
              ),
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

            try {
              EateryDB.instance.masterBox!
                  .add(
                Master(
                    name: _controllerCustomerName.text,
                    phone: _controllerCustomerPhone.text,
                    isActive: isActive),
              )
                  .whenComplete(() {
                showSnackBar(context, 'Customer added successfully');
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
