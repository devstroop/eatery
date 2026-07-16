import 'package:eatery_core/widgets/app_page_shell.dart';
import 'package:eatery_core/theme/app_typography.dart';
import 'package:eatery/references.dart';
import 'package:eatery_core/theme/app_colors.dart';
import 'package:eatery_core/theme/app_spacing.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eatery_core/providers/order_provider.dart';
import 'package:eatery_core/widgets/app_dialog.dart';

Color _pageColor = const Color(0xFFC2592F);

class EditStaffPage extends ConsumerStatefulWidget {
  const EditStaffPage({super.key, required this.staff});
  final Staff staff;

  @override
  ConsumerState<EditStaffPage> createState() => _EditStaffPageState();
}

class _EditStaffPageState extends ConsumerState<EditStaffPage> {
  LibraryImage? image;
  bool isActive = true;
  final TextEditingController _controllerStaffName = TextEditingController();
  final TextEditingController _controllerStaffPhone = TextEditingController();
  final TextEditingController _controllerStaffPin = TextEditingController();
  StaffType? staffType;
  final _formKey = GlobalKey<FormState>();

  final List<FocusNode> _focusNodes = [FocusNode(), FocusNode()];

  @override
  initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        _controllerStaffName.text = widget.staff.name;
        _controllerStaffPhone.text = widget.staff.phone ?? '';
        _controllerStaffPin.text = widget.staff.pin ?? '';
        staffType = widget.staff.type;
        isActive = widget.staff.isActive;
        image = LibraryImage(widget.staff.photo ?? '');

        debugPrint('image: ${image?.filename}');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppPageShell(
      title: 'Edit Staff',
      color: _pageColor,
      actions: [
        if (_focusNodes[0].hasFocus || _focusNodes[1].hasFocus)
          IconButton(
            icon: const Icon(Icons.done),
            onPressed: () {
              FocusScope.of(context).unfocus();
            },
          ),
      ],
      bottomNavigationBar: BottomAppBar(
        color: AppColors.white,
        child: AppButton.primary(
          onPressed: () async {
            final isValid = _formKey.currentState!.validate();
            if (!isValid) {
              return;
            }
            _formKey.currentState!.save();

            final updated = widget.staff.copyWith(
              name: _controllerStaffName.text,
              phone: _controllerStaffPhone.text,
              photo: image?.filename,
              type: staffType!,
              isActive: isActive,
              pin: _controllerStaffPin.text.isNotEmpty
                  ? _controllerStaffPin.text
                  : null,
            );
            try {
              ref.read(staffRepositoryProvider).saveStaff(updated).then((id) {
                AppDialog.showMessage(
                  context,
                  message: 'Staff updated successfully',
                  type: MessageType.success,
                  onConfirm: () => Navigator.pop(context),
                );
              });
            } catch (_) {
              AppDialog.showMessage(
                context,
                message: 'Failed to add staff',
                type: MessageType.error,
              );
            }
          },
          label: 'Save',
        ),
      ),
      child: InkWell(
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
                AppSpacing.gapMd,
                AppFormField(
                  controller: _controllerStaffName,
                  label: 'Staff Name',
                  hint: 'Enter Staff Name',
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter staff name'
                      : null,
                  focusNode: _focusNodes[0],
                  focusNext: _focusNodes[1],
                ),
                AppFormField(
                  controller: _controllerStaffPhone,
                  label: 'Phone Number',
                  keyboardType: TextInputType.phone,
                  hint: 'Enter Phone Number',
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter phone number'
                      : null,
                  focusNode: _focusNodes[1],
                  onFieldSubmitted: (v) {
                    FocusScope.of(context).unfocus();
                  },
                ),
                AppFormField(
                  controller: _controllerStaffPin,
                  label: 'PIN (4 digits)',
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  hint: 'Enter PIN',
                  validator: (value) {
                    if (value != null && value.isNotEmpty && value.length < 4) {
                      return 'Minimum 4 digits';
                    }
                    if (value != null &&
                        value.isNotEmpty &&
                        !RegExp(r'^\d{4,}$').hasMatch(value)) {
                      return 'Numbers only';
                    }
                    return null;
                  },
                ),
                // Drop down for staff type
                DropdownButtonFormField(
                  decoration: InputDecoration(
                    labelText: 'Staff Type',
                    labelStyle: AppTypography.bodyMedium.copyWith(
                      color: AppColors.black600,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: AppColors.black600),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(width: 2, color: _pageColor),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(width: 2, color: AppColors.error),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(width: 2, color: AppColors.error),
                    ),
                  ),
                  hint: const Text('Select Staff Type'),
                  value: staffType,
                  items: [
                    ...StaffType.values.map(
                      (e) => DropdownMenuItem(value: e, child: Text(e.name)),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      staffType = value;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Please select staff type' : null,
                ),

                AppSpacing.gapMd,
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
                      },
                    ),
                    const SizedBox(width: 6.0),
                    Text(
                      'Active',
                      style: AppTypography.bodyLarge.copyWith(
                        color: AppColors.black600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
