import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_pos/components/custom_text_from_field.dart';
import 'package:restaurant_pos/components/food_type_selection_widget.dart';
import 'package:restaurant_pos/components/pos_category_widget.dart';
import 'package:restaurant_pos/components/primary_button.dart';
import 'package:restaurant_pos/components/upload_button.dart';
import 'package:restaurant_pos/database/product.dart';
import 'package:restaurant_pos/database/product_category.dart';
import 'package:restaurant_pos/services/utility/show_snack_bar.dart';
import 'package:restaurant_pos/style/color_style.dart';

class AddInventoryItemPage extends StatefulWidget {
  const AddInventoryItemPage({Key? key}) : super(key: key);

  @override
  State<AddInventoryItemPage> createState() => _AddInventoryItemPageState();
}

class _AddInventoryItemPageState extends State<AddInventoryItemPage> {
  String? pickedImagePath;
  int? selectedCategory;
  String? selectedFoodType = 'veg';
  final TextEditingController _controllerProductName = TextEditingController();
  final TextEditingController _controllerQuantity = TextEditingController();
  final TextEditingController _controllerUnitPrice = TextEditingController();
  final TextEditingController _controllerFoodType = TextEditingController();
  final TextEditingController _controllerTax = TextEditingController();
  final TextEditingController _controllerDescription = TextEditingController();

  clearFields() {
    setState(() {
      pickedImagePath = null;
      selectedCategory = null;
      selectedFoodType = null;
      _controllerProductName.text = '';
    });
  }

  Color getThemeColor() {
    return ColorStyle.tertiary;
  }

  @override
  Widget build(BuildContext context) {
    Color getThemeColor() {
      return ColorStyle.tertiary;
    }

    final appBar = AppBar(
      backgroundColor: getThemeColor(),
      title: const Text('Add Item'),
    );
    final categoryBar = SizedBox(
      width: double.maxFinite,
      height: 60,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
          child: FutureBuilder(
              future: ProductCategory.getAll(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return Row(
                        mainAxisSize: MainAxisSize.max,
                      children: [
                        for (var category in snapshot.data)
                      PosCategoryWidget(
                          active: selectedCategory == category['id'],
                          image: File(category['image']).existsSync() ? Image.file(File(category['image'])) : null,
                          label: category['name'],
                          onTap: () {
                            setState(
                                  () {
                                selectedCategory = category['id'];
                              },
                            );
                          })

                      ],
                    );
                  }
                  return const Text('No categories found');
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        ),
      ),
    );
    return Scaffold(
      appBar: appBar,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
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
                    subTitle: 'Item Image',
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Text(
                        'Name',
                        style: TextStyle(
                          color: ColorStyle.text400,
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const Flexible(flex: 1, child: SizedBox()),
                    Flexible(
                      flex: 4,
                      child: CustomTextFromField(
                        controller: _controllerProductName,
                        labelText: 'eg. Lays',
                        obscureText: false,
                        themeColor: getThemeColor(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 6.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 2,
                      child: Text(
                        'Quantity(Optional)',
                        style: TextStyle(
                          color: ColorStyle.text400,
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const Flexible(flex: 1, child: SizedBox()),
                    Flexible(
                      flex: 2,
                      child: CustomTextFromField(
                        controller: _controllerProductName,
                        labelText: 'eg. Lays',
                        obscureText: false,
                        themeColor: getThemeColor(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 6.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 2,
                      child: Text(
                        'Unit Price',
                        style: TextStyle(
                          color: ColorStyle.text400,
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const Flexible(flex: 1, child: SizedBox()),
                    Flexible(
                      flex: 2,
                      child: CustomTextFromField(
                        controller: _controllerProductName,
                        labelText: 'eg. Lays',
                        obscureText: false,
                        themeColor: getThemeColor(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 6.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Type',
                      style: TextStyle(
                        color: ColorStyle.text400,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Flexible(
                      child: InkWell(onTap: (){
                        setState((){
                          if(selectedFoodType == 'veg'){
                            selectedFoodType = 'nonVeg';
                          }else if(selectedFoodType == 'nonVeg'){
                            selectedFoodType = null;
                          }else{
                            selectedFoodType = 'veg';
                          }
                        });
                      },child: FoodTypeSelectionWidget(foodType: selectedFoodType,)),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 6.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 2,
                      child: Text(
                        'GST',
                        style: TextStyle(
                          color: ColorStyle.text400,
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const Flexible(flex: 1, child: SizedBox()),
                    Flexible(
                      flex: 2,
                      child: CustomTextFromField(
                        controller: _controllerProductName,
                        labelText: 'eg. Lays',
                        obscureText: false,
                        themeColor: getThemeColor(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12.0,
                ),
                Column(mainAxisSize: MainAxisSize.max, crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    'Choose a category',
                    style: TextStyle(
                      color: ColorStyle.text400,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(
                    height: 3.0,
                  ),
                  categoryBar
                ]),






                const SizedBox(
                  height: 6.0,
                ),
                Column(mainAxisSize: MainAxisSize.max, crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    'Description',
                    style: TextStyle(
                      color: ColorStyle.text400,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(
                    height: 3.0,
                  ),
                  CustomTextFromField(
                    controller: _controllerProductName,
                    labelText: 'eg. Lays',
                    obscureText: false,
                    themeColor: getThemeColor(),
                    minLines: 4,
                    maxLines: 8,
                  ),
                ]),
              ],
            ),
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
              var response =
                  await Product.add({
                    'name': _controllerProductName.text,
                    'category': selectedCategory,
                    'description': _controllerDescription.text,
                    'quantity': _controllerQuantity.text,
                    'unitPrice': _controllerUnitPrice.text,
                    'foodType': _controllerFoodType.text,
                    'tax': _controllerTax.text,
                    'image': pickedImagePath,
                    'as': 'item'
                  });
              if (response != null) {
                showSnackBar(context, 'Successfully created');
                clearFields();
              } else {
                showSnackBar(context, 'Failed to create');
              }
            },
          ),
        ),
      ),
    );
  }
}
