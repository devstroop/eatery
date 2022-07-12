import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:eatery/components/custom_text_from_field.dart';
import 'package:eatery/components/dialog_box.dart';
import 'package:eatery/components/primary_button.dart';
import 'package:eatery/components/upload_button.dart';
import 'package:eatery/database/product.dart';
import 'package:eatery/database/product_category.dart';
import 'package:eatery/extensions/app_file_system.dart';
import 'package:eatery/services/utility/generate.dart';
import 'package:eatery/services/utility/show_snack_bar.dart';
import 'package:eatery/style/color_style.dart';

class EditProductCategoryPage extends StatefulWidget {
  const EditProductCategoryPage({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  State<EditProductCategoryPage> createState() => _EditProductCategoryPageState();
}

class _EditProductCategoryPageState extends State<EditProductCategoryPage> {
  String? pickedImagePath;
  final TextEditingController _controllerCategoryName = TextEditingController();
  late Map<String, dynamic>? productCategory;


  @override
  initState() {
    super.initState();
    loadData();
  }
  loadData() async {
    var productCategory = await ProductCategory.get(widget.id);
    if(productCategory != null){
      setState((){
        this.productCategory = productCategory;
        pickedImagePath = this.productCategory!['image'];
        _controllerCategoryName.text = this.productCategory!['name'];
      });
    }
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
                          if ((await Product.getAll(category: widget.id)).isNotEmpty) {
                            showSnackBar(context, 'Can\'t delete');
                            return;
                          }
                          ProductCategory.delete(widget.id);
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
            style: TextStyle(color: ColorStyle.background100),
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
              InkWell(
                child: UploadButton(
                  title: '+ Upload Picture',
                  subTitle: 'Product Category Image',
                  primaryColor: getThemeColor(),
                  secondaryColor: ColorStyle.text200,
                  pickedImagePath: pickedImagePath,
                  onCloseTap: () {
                    setState(() {
                      pickedImagePath = null;
                    });
                  },
                ),
                onTap: () async {
                  String? path = await AppFileSystem.pickImage(context);
                  setState(() {
                    pickedImagePath = path;
                  });
                },
              ),
              const SizedBox(
                height: 6.0,
              ),
              Column(mainAxisSize: MainAxisSize.max, crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                  labelText: 'eg. Starters',
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
        color: ColorStyle.background100,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: PrimaryButton(
            text: 'Update',
            backgroundColor: getThemeColor(),
            color: ColorStyle.background100,
            height: 50.0,
            onTap: () async {
              if (_controllerCategoryName.text.trim() == '') {
                showSnackBar(context, '* Category name required');
                return;
              }
              var response =
                  await ProductCategory.update({'id': widget.id, 'image': pickedImagePath, 'name': _controllerCategoryName.text});
              if (response) {
                showSnackBar(context, 'Successfully updated');
                Navigator.of(context).pop();
              } else {
                showSnackBar(context, 'Failed to update');
              }
            },
          ),
        ),
      ),
    );
  }
}
