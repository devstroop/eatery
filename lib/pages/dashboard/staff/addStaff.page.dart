import 'package:eatery/references.dart';

Color _pageColor = const Color(0xFFC2592F);

class AddStaffPage extends StatefulWidget {
  const AddStaffPage({Key? key}) : super(key: key);

  @override
  State<AddStaffPage> createState() => _AddStaffPageState();
}

class _AddStaffPageState extends State<AddStaffPage> {
  LibraryImage? image;
  bool isActive = true;
  final TextEditingController _controllerStaffName = TextEditingController();
  final TextEditingController _controllerStaffPhone = TextEditingController();
  StaffType? staffType;
  final _formKey = GlobalKey<FormState>();

  final List<FocusNode> _focusNodes = [
    FocusNode(),
    FocusNode(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _pageColor,
        foregroundColor: Colors.white,
        title: const Text('Add Staff'),
        actions: [
          if (_focusNodes[0].hasFocus || _focusNodes[1].hasFocus)
            IconButton(
              icon: const Icon(Icons.done),
              onPressed: () {
                FocusScope.of(context).unfocus();
              },
            ),
        ],
      ),
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
                UploadButton(
                  label: 'Staff Photo',
                  primaryColor: _pageColor,
                  secondaryColor: ColorStyle.text200,
                  image: image?.image,
                  onChanged: (image) {
                    setState(() {
                      this.image = image;
                    });
                  },
                ),
                SpacingStyle.defaultVerticalSpacing,
                LabeledCustomTextFromField(
                  controller: _controllerStaffName,
                  label: 'Staff Name',
                  themeColor: _pageColor,
                  foregroundColor: ColorStyle.text200,
                  hint: 'Enter Staff Name',
                  validator: (value) => value == null || value.isEmpty
                      ? 'Enter Staff Name'
                      : null,
                  focusNode: _focusNodes[0],
                  onFieldSubmitted: (v) {
                    _focusNodes[1].requestFocus();
                  },
                ),
                SpacingStyle.defaultVerticalSpacing,
                LabeledCustomTextFromField(
                  controller: _controllerStaffPhone,
                  label: 'Phone Number',
                  themeColor: _pageColor,
                  foregroundColor: ColorStyle.text200,
                  keyboardType: TextInputType.phone,
                  hint: 'Enter Phone Number',
                  validator: (value) => value == null || value.isEmpty
                      ? 'Enter Phone Number'
                      : null,
                  focusNode: _focusNodes[1],
                  onFieldSubmitted: (v) {
                    FocusScope.of(context).unfocus();
                  },
                ),
                SpacingStyle.defaultVerticalSpacing,
                // Drop down for staff type
                DropdownButtonFormField(
                  decoration: InputDecoration(
                    labelText: 'Staff Type',
                    labelStyle: TextStyle(
                      color: ColorStyle.text200,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: ColorStyle.text200,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        width: 2,
                        color: _pageColor,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        width: 2,
                        color: ColorStyle.error,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        width: 2,
                        color: ColorStyle.error,
                      ),
                    ),
                  ),
                  hint: const Text('Select Staff Type'),
                  value: staffType,
                  items: [
                    ...StaffType.values.map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e.name),
                        ))
                  ],
                  onChanged: (value) {
                    setState(() {
                      staffType = value;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Please select staff type' : null,
                ),

                SpacingStyle.defaultVerticalSpacing,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        activeColor: _pageColor,
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
            final isValid = _formKey.currentState!.validate();
            if (!isValid) {
              return;
            }
            _formKey.currentState!.save();

            try {
              EateryDB.instance.staffBox!
                  .add(
                Staff(
                    name: _controllerStaffName.text,
                    phone: _controllerStaffPhone.text,
                    photo: image?.filename,
                    isActive: isActive,
                    type: staffType!),
              )
                  .whenComplete(() {
                showSnackBar(context, 'Staff added successfully');
                Navigator.pop(context);
              });
            } catch (_) {
              showSnackBar(context, 'Failed to add Staff');
            }
          },
          child: const Text('Save'),
        ),
      ),
    );
  }
}
