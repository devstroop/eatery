import 'package:eatery_db/eatery_db.dart';
import 'package:flutter/material.dart';
import 'package:eatery/components/dialog_box.dart';
import 'package:eatery_components/buttons/primary.button.dart';
import 'package:eatery/services/utility/show_snack_bar.dart';
import 'package:eatery/constants/style/color_style.dart';

import '../../../../components/labeled_custom_text_from_field.dart';
import '../../../../services/utility/library_image.dart';
import '../../../../widgets/buttons/upload.button.dart';

Color _pageColor = ColorStyle.tertiary;

class EditProductCategoryPage extends StatefulWidget {
  const EditProductCategoryPage({Key? key, required this.category})
      : super(key: key);
  final ProductCategory category;

  @override
  State<EditProductCategoryPage> createState() =>
      _EditProductCategoryPageState();
}

class _EditProductCategoryPageState extends State<EditProductCategoryPage> {
  LibraryImage? pickedLibraryImage;
  final TextEditingController _controllerCategoryName = TextEditingController();
  final TextEditingController _controllerDescription = TextEditingController();

  @override
  initState() {
    super.initState();
    Future.delayed(Duration.zero, (){
      
    });
    setState(() {
      pickedLibraryImage = LibraryImage(widget.category.image);
      _controllerCategoryName.text = widget.category.name;
      _controllerDescription.text = widget.category.description ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      backgroundColor: _pageColor,
      foregroundColor: Colors.white,
      leading: IconButton(
        icon: Icon(UIcons.regularStraight.arrow_left),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: const Text('Edit Product Category'),
      actions: [
        IconButton(
          onPressed: () async {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return DialogBox(
                  title: 'Delete',
                  message: 'Are you sure?',
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel')),
                    TextButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          bool isLinkedToProduct = EateryDB
                              .instance.productBox.values
                              .where((element) =>
                                  element.categoryId == widget.category.id)
                              .isNotEmpty;
                          if (isLinkedToProduct) {
                            showSnackBar(
                                context, 'Linked to product, Can\'t delete');
                            return;
                          }
                          widget.category.delete().whenComplete(() {
                            showSnackBar(context, 'Deleted successfully');
                            Navigator.pop(context);
                          });
                        },
                        child: const Text('OK'))
                  ],
                );
              },
            );
          },
          icon: Icon(
            UIcons.regularStraight.trash,
            color: Colors.white.withAlpha(200),
          ),
        )
      ],
    );
    return Scaffold(
      appBar: appBar,
      body: InkWell(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView(
            children: [
              const SizedBox(
                height: 12.0,
              ),
              UploadButton(
                label: 'Product Category Image',
                primaryColor: _pageColor,
                secondaryColor: ColorStyle.text200,
                image: pickedLibraryImage?.image,
                onChanged: (libraryImage) {
                  setState(() {
                    pickedLibraryImage = libraryImage;
                  });
                },
              ),
              const SizedBox(
                height: 6.0,
              ),
              LabeledCustomTextFromField(
                label: 'Category Name',
                controller: _controllerCategoryName,
                hint: 'eg. Starters',
                obscureText: false,
                backgroundColor: _pageColor,
                foregroundColor: ColorStyle.text200,
              ),
              const SizedBox(
                height: 6.0,
              ),
              LabeledCustomTextFromField(
                label: 'Description',
                controller: _controllerDescription,
                hint: 'eg. Starters are the best',
                obscureText: false,
                backgroundColor: _pageColor,
                foregroundColor: ColorStyle.text200,
                multiline: true,
              ),
              const SizedBox(
                height: 6.0,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: ColorStyle.backgroundColorAlter,
        child: PrimaryButton(
          color: _pageColor,
          onPressed: () async {
            if (_controllerCategoryName.text.trim() == '') {
              showSnackBar(context, '* Category name required');
              return;
            }

            try {
              widget.category.name = _controllerCategoryName.text.trim();
              widget.category.description = _controllerDescription.text.trim();
              widget.category.image = pickedLibraryImage?.filename;
              widget.category.save();
              showSnackBar(context, 'Successfully updated');
              Navigator.of(context).pop();
            } catch (_) {
              showSnackBar(context, 'Failed to update');
            }
          },
          child: const Text('Update'),
        ),
      ),
    );
  }
}
