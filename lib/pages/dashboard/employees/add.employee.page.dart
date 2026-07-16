import 'package:eatery_core/widgets/app_page_shell.dart';
import 'package:eatery_core/theme/app_typography.dart';
import 'package:eatery/references.dart';
import 'package:eatery_core/theme/app_colors.dart';
import 'package:eatery_core/theme/app_spacing.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eatery_core/providers/order_provider.dart';
import 'package:eatery_core/widgets/app_dialog.dart';

Color _pageColor = const Color(0xFFC2592F);

class AddEmployeePage extends ConsumerStatefulWidget {
  const AddEmployeePage({super.key});

  @override
  ConsumerState<AddEmployeePage> createState() => _AddEmployeePageState();
}

class _AddEmployeePageState extends ConsumerState<AddEmployeePage> {
  LibraryImage? image;
  bool isActive = true;
  final TextEditingController _controllerEmployeeName = TextEditingController();
  final TextEditingController _controllerEmployeePhone =
      TextEditingController();
  final TextEditingController _controllerEmployeePin = TextEditingController();
  EmployeeRole? employeeType;
  final _formKey = GlobalKey<FormState>();

  final List<FocusNode> _focusNodes = [FocusNode(), FocusNode()];

  @override
  Widget build(BuildContext context) {
    debugPrint('image: ${image?.absolutePath}');
    return AppPageShell(
      title: 'Add Employee',
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
            final employee = Employee(
              name: _controllerEmployeeName.text,
              phone: _controllerEmployeePhone.text,
              photo: image?.filename,
              isActive: isActive,
              type: employeeType!,
              pin: _controllerEmployeePin.text.isNotEmpty
                  ? _controllerEmployeePin.text
                  : null,
            );
            ref
                .read(employeeRepositoryProvider)
                .saveEmployee(employee)
                .then(
                  (value) => AppDialog.showMessage(
                    context,
                    message: 'Employee has been added successfully',
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
                  label: 'Employee Photo',
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
                AppFormField(
                  controller: _controllerEmployeeName,
                  label: 'Employee Name',
                  hint: 'Enter Employee Name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter Employee Name';
                    }
                    if (value.length < 3) {
                      return 'Employee Name must be at least 3 characters';
                    }
                    if (ref
                        .read(employeeRepositoryProvider)
                        .isEmployeeNameTaken(value)) {
                      return 'Employee Name already exists';
                    }
                    return null;
                  },
                  focusNode: _focusNodes[0],
                  focusNext: _focusNodes[1],
                ),
                AppFormField(
                  controller: _controllerEmployeePhone,
                  label: 'Phone Number',
                  keyboardType: TextInputType.phone,
                  hint: 'Enter Phone Number',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter Phone Number';
                    } else if (ref
                        .read(employeeRepositoryProvider)
                        .isEmployeePhoneTaken(value)) {
                      return 'Phone Number already exists';
                    }
                    return null;
                  },
                  focusNode: _focusNodes[1],
                  onFieldSubmitted: (v) {
                    FocusScope.of(context).unfocus();
                  },
                ),
                AppFormField(
                  controller: _controllerEmployeePin,
                  label: 'PIN (4 digits)',
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
                // Drop down for employee role
                DropdownButtonFormField(
                  decoration: InputDecoration(
                    labelText: 'Employee Role',
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
                    hint: const Text('Select Employee Role'),
                  value: employeeType,
                  items: [
                    ...EmployeeRole.values.map(
                      (e) => DropdownMenuItem(value: e, child: Text(e.name)),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      employeeType = value;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Please select employee role' : null,
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
