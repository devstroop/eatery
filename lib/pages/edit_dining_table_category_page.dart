import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:restaurant_pos/components/custom_text_from_field.dart';
import 'package:restaurant_pos/components/dialog_box.dart';
import 'package:restaurant_pos/components/primary_button.dart';
import 'package:restaurant_pos/components/upload_button.dart';
import 'package:restaurant_pos/database/dining_table.dart';
import 'package:restaurant_pos/database/dining_table_category.dart';
import 'package:restaurant_pos/extensions/app_file_system.dart';
import 'package:restaurant_pos/services/utility/generate.dart';
import 'package:restaurant_pos/services/utility/show_snack_bar.dart';
import 'package:restaurant_pos/style/color_style.dart';

class EditDiningTableCategoryPage extends StatefulWidget {
  const EditDiningTableCategoryPage({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  State<EditDiningTableCategoryPage> createState() => _EditDiningTableCategoryPageState();
}

class _EditDiningTableCategoryPageState extends State<EditDiningTableCategoryPage> {
  String? pickedImagePath;
  final TextEditingController _controllerCategoryName = TextEditingController();
  late Map<String, dynamic>? diningTableCategory;

  @override
  initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    var diningTableCategory = await DiningTableCategory.get(widget.id);
    if (diningTableCategory != null) {
      setState(() {
        this.diningTableCategory = diningTableCategory;
        pickedImagePath = this.diningTableCategory!['image'];
        _controllerCategoryName.text = this.diningTableCategory!['name'];
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
      title: const Text('Edit Dining Table Category'),
      actions: [
        TextButton(
          onPressed: () {
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
                          if ((await DiningTable.getAll(category: widget.id)).isNotEmpty) {
                            showSnackBar(context, 'Can\'t delete');
                            return;
                          }
                          DiningTableCategory.delete(widget.id);
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
                  subTitle: 'Dining Table Category Image',
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
                  String? path = await AppFileSystem.pickImage();
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
                  labelText: 'eg. Terrace',
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
              var response = await DiningTableCategory.update(
                  {'id': widget.id, 'image': pickedImagePath, 'name': _controllerCategoryName.text});
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
