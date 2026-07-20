import 'package:eatery_core/providers/product_provider.dart';
import 'package:eatery/references.dart';
import 'package:eatery_core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Color _pageColor = AppColors.menuCategories;

class EditProductCategoryPage extends ConsumerStatefulWidget {
  const EditProductCategoryPage({super.key, required this.category});
  final ProductCategory category;

  @override
  ConsumerState<EditProductCategoryPage> createState() =>
      _EditProductCategoryPageState();
}

class _EditProductCategoryPageState
    extends ConsumerState<EditProductCategoryPage> {
  LibraryImage? pickedLibraryImage;
  final TextEditingController _controllerCategoryName = TextEditingController();
  final TextEditingController _controllerDescription = TextEditingController();

  final List<FocusNode> _focusNodes = [FocusNode(), FocusNode()];

  @override
  initState() {
    super.initState();
    Future.delayed(Duration.zero, () {});
    setState(() {
      pickedLibraryImage = LibraryImage(widget.category.image);
      _controllerCategoryName.text = widget.category.name;
      _controllerDescription.text = widget.category.description ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppPageShell(
      title: 'Edit Product Category',
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
          try {
            final updated = widget.category.copyWith(
              name: _controllerCategoryName.text.trim(),
              description: _controllerDescription.text.trim(),
              image: pickedLibraryImage?.filename,
            );
            final repo = ref.read(productRepositoryProvider);
            await repo.saveCategory(updated);
            AppDialog.showMessage(
              context,
              message: 'Updated successfully',
              type: MessageType.success,
            ).then((value) => Navigator.pop(context));
          } catch (_) {
            AppDialog.showMessage(
              context,
              message: 'Failed to update',
              type: MessageType.error,
            );
          }
        },
        label: 'Update',
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
                onChanged: (libraryImage) {
                  setState(() {
                    pickedLibraryImage = libraryImage;
                  });
                },
              ),
              const SizedBox(height: 6.0),
              AppFormField(
                label: 'Category Name',
                controller: _controllerCategoryName,
                hint: 'eg. Starters',
                focusNode: _focusNodes[0],
                focusNext: _focusNodes[1],
              ),
              AppFormField(
                label: 'Description',
                controller: _controllerDescription,
                hint: 'eg. Starters are the best',
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
    );
  }
}
