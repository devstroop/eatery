import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_pos/components/custom_text_from_field.dart';
import 'package:restaurant_pos/components/pos_category_widget.dart';
import 'package:restaurant_pos/components/primary_button.dart';
import 'package:restaurant_pos/components/upload_button.dart';
import 'package:restaurant_pos/database/dining_table.dart';
import 'package:restaurant_pos/database/dining_table_category.dart';
import 'package:restaurant_pos/pages/dining_table_categories_page.dart';
import 'package:restaurant_pos/services/utility/show_snack_bar.dart';
import 'package:restaurant_pos/style/color_style.dart';
class AddDiningTablePage extends StatefulWidget {
  const AddDiningTablePage({Key? key}) : super(key: key);

  @override
  State<AddDiningTablePage> createState() => _AddDiningTablePageState();
}

class _AddDiningTablePageState extends State<AddDiningTablePage> {
  String? pickedImagePath;
  String? selectedDiningTableCategory;
  final TextEditingController _controllerCategoryName = TextEditingController();

  clearFields(){
    setState(() {
      pickedImagePath = null;
      selectedDiningTableCategory = null;
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
      title: const Text('Add Dining Table'),
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
                  subTitle: 'Dining Table Image',
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
                  labelText: 'eg. Table 1 ',
                  obscureText: false,
                  themeColor: getThemeColor(),
                ),
              ]),
              const SizedBox(
                height: 6.0,
              ),
              SizedBox(
                width: double.maxFinite,
                height: 60,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        FutureBuilder(
                            future: DiningTableCategory.getAll(),
                            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                              if (snapshot.connectionState == ConnectionState.done) {
                                if (snapshot.hasData) {
                                  return Row(
                                    children: [
                                      for (var category in snapshot.data)
                                        PosCategoryWidget(
                                            active: selectedDiningTableCategory == category['id'],
                                            image: category['image'] != null && File(category['image']).existsSync()
                                                ? Image.file(File(category['image']))
                                                : null,
                                            label: category['name'],
                                            onTap: () {
                                              setState(
                                                    () {
                                                      selectedDiningTableCategory = category['id'];
                                                },
                                              );
                                            })
                                    ],
                                  );
                                }
                                return Container();
                              } else {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            }),
                      ],
                    ),
                  ),
                ),
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
            text: 'Save',
            backgroundColor: getThemeColor(),
            color: ColorStyle.background100,
            height: 50.0,
            onTap: () async {
              var response = await DiningTable.add({'image': pickedImagePath, 'name': _controllerCategoryName.text, 'category': selectedDiningTableCategory});
              if(response != null){
                showSnackBar(context, 'Successfully created');
                clearFields();
              }
              else{
                showSnackBar(context, 'Failed to create');
              }
            },
          ),
        ),
      ),
    );
  }
}
