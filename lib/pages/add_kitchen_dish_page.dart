import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_pos/components/custom_text_from_field.dart';
import 'package:restaurant_pos/components/food_type_selection_widget.dart';
import 'package:restaurant_pos/components/pos_category_widget.dart';
import 'package:restaurant_pos/components/primary_button.dart';
import 'package:restaurant_pos/components/tax_type_selection_widget.dart';
import 'package:restaurant_pos/components/upload_button.dart';
import 'package:restaurant_pos/database/product.dart';
import 'package:restaurant_pos/database/product_category.dart';
import 'package:restaurant_pos/services/utility/show_snack_bar.dart';
import 'package:restaurant_pos/style/color_style.dart';

class AddKitchenDish extends StatefulWidget {
  const AddKitchenDish({Key? key, required this.account}) : super(key: key);
  final dynamic account;

  @override
  State<AddKitchenDish> createState() => _AddKitchenDishState();
}

class _AddKitchenDishState extends State<AddKitchenDish> {
  String? pickedImagePath;
  String? selectedCategory;
  String? selectedFoodType;
  String? selectedTaxType;
  final TextEditingController _controllerProductName = TextEditingController();
  final TextEditingController _controllerQuantity = TextEditingController();
  final TextEditingController _controllerWarningQuantity = TextEditingController();
  final TextEditingController _controllerSalePrice = TextEditingController();
  final TextEditingController _controllerMRP = TextEditingController();
  final TextEditingController _controllerTax = TextEditingController();
  final TextEditingController _controllerDescription = TextEditingController();


  Color getThemeColor() {
    return const Color(0xFF2FC289)/*ColorStyle.tertiary*/;
  }

  @override
  Widget build(BuildContext context) {
    Color getThemeColor() {
      return ColorStyle.tertiary;
    }

    final appBar = AppBar(
      backgroundColor: getThemeColor(),
      title: const Text('Add Dish'),
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
                        PosCategoryWidget(
                            active: selectedCategory == null,
                            image: null,
                            label: "Uncategorized",
                            onTap: () {
                              setState(
                                    () {
                                  selectedCategory = null;
                                },
                              );
                            }),
                        for (var category in snapshot.data)
                          PosCategoryWidget(
                              active: selectedCategory == category['id'],
                              image: category['image'] != null &&  File(category['image']).existsSync() ? Image.file(File(category['image'])) : null,
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
                    subTitle: 'Dish Image',
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
                        keyboardType: TextInputType.text,
                        controller: _controllerProductName,
                        labelText: '',
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
                        'MRP',
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
                        keyboardType: TextInputType.number,
                        prefixWidget: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.account['currencySymbol'] ?? '',
                              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18.0),
                            ),
                          ],
                        ),
                        controller: _controllerMRP,
                        labelText: '0.00',
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
                        'Sale Price',
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
                        keyboardType: TextInputType.number,
                        prefixWidget: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.account['currencySymbol'] ?? '',
                              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18.0),
                            ),
                          ],
                        ),
                        controller: _controllerSalePrice,
                        labelText: '0.00',
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
                      child: InkWell(
                          onTap: () {
                            if (selectedFoodType == 'veg') {
                              setState(() {
                                selectedFoodType = 'nonVeg';
                              });
                            } else if (selectedFoodType == 'nonVeg') {
                              setState(() {
                                selectedFoodType = null;
                              });
                            } else {
                              setState(() {
                                selectedFoodType = 'veg';
                              });
                            }
                          },
                          child: FoodTypeSelectionWidget(
                            foodType: selectedFoodType,
                          )),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 6.0,
                ),
                /*Row(
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
                        controller: _controllerQuantity,
                        labelText: '0',
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
                        'Warning Quantity',
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
                        controller: _controllerWarningQuantity,
                        labelText: '0',
                        obscureText: false,
                        themeColor: getThemeColor(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 6.0,
                ),*/
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tax Type',
                      style: TextStyle(
                        color: ColorStyle.text400,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Flexible(
                      child: InkWell(
                        child: TaxTypeSelectionWidget(taxType: selectedTaxType),
                        onTap: () {
                          if (selectedTaxType == 'inclusive') {
                            setState(() {
                              selectedTaxType = 'exclusive';
                            });
                          } else if (selectedTaxType == 'exclusive') {
                            setState(() {
                              selectedTaxType = null;
                            });
                          } else {
                            setState(() {
                              selectedTaxType = 'inclusive';
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 6.0,
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
                        keyboardType: TextInputType.number,
                        suffixWidget: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              '%',
                              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18.0),
                            ),
                          ],
                        ),
                        enabled: selectedTaxType != null,
                        controller: _controllerTax,
                        labelText: '0.00',
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
                    keyboardType: TextInputType.multiline,
                    controller: _controllerDescription,
                    labelText: '- Describe your dish \n- Highlight ingredients used\n- Keep it simple',
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
              if (_controllerProductName.text.trim() == '') {
                showSnackBar(context, '* Product name required');
                return;
              }
              if (_controllerMRP.text.trim() == '' && _controllerSalePrice.text.trim() == '') {
                showSnackBar(context, '* MRP or Sale Price required');
                return;
              }
              if (selectedCategory == null) {
                showSnackBar(context, '* Select category');
                return;
              }
              var response = await Product.add({
                'name': _controllerProductName.text,
                'category': selectedCategory,
                'description': _controllerDescription.text,
                /*'quantity': _controllerQuantity.text,
                'warningQuantity': _controllerWarningQuantity.text,*/
                'unit': '',
                'mrp': _controllerMRP.text,
                'salePrice': _controllerSalePrice.text,
                'foodType': selectedFoodType,
                'taxType': selectedTaxType,
                'tax': _controllerTax.text,
                'image': pickedImagePath,
                'as': 'dish'
              });
              if (response != null) {
                showSnackBar(context, 'Successfully created');
                Navigator.pop(context);
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
