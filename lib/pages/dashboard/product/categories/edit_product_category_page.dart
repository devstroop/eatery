import 'dart:math';

import 'package:eatery_components/buttons/upload.button.dart';
import 'package:eatery_db/eatery_db.dart';
import 'package:eatery_db/models/product/product_category.dart';
import 'package:flutter/material.dart';
import 'package:eatery/components/custom_text_from_field.dart';
import 'package:eatery/components/dialog_box.dart';
import 'package:eatery_components/buttons/primary.button.dart';
import 'package:eatery/services/utility/show_snack_bar.dart';
import 'package:eatery/constants/style/color_style.dart';

class EditProductCategoryPage extends StatefulWidget {
  const EditProductCategoryPage({Key? key, required this.category})
      : super(key: key);
  final ProductCategory category;

  @override
  State<EditProductCategoryPage> createState() =>
      _EditProductCategoryPageState();
}

class _EditProductCategoryPageState extends State<EditProductCategoryPage> {
  String? pickedImagePath;
  final TextEditingController _controllerCategoryName = TextEditingController();

  @override
  initState() {
    super.initState();
    setState(() {
      pickedImagePath = widget.category.image;
      _controllerCategoryName.text = widget.category.name;
    });
  }

  Color getThemeColor() {
    return ColorStyle.tertiary;
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      backgroundColor: getThemeColor(),
      title: const Text('Edit Product Category'),
      actions: [
        TextButton(
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
                          bool _isLinkedToProduct = EateryDB()
                              .productBox()
                              .values
                              .where((element) =>
                                  element.categoryId ==
                                  widget.category.id)
                              .isNotEmpty;
                          if (_isLinkedToProduct) {
                            showSnackBar(
                                context, 'Linked to product, Can\'t delete');
                            return;
                          }
                          await widget.category.delete();
                          showSnackBar(context, 'Deleted successfully');
                          Navigator.pop(context);
                        },
                        child: const Text('OK'))
                  ],
                );
              },
            );
          },
          child: Text(
            'Delete',
            style: TextStyle(color: ColorStyle.backgroundColorAlter),
          ),
        )
      ],
    );
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(
                height: 12.0,
              ),
              UploadButton(
                label: 'Product Category Image',
                primaryColor: getThemeColor(),
                secondaryColor: ColorStyle.text200,
                uploadType: UploadType.image,
                path: pickedImagePath,
                onChanged: (pickedImagePath) {
                  setState(() {
                    this.pickedImagePath = pickedImagePath;
                  });
                },
              ),
              const SizedBox(
                height: 6.0,
              ),
              Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Category Name',
                      style: TextStyle(
                        color: ColorStyle.text200,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 3.0,
                    ),
                    CustomTextFromField(
                      controller: _controllerCategoryName,
                      hint: 'eg. Starters',
                      obscureText: false,
                      themeColor: getThemeColor(),
                    ),
                  ]),
              const SizedBox(
                height: 6.0,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: ColorStyle.backgroundColorAlter,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: PrimaryButton(
            child: const Text('Update'),
            color: getThemeColor(),
            onPressed: () async {
              if (_controllerCategoryName.text.trim() == '') {
                showSnackBar(context, '* Category name required');
                return;
              }

              try {
                widget.category.name =
                    _controllerCategoryName.text.trim();
                widget.category.image = pickedImagePath;
                widget.category.save();
                showSnackBar(context, 'Successfully updated');
                Navigator.of(context).pop();
              } catch (_) {
                showSnackBar(context, 'Failed to update');
              }
            },
          ),
        ),
      ),
    );
  }
}
