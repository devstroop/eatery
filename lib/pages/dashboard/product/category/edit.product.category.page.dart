import 'package:eatery/core/widgets/app_page_shell.dart';
import 'package:eatery/presentation/providers/product_provider.dart';
import 'package:eatery/references.dart';
import 'package:eatery/core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Color _pageColor = AppColors.menuCategories;

class EditProductCategoryPage extends ConsumerStatefulWidget {
  const EditProductCategoryPage({Key? key, required this.category})
    : super(key: key);
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
              LabeledCustomTextFormField(
                label: 'Category Name',
                controller: _controllerCategoryName,
                hint: 'eg. Starters',
                obscureText: false,
                themeColor: _pageColor,
                foregroundColor: AppColors.black600,
                focusNode: _focusNodes[0],
                onFieldSubmitted: (v) {
                  _focusNodes[1].requestFocus();
                },
              ),
              const SizedBox(height: 6.0),
              LabeledCustomTextFormField(
                label: 'Description',
                controller: _controllerDescription,
                hint: 'eg. Starters are the best',
                obscureText: false,
                themeColor: _pageColor,
                foregroundColor: AppColors.black600,
                multiline: true,
                focusNode: _focusNodes[1],
                onFieldSubmitted: (v) {
                  FocusScope.of(context).unfocus();
                },
              ),
              const SizedBox(height: 6.0),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: AppColors.white,
        child: AppButton.primary(
          onPressed: () async {
            try {
              widget.category.name = _controllerCategoryName.text.trim();
              widget.category.description = _controllerDescription.text.trim();
              widget.category.image = pickedLibraryImage?.filename;
              widget.category.save();
              showMessageDialog(
                context,
                'Updated successfully',
                MessageType.success,
              ).then((value) => Navigator.pop(context));
            } catch (_) {
              showMessageDialog(context, 'Failed to update', MessageType.error);
            }
          },
          label: 'Update',
        ),
      ),
    );
  }
}
