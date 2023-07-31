import 'package:eatery/references.dart';

Color _pageColor = const Color(0xFFC2592F);

class EditStaffPage extends StatefulWidget {
  const EditStaffPage({Key? key, required this.staff}) : super(key: key);
  final Staff staff;

  @override
  State<EditStaffPage> createState() => _EditStaffPageState();
}

class _EditStaffPageState extends State<EditStaffPage> {
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
  initState() {
    super.initState();
    Future.delayed(Duration.zero, (){
      setState(() {
        _controllerStaffName.text = widget.staff.name;
        _controllerStaffPhone.text = widget.staff.phone ?? '';
        staffType = widget.staff.type;
        isActive = widget.staff.isActive;
        image = LibraryImage(widget.staff.photo ?? '');
        
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      backgroundColor: _pageColor,
      foregroundColor: Colors.white,
      
      title: const Text('Edit Staff'),
      actions: [
        if (_focusNodes[0].hasFocus ||
            _focusNodes[1].hasFocus)
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
                UploadButton(
                  label: 'Staff Photo',
                  primaryColor: _pageColor,
                  secondaryColor: KColors.black600,
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
                  foregroundColor: KColors.black600,
                  hint: 'Enter Staff Name',
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Please enter staff name' : null,
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
                  foregroundColor: KColors.black600,
                  keyboardType: TextInputType.phone,
                  hint: 'Enter Phone Number',
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Please enter phone number' : null,
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
                      color: KColors.black600,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: KColors.black600,
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
                        color: KColors.red,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        width: 2,
                        color: KColors.red,
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
                        color: KColors.black600,
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
        color: KColors.white,
        child: PrimaryButton(
          color: _pageColor,
          onPressed: () async {
            final isValid = _formKey.currentState!.validate();
            if (!isValid) {
              return;
            }
            _formKey.currentState!.save();

            widget.staff.name = _controllerStaffName.text;
            widget.staff.phone = _controllerStaffPhone.text;
            widget.staff.photo = image?.filename;
            widget.staff.type = staffType!;
            widget.staff.isActive = isActive;
            try {
              EateryDB.instance.staffBox!.put(widget.staff.id,
                widget.staff,
              ).whenComplete(() {
                showMessageDialog(context, 'Staff added successfully', MessageType.success, () => Navigator.pop(context));
              });
            } catch (_) {
              showMessageDialog(context, 'Failed to add staff', MessageType.error);
            }
          },
          child: const Text('Save'),
        ),
      ),
    );
  }
}
