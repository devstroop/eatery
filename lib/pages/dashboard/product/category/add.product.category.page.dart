import 'package:eatery_core/providers/product_provider.dart';
import 'package:eatery/references.dart';
import 'package:eatery_core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Color _pageColor = AppColors.menuCategories;

class AddProductCategoryPage extends ConsumerStatefulWidget {
  const AddProductCategoryPage({super.key});

  @override
  ConsumerState<AddProductCategoryPage> createState() =>
      _AddProductCategoryPageState();
}

class _AddProductCategoryPageState
    extends ConsumerState<AddProductCategoryPage> {
  LibraryImage? pickedLibraryImage;
  final TextEditingController _controllerCategoryName = TextEditingController();
  final TextEditingController _controllerCategoryDescription =
      TextEditingController();
  final List<FocusNode> _focusNodes = [FocusNode(), FocusNode()];

  @override
  Widget build(BuildContext context) {
    return AppPageShell(
      title: 'Add Product Category',
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
          final repo = ref.read(productRepositoryProvider);
          await repo
              .saveCategory(
                ProductCategory(
                  name: _controllerCategoryName.text,
                  description: _controllerCategoryDescription.text,
                  image: pickedLibraryImage?.filename,
                ),
              )
              .then((response) {
                AppDialog.showMessage(
                  context,
                  message: 'Category created successfully',
                  type: MessageType.success,
                ).then((value) => Navigator.pop(context));
              })
              .onError((error, stackTrace) {
                AppDialog.showMessage(
                  context,
                  message: error.toString(),
                  type: MessageType.error,
                );
              });
        },
        label: 'Save',
      ),
      child: InkWell(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView(
            children: [
              const SizedBox(height: 12.0),
              UploadButton(
                label: 'Product Category Image',
                primaryColor: _pageColor,
                secondaryColor: AppColors.black600,
                libraryImage: pickedLibraryImage,
                onChanged: (pickedImagePath) {
                  setState(() {
                    pickedLibraryImage = pickedImagePath;
                  });
                },
              ),
              const SizedBox(height: 6.0),
              AppFormField(
                label: 'Category Name',
                hint: 'Enter product category name',
                controller: _controllerCategoryName,
                focusNode: _focusNodes[0],
                focusNext: _focusNodes[1],
              ),
              AppFormField(
                label: 'Description',
                controller: _controllerCategoryDescription,
                multiline: true,
                hint: 'Enter product category description',
                focusNode: _focusNodes[1],
                onFieldSubmitted: (v) {
                  FocusScope.of(context).unfocus();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
