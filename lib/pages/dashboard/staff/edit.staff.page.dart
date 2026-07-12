import 'package:eatery/references.dart';
import 'package:eatery/core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eatery/presentation/providers/database_provider.dart';

Color _pageColor = const Color(0xFFC2592F);

class EditStaffPage extends ConsumerStatefulWidget {
  const EditStaffPage({Key? key, required this.staff}) : super(key: key);
  final Staff staff;

  @override
  ConsumerState<EditStaffPage> createState() => _EditStaffPageState();
}

class _EditStaffPageState extends ConsumerState<EditStaffPage> {
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

        debugPrint('image: ${image?.filename}');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      backgroundColor: _pageColor,
      foregroundColor: AppColors.white,
      
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
      backgroundColor: AppColors.grey200,
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
                  secondaryColor: AppColors.black600,
                  libraryImage: image,
                  onChanged: (image) {
                    debugPrint(image?.filename ?? '');
                    setState(() {
                      this.image = image;
                    });
                  },
                ),
                SpacingStyle.defaultVerticalSpacing,
                LabeledCustomTextFormField(
                  controller: _controllerStaffName,
                  label: 'Staff Name',
                  themeColor: _pageColor,
                  foregroundColor: AppColors.black600,
                  hint: 'Enter Staff Name',
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Please enter staff name' : null,
                  focusNode: _focusNodes[0],
                  onFieldSubmitted: (v) {
                    _focusNodes[1].requestFocus();
                  },
                ),
                SpacingStyle.defaultVerticalSpacing,
                LabeledCustomTextFormField(
                  controller: _controllerStaffPhone,
                  label: 'Phone Number',
                  themeColor: _pageColor,
                  foregroundColor: AppColors.black600,
                  keyboardType: TextInputType.phone,
                  hint: 'Enter Phone Number',
                  validator: (value) => value == null || value.isEmpty ? 'Please enter phone number' : null,
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
                      color: AppColors.black600,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: AppColors.black600,
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
                        color: AppColors.error,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        width: 2,
                        color: AppColors.error,
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
                        color: AppColors.black600,
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
        color: AppColors.white,
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
              ref.read(appDatabaseProvider).staffBox.put(widget.staff.id,
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
