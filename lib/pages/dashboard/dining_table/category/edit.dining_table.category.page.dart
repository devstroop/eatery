import 'package:eatery_core/widgets/app_page_shell.dart';
import 'package:eatery_core/providers/order_provider.dart';
import 'package:eatery/references.dart';
import 'package:eatery_core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eatery_core/widgets/app_dialog.dart';

Color _pageColor = AppColors.menuCategories;

class EditDiningTableCategoryPage extends ConsumerStatefulWidget {
  const EditDiningTableCategoryPage({Key? key, required this.category})
    : super(key: key);
  final DiningTableCategory category;

  @override
  ConsumerState<EditDiningTableCategoryPage> createState() =>
      _EditDiningTableCategoryPageState();
}

class _EditDiningTableCategoryPageState
    extends ConsumerState<EditDiningTableCategoryPage> {
  final TextEditingController _controllerCategoryName = TextEditingController();
  final TextEditingController _controllerCategoryDescription =
      TextEditingController();

  final List<FocusNode> _focusNodes = [FocusNode(), FocusNode()];

  final _formKey = GlobalKey<FormState>();

  @override
  initState() {
    super.initState();
    setState(() {
      _controllerCategoryName.text = widget.category.name;
      _controllerCategoryDescription.text = widget.category.description ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppPageShell(
      title: 'Edit Table Category',
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
                  keyboardType: TextInputType.text,
                  controller: _controllerCategoryName,
                  label: 'Category Name',
                  hint: 'eg. Terrace',
                  obscureText: false,
                  themeColor: _pageColor,
                  foregroundColor: AppColors.black600,
                  focusNode: _focusNodes[0],
                  onFieldSubmitted: (v) {
                    _focusNodes[1].requestFocus();
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter category name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 6.0),
                LabeledCustomTextFormField(
                  keyboardType: TextInputType.text,
                  controller: _controllerCategoryDescription,
                  label: 'Description',
                  hint: 'eg. Terrace',
                  obscureText: false,
                  themeColor: _pageColor,
                  foregroundColor: AppColors.black600,
                  multiline: true,
                  focusNode: _focusNodes[1],
                  onFieldSubmitted: (v) {
                    _focusNodes[1].unfocus();
                  },
                ),
                const SizedBox(height: 6.0),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: AppColors.white,
        child: AppButton.primary(
          onPressed: () async {
            if (!_formKey.currentState!.validate()) {
              return;
            }
            _formKey.currentState!.save();
            final updated = widget.category.copyWith(
              name: _controllerCategoryName.text,
              description: _controllerCategoryDescription.text,
            );
            final repo = ref.read(diningTableRepositoryProvider) as dynamic;
            repo
                .saveCategory(updated)
                .then(
                  (value) => AppDialog.showMessage(
                    context,
                    message: 'Updated successfully',
                    type: MessageType.success,
                  ).then((value) => Navigator.pop(this.context)),
                )
                .onError(
                  (error, stackTrace) => AppDialog.showMessage(
                    context,
                    message: 'Can\'t update',
                    type: MessageType.error,
                  ),
                );
          },
          label: 'Update',
        ),
      ),
    );
  }
}
