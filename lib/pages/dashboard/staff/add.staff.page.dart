import 'package:eatery_core/widgets/app_page_shell.dart';
import 'package:eatery_core/theme/app_typography.dart';
import 'package:eatery/references.dart';
import 'package:eatery_core/theme/app_colors.dart';
import 'package:eatery_core/theme/app_spacing.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eatery_core/providers/order_provider.dart';
import 'package:eatery_core/widgets/app_dialog.dart';

Color _pageColor = const Color(0xFFC2592F);

class AddStaffPage extends ConsumerStatefulWidget {
  const AddStaffPage({super.key});

  @override
  ConsumerState<AddStaffPage> createState() => _AddStaffPageState();
}

class _AddStaffPageState extends ConsumerState<AddStaffPage> {
  LibraryImage? image;
  bool isActive = true;
  final TextEditingController _controllerStaffName = TextEditingController();
  final TextEditingController _controllerStaffPhone = TextEditingController();
  final TextEditingController _controllerStaffPin = TextEditingController();
  StaffType? staffType;
  final _formKey = GlobalKey<FormState>();

  final List<FocusNode> _focusNodes = [FocusNode(), FocusNode()];

  @override
  Widget build(BuildContext context) {
    debugPrint('image: ${image?.absolutePath}');
    return AppPageShell(
      title: 'Add Staff',
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
            final staff = Staff(
              name: _controllerStaffName.text,
              phone: _controllerStaffPhone.text,
              photo: image?.filename,
              isActive: isActive,
              type: staffType!,
              pin: _controllerStaffPin.text.isNotEmpty
                  ? _controllerStaffPin.text
                  : null,
            );
            ref
                .read(staffRepositoryProvider)
                .saveStaff(staff)
                .then(
                  (value) => AppDialog.showMessage(
                    context,
                    message: 'Staff has been added successfully',
                    type: MessageType.success,
                    onConfirm: () => Navigator.pop(context),
                  ),
                )
                .onError(
                  (error, stackTrace) => AppDialog.showMessage(
                    context,
                    message: 'Something went wrong',
                    type: MessageType.error,
                  ),
                );
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
                    setState(() {
                      debugPrint('image: ${image?.absolutePath}');
                      this.image = image;
                    });
                  },
                ),
                AppSpacing.gapMd,
                LabeledCustomTextFormField(
                  controller: _controllerStaffName,
                  label: 'Staff Name',
                  themeColor: _pageColor,
                  foregroundColor: AppColors.black600,
                  hint: 'Enter Staff Name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter Staff Name';
                    }
                    if (value.length < 3) {
                      return 'Staff Name must be at least 3 characters';
                    }
                    if (ref
                        .read(staffRepositoryProvider)
                        .isStaffNameTaken(value)) {
                      return 'Staff Name already exists';
                    }
                    return null;
                  },
                  focusNode: _focusNodes[0],
                  onFieldSubmitted: (v) {
                    _focusNodes[1].requestFocus();
                  },
                ),
                AppSpacing.gapMd,
                LabeledCustomTextFormField(
                  controller: _controllerStaffPhone,
                  label: 'Phone Number',
                  themeColor: _pageColor,
                  foregroundColor: AppColors.black600,
                  keyboardType: TextInputType.phone,
                  hint: 'Enter Phone Number',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter Phone Number';
                    } else if (ref
                        .read(staffRepositoryProvider)
                        .isStaffPhoneTaken(value)) {
                      return 'Phone Number already exists';
                    }
                    return null;
                  },
                  focusNode: _focusNodes[1],
                  onFieldSubmitted: (v) {
                    FocusScope.of(context).unfocus();
                  },
                ),
                AppSpacing.gapMd,
                LabeledCustomTextFormField(
                  controller: _controllerStaffPin,
                  label: 'PIN (4 digits)',
                  themeColor: _pageColor,
                  foregroundColor: AppColors.black600,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  hint: 'Enter PIN',
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Enter PIN';
                    if (value.length < 4) return 'Minimum 4 digits';
                    if (!RegExp(r'^\d{4,}$').hasMatch(value)) {
                      return 'Numbers only';
                    }
                    return null;
                  },
                ),
                AppSpacing.gapMd,
                AppSpacing.gapMd,
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
