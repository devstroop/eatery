import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_pos/components/custom_text_from_field.dart';
import 'package:restaurant_pos/components/primary_button.dart';
import 'package:restaurant_pos/components/upload_button.dart';
import 'package:restaurant_pos/database/product_category.dart';
import 'package:restaurant_pos/services/utility/show_snack_bar.dart';
import 'package:restaurant_pos/style/color_style.dart';

class EditProductCategoryPage extends StatefulWidget {
  const EditProductCategoryPage({Key? key}) : super(key: key);

  @override
  State<EditProductCategoryPage> createState() => _EditProductCategoryPageState();
}

class _EditProductCategoryPageState extends State<EditProductCategoryPage> {
  String? pickedImagePath;
  final TextEditingController _controllerCategoryName = TextEditingController();

  clearFields() {
    setState(() {
      pickedImagePath = null;
      _controllerCategoryName.text = '';
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
          onPressed: () {
            // Delete safely
          },
          child: const Text('Delete'),
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
                  FilePickerResult? result = await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['jpg', 'png'],
                  );
                  if (result != null && result.files.isNotEmpty) {
                    setState(() {
                      pickedImagePath = result.files.first.path;
                    });
                  }
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
                  await ProductCategory.add({'image': pickedImagePath, 'name': _controllerCategoryName.text});
              if (response != null) {
                showSnackBar(context, 'Successfully update');
                clearFields();
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
