import 'package:eatery_core/widgets/app_page_shell.dart';
import 'package:eatery_core/providers/order_provider.dart';
import 'package:eatery/references.dart';
import 'package:eatery_core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eatery_core/widgets/app_dialog.dart';

Color _pageColor = AppColors.menuCategories;

class AddDiningTableCategoryPage extends ConsumerStatefulWidget {
  const AddDiningTableCategoryPage({super.key});

  @override
  ConsumerState<AddDiningTableCategoryPage> createState() =>
      _AddDiningTableCategoryPageState();
}

class _AddDiningTableCategoryPageState
    extends ConsumerState<AddDiningTableCategoryPage> {
  final TextEditingController _controllerCategoryName = TextEditingController();
  final TextEditingController _controllerCategoryDescription =
      TextEditingController();
  final List<FocusNode> _focusNodes = [FocusNode(), FocusNode()];

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return AppPageShell(
      title: 'Add Dining Table Category',
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
            if (!_formKey.currentState!.validate()) {
              return;
            }
            DiningTableCategory diningTableCategory = DiningTableCategory(
              name: _controllerCategoryName.text,
              description: _controllerCategoryDescription.text,
              isActive: true,
            );
            ref
                .read(diningTableRepositoryProvider)
                .saveCategory(diningTableCategory);
            AppDialog.showMessage(
              context,
              message: 'Dining table category added successfully',
              type: MessageType.success,
            ).then((value) => Navigator.pop(this.context, diningTableCategory));
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
                AppFormField(
                  label: 'Category Name',
                  hint: 'eg. Terrace',
                  controller: _controllerCategoryName,
                  focusNext: _focusNodes[1],
                ),
                AppFormField(
                  label: 'Description',
                  hint: 'eg. Terrace',
                  controller: _controllerCategoryDescription,
                  multiline: true,
                  focusNode: _focusNodes[1],
                  onFieldSubmitted: (v) {
                    FocusScope.of(context).unfocus();
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
