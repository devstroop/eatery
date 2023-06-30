import '../../../references.dart';

Color _pageColor = ColorStyle.primary;

class EditCustomerPage extends StatefulWidget {
  const EditCustomerPage({Key? key, required this.master}) : super(key: key);
  final Master master;

  @override
  State<EditCustomerPage> createState() => _EditCustomerPageState();
}

class _EditCustomerPageState extends State<EditCustomerPage> {
  bool isActive = true;
  final TextEditingController _controllerCustomerName = TextEditingController();
  final TextEditingController _controllerCustomerPhone = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  initState() {
    super.initState();
    Future.delayed(Duration.zero, (){
      setState(() {
        _controllerCustomerName.text = widget.master.name;
        _controllerCustomerPhone.text = widget.master.phone ?? '';
        isActive = widget.master.isActive;
       });
    });
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      backgroundColor: _pageColor,
      foregroundColor: Colors.white,
      leading: IconButton(
        icon: Icon(UIcons.regularStraight.arrow_left),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: const Text('Edit Customer'),
      actions: [
        IconButton(
          icon: Icon(UIcons.regularStraight.trash),
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

            widget.master.name = _controllerCustomerName.text;
            widget.master.phone = _controllerCustomerPhone.text;
            widget.master.isActive = isActive;
            try {
              // EateryDB.instance.customerBox.put(widget.customer.key,
              //   widget.customer,
              // ).whenComplete(() {
              //   showSnackBar(context, 'Customer updated successfully');
              //   Navigator.pop(context);
              // });
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
