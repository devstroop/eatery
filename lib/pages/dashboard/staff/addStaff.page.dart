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
  final TextEditingController _controllerWaiterName = TextEditingController();
  final TextEditingController _controllerWaiterPhone = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _pageColor,
        foregroundColor: Colors.white,
        title: const Text('Add Staff'),
      ),
      body: Padding(
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
              const SizedBox(
                height: 6.0,
              ),
              LabeledCustomTextFromField(
                controller: _controllerWaiterName,
                label: 'Staff Name',
                themeColor: _pageColor,
                foregroundColor: ColorStyle.text200,
                hint: 'Enter Waiter Name',
              ),
              const SizedBox(
                height: 6.0,
              ),
              LabeledCustomTextFromField(
                controller: _controllerWaiterPhone,
                label: 'Phone Number',
                themeColor: _pageColor,
                foregroundColor: ColorStyle.text200,
                keyboardType: TextInputType.phone,
                hint: 'Enter Phone Number',
              ),
              const SizedBox(
                height: 6.0,
              ),

              // Drop down for staff type
              DropdownButtonFormField(
                  decoration: InputDecoration(
                    labelText: 'Staff Type',
                    labelStyle: TextStyle(
                      color: ColorStyle.text200,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: ColorStyle.text200,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: _pageColor,
                      ),
                    ),
                  ),
                  hint: const Text('Select Staff Type'),
                  items: [
                    ...StaffType.values.map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e.toString().split('.').last),
                        ))
                  ],
                  onChanged: (value) {
                    debugPrint(value?.name ?? '');
                  }),

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
            if (_controllerWaiterName.text.isEmpty) {
              showSnackBar(context, 'Waiter Name is required');
              return;
            }
            final isValid = _formKey.currentState!.validate();
            if (!isValid) {
              return;
            }
            _formKey.currentState!.save();

            try {
              EateryDB.instance.staffBox
                  !.add(
                Staff(
                    name: _controllerWaiterName.text,
                    phone: _controllerWaiterPhone.text,
                    photo: image?.filename,
                    isActive: isActive,
                    type: StaffType.other // TODO: Fix this section
                    ),
              )
                  .whenComplete(() {
                showSnackBar(context, 'Waiter added successfully');
                Navigator.pop(context);
              });
            } catch (_) {
              showSnackBar(context, 'Failed to add waiter');
            }
          },
          child: const Text('Save'),
        ),
      ),
    );
  }
}
