import 'package:eatery_core/widgets/app_page_shell.dart';
import 'package:eatery_core/theme/app_typography.dart';
import 'package:eatery_core/providers/order_provider.dart';
import 'package:eatery/references.dart';
import 'package:eatery_core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eatery_core/widgets/app_dialog.dart';

Color _pageColor = AppColors.menuCategories;

class AddDiningTablePage extends ConsumerStatefulWidget {
  const AddDiningTablePage({Key? key}) : super(key: key);

  @override
  ConsumerState<AddDiningTablePage> createState() => _AddDiningTablePageState();
}

class _AddDiningTablePageState extends ConsumerState<AddDiningTablePage> {
  DiningTable? diningTable;
  DiningTableCategory? diningTableCategory;
  final TextEditingController _controllerCategoryName = TextEditingController();
  final TextEditingController _controllerCategoryDescription =
      TextEditingController();
  final TextEditingController _controllerCapacity = TextEditingController();

  final List<FocusNode> _focusNodes = [FocusNode(), FocusNode()];

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AppPageShell(
      title: 'Add Dining Table',
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
                LabeledCustomTextFormField(
                  label: 'Dining Table Name',
                  controller: _controllerCategoryName,
                  hint:
                      'eg. Table ${ref.read(diningTableRepositoryProvider).getAllTables().length + 1}',
                  obscureText: false,
                  themeColor: _pageColor,
                  foregroundColor: AppColors.black600,
                  focusNode: _focusNodes[0],
                  suffix: _controllerCategoryName.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              _controllerCategoryName.clear();
                            });
                          },
                        )
                      : IconButton(
                          icon: Icon(
                            Icons.auto_awesome,
                            size: 18.0,
                            color: AppColors.black600,
                          ),
                          onPressed: () {
                            setState(() {
                              _controllerCategoryName.text =
                                  'Table ${ref.read(diningTableRepositoryProvider).getAllTables().length + 1}';
                            });
                          },
                        ),
                  onFieldSubmitted: (v) {
                    _focusNodes[1].requestFocus();
                  },
                ),
                const SizedBox(height: 12.0),
                LabeledCustomTextFormField(
                  label: 'Description',
                  controller: _controllerCategoryDescription,
                  hint: 'eg. Regular/ VIP/ Family/ etc.',
                  obscureText: false,
                  themeColor: _pageColor,
                  foregroundColor: AppColors.black600,
                  multiline: true,
                  focusNode: _focusNodes[1],
                  onFieldSubmitted: (v) {
                    FocusScope.of(context).unfocus();
                  },
                ),
                const SizedBox(height: 12.0),
                LabeledCustomTextFormField(
                  label: 'Capacity',
                  controller: _controllerCapacity,
                  hint: 'eg. 4/ 6/ 8/ 10/ etc.',
                  obscureText: false,
                  themeColor: _pageColor,
                  foregroundColor: AppColors.black600,
                  keyboardType: TextInputType.number,
                  onFieldSubmitted: (v) {
                    FocusScope.of(context).unfocus();
                  },
                ),
                const SizedBox(height: 12.0),
                Text(
                  'Category',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.black600,
                  ),
                ),
                Container(
                  width: double.maxFinite,
                  height: 60,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      PosCategoryWidget(
                        active: diningTableCategory == null,
                        label: 'None',
                        onTap: () {
                          setState(() {
                            diningTableCategory = null;
                          });
                        },
                      ),
                      ...ref
                          .read(diningTableRepositoryProvider)
                          .getAllCategories()
                          .map((e) {
                            return PosCategoryWidget(
                              active: diningTableCategory?.id == e.id,
                              label: e.name,
                              onTap: () {
                                setState(() {
                                  diningTableCategory = e;
                                });
                              },
                            );
                          }),
                      Container(
                        padding: const EdgeInsets.only(bottom: 6, right: 12),
                        child: InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 24.0,
                                  vertical: 24.0,
                                ),
                                child: const AddDiningTableCategoryPage(),
                              ),
                            ).then((value) {
                              setState(() {});
                            });
                          },
                          child: Material(
                            color: Colors.transparent,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Container(
                              width: 54,
                              decoration: BoxDecoration(
                                color: AppColors.green,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.green.withOpacity(0.2),
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.green,
                                  width: 1,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Icon(Icons.add, color: AppColors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: AppButton.primary(
          onPressed: () async {
            if (!_formKey.currentState!.validate()) {
              return;
            }
            _formKey.currentState!.save();
            DiningTable diningTable = DiningTable(
              name: _controllerCategoryName.text,
              description: _controllerCategoryDescription.text,
              categoryId: diningTableCategory?.id,
              capacity: int.parse(_controllerCapacity.text),
            );
            ref
                .read(diningTableRepositoryProvider)
                .saveTable(diningTable)
                .then((value) {
                  AppDialog.showMessage(
                    context,
                    message: 'Dining Table created successfully',
                    type: MessageType.success,
                    onConfirm: () => Navigator.pop(context),
                  );
                })
                .onError((error, stackTrace) {
                  debugPrint(error.toString());
                  AppDialog.showMessage(
                    context,
                    message: 'Failed to create Dining Table',
                    type: MessageType.error,
                  );
                });
          },
          label: 'Save',
        ),
      ),
    );
  }
}
