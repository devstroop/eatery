import 'package:eatery_core/theme/app_typography.dart';
import 'package:eatery_core/providers/order_provider.dart';
import 'package:eatery/references.dart';
import 'package:eatery_core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Color _pageColor = AppColors.menuCategories;

class EditDiningTablePage extends ConsumerStatefulWidget {
  const EditDiningTablePage({super.key, required this.diningTable});
  final DiningTable diningTable;
  @override
  ConsumerState<EditDiningTablePage> createState() =>
      _EditDiningTablePageState();
}

class _EditDiningTablePageState extends ConsumerState<EditDiningTablePage> {
  DiningTableCategory? diningTableCategory;
  final TextEditingController _controllerCategoryName = TextEditingController();
  final TextEditingController _controllerCategoryDescription =
      TextEditingController();
  final TextEditingController _controllerCapacity = TextEditingController();
  final List<FocusNode> _focusNodes = [FocusNode(), FocusNode()];

  DiningTableStatus status = DiningTableStatus.available;

  final _formKey = GlobalKey<FormState>();

  @override
  initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        diningTableCategory = widget.diningTable.categoryId != null
            ? ref
                  .read(diningTableRepositoryProvider)
                  .getCategoryById(widget.diningTable.categoryId!)
            : null;
        _controllerCategoryName.text = widget.diningTable.name;
        _controllerCategoryDescription.text =
            widget.diningTable.description ?? '';
        status = widget.diningTable.status;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppPageShell(
      title: 'Edit Dining Table',
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
      bottomAction: AppButton.primary(
        onPressed: () async {
          if (!_formKey.currentState!.validate()) {
            return;
          }

          DiningTable diningTable = ref
              .read(diningTableRepositoryProvider)
              .getTableById(widget.diningTable.id!)!;

          diningTable = diningTable.copyWith(
            name: _controllerCategoryName.text,
            description: _controllerCategoryDescription.text,
            categoryId: diningTableCategory?.id,
            status: status,
            capacity: int.parse(_controllerCapacity.text),
          );

          await ref
              .read(diningTableRepositoryProvider)
              .saveTable(diningTable)
              .then((value) {
                AppDialog.showMessage(
                  context,
                  message: 'Successfully updated',
                  type: MessageType.success,
                ).then((value) => Navigator.of(this.context).pop());
              })
              .onError((error, stackTrace) {
                AppDialog.showMessage(
                  context,
                  message: 'Failed to update',
                  type: MessageType.error,
                );
              });
        },
        label: 'Update',
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
                AppFormField(
                  label: 'Dining Table Name',
                  controller: _controllerCategoryName,
                  hint: 'eg. Table 1 ',
                  focusNode: _focusNodes[0],
                  focusNext: _focusNodes[1],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter dining table name';
                    }
                    return null;
                  },
                ),
                AppFormField(
                  label: 'Description',
                  controller: _controllerCategoryDescription,
                  hint: 'eg. Table description',
                  multiline: true,
                  focusNode: _focusNodes[1],
                  onFieldSubmitted: (v) {
                    FocusScope.of(context).unfocus();
                  },
                ),
                AppFormField(
                  label: 'Capacity',
                  controller: _controllerCapacity,
                  hint: 'eg. 4/ 6/ 8/ 10/ etc.',
                  keyboardType: TextInputType.number,
                ),
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
                      AppCategoryChip(
                        selected: diningTableCategory == null,
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
                            return AppCategoryChip(
                              selected: diningTableCategory?.id == e.id,
                              label: e.name,
                              onTap: () {
                                setState(() {
                                  diningTableCategory = e;
                                });
                              },
                            );
                          }),
                    ],
                  ),
                ),
                const SizedBox(height: 12.0),
                DiningTableStatusWidget(
                  status: DiningTableStatus.available,
                  onTap: () {
                    setState(() {
                      status = DiningTableStatus.available;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DiningTableStatusWidget extends StatelessWidget {
  const DiningTableStatusWidget({
    super.key,
    required this.status,
    required this.onTap,
  });

  final DiningTableStatus status;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 60,
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: status == DiningTableStatus.available
              ? AppColors.green
              : AppColors.error,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(
          child: Text(
            status.name,
            style: AppTypography.titleMedium.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.white,
            ),
          ),
        ),
      ),
    );
  }
}
