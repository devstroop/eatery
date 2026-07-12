import 'package:eatery/presentation/providers/order_provider.dart';
import 'package:eatery/presentation/providers/database_provider.dart';
import 'package:eatery/references.dart';
import 'package:eatery/core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Color _pageColor = AppColors.menuCategories;

class EditDiningTablePage extends ConsumerStatefulWidget {
  const EditDiningTablePage({Key? key, required this.diningTable})
    : super(key: key);
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
        diningTableCategory =
            ref
                .read(appDatabaseProvider)
                .diningTableCategoryBox
                .values
                .where((elem) => elem.id == widget.diningTable.category?.id)
                .isNotEmpty
            ? ref
                  .read(appDatabaseProvider)
                  .diningTableCategoryBox
                  .values
                  .where((elem) => elem.id == widget.diningTable.category?.id)
                  .first
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
    return Scaffold(
      backgroundColor: AppColors.grey200,
      appBar: AppBar(
        backgroundColor: _pageColor,
        foregroundColor: AppColors.white,
        title: const Text('Edit Dining Table'),
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
                LabeledCustomTextFormField(
                  label: 'Dining Table Name',
                  controller: _controllerCategoryName,
                  hint: 'eg. Table 1 ',
                  obscureText: false,
                  themeColor: _pageColor,
                  foregroundColor: AppColors.black600,
                  focusNode: _focusNodes[0],
                  onFieldSubmitted: (v) {
                    _focusNodes[1].requestFocus();
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter dining table name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12.0),
                LabeledCustomTextFormField(
                  label: 'Description',
                  controller: _controllerCategoryDescription,
                  hint: 'eg. Table description',
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
                  style: TextStyle(
                    color: AppColors.black600,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
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
                          .read(appDatabaseProvider)
                          .diningTableCategoryBox
                          .values
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
      bottomNavigationBar: BottomAppBar(
        color: AppColors.white,
        child: PrimaryButton(
          color: _pageColor,
          onPressed: () async {
            if (!_formKey.currentState!.validate()) {
              return;
            }

            DiningTable diningTable = ref
                .read(diningTableRepositoryProvider)
                .getTableById(widget.diningTable.id!)!;

            diningTable.name = _controllerCategoryName.text;
            diningTable.description = _controllerCategoryDescription.text;
            diningTable.category = diningTableCategory;
            diningTable.status = status;
            diningTable.capacity = int.parse(_controllerCapacity.text);

            await ref
                .read(diningTableRepositoryProvider)
                .saveTable(diningTable)
                .then((value) {
                  showMessageDialog(
                    context,
                    'Successfully updated',
                    MessageType.success,
                  ).then((value) => Navigator.of(this.context).pop());
                })
                .onError((error, stackTrace) {
                  showMessageDialog(
                    context,
                    'Failed to update',
                    MessageType.error,
                  );
                });
          },
          child: const Text('Update'),
        ),
      ),
    );
  }
}

class DiningTableStatusWidget extends StatelessWidget {
  const DiningTableStatusWidget({
    Key? key,
    required this.status,
    required this.onTap,
  }) : super(key: key);

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
              ? KColors.green
              : AppColors.error,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(
          child: Text(
            status.name,
            style: TextStyle(
              color: AppColors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
