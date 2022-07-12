import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:eatery/components/animated_toggle.dart';
import 'package:eatery/components/custom_text_from_field.dart';
import 'package:eatery/components/dialog_box.dart';
import 'package:eatery/components/food_type_selection_widget.dart';
import 'package:eatery/components/pos_category_widget.dart';
import 'package:eatery/components/primary_button.dart';
import 'package:eatery/components/upload_button.dart';
import 'package:eatery/database/product.dart';
import 'package:eatery/database/product_category.dart';
import 'package:eatery/extensions/app_file_system.dart';
import 'package:eatery/services/utility/generate.dart';
import 'package:eatery/services/utility/license.dart';
import 'package:eatery/services/utility/show_snack_bar.dart';
import 'package:eatery/style/color_style.dart';

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
  String? selectedTaxType = 'inclusive';
  final TextEditingController _controllerProductName = TextEditingController();
  final TextEditingController _controllerPrice = TextEditingController();
  final TextEditingController _controllerTax = TextEditingController();
  final TextEditingController _controllerDescription = TextEditingController();


  @override
  void initState(){
    super.initState();
    _controllerTax.text = widget.account['defaultTaxRate'].toString();
  }

  @override
  Widget build(BuildContext context) {
    Color getThemeColor() {
      return const Color(0xFF2FC289)/*ColorStyle.tertiary*/;
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
                    String? path = await AppFileSystem.pickImage(context);
                    setState(() {
                      pickedImagePath = path;
                    });
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
                        'Price',
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
                        controller: _controllerPrice,
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
                    AnimatedToggle(
                      values: const ['Veg', 'Non-Veg'],
                      onToggleCallback: (value) {
                        setState(() {
                          if (value == 0) {
                            setState(() {
                              selectedFoodType = 'veg';
                            });
                          } else {
                            setState(() {
                              selectedFoodType = 'nonVeg';
                            });
                          }
                        });
                      },
                      buttonColor: const Color(0xFF0A3157),
                      backgroundColor: const Color(0xFFB5C1CC),
                      textColor: const Color(0xFFFFFFFF),
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
                      'Tax Type',
                      style: TextStyle(
                        color: ColorStyle.text400,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    AnimatedToggle(
                      values: const ['Inclusive', 'Exclusive'],
                      onToggleCallback: (value) {
                        setState(() {
                          if (value == 0) {
                            setState(() {
                              selectedTaxType = 'inclusive';
                            });
                          } else {
                            setState(() {
                              selectedTaxType = 'exclusive';
                            });
                          }
                        });
                      },
                      buttonColor: const Color(0xFF0A3157),
                      backgroundColor: const Color(0xFFB5C1CC),
                      textColor: const Color(0xFFFFFFFF),
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
                        widget.account['taxName'],
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
              if (_controllerPrice.text.trim() == '') {
                showSnackBar(context, '* Price required');
                return;
              }
              if (selectedCategory == null) {
                showSnackBar(context, '* Select category');
                return;
              }


              bool flag = true;
              LicenseData licData = License.validate(widget.account['purchaseCode']);
              if(!licData.status){
                List<Map<String, dynamic>> products = (await Product.getAll());
                if(products.length >= 10){
                  flag = false;
                }
              }
              if(flag){
                var response = await Product.add({
                  'name': _controllerProductName.text,
                  'category': selectedCategory,
                  'description': _controllerDescription.text,
                  'price': double.parse(_controllerPrice.text),
                  'foodType': selectedFoodType,
                  'taxType': selectedTaxType,
                  'tax': double.parse(_controllerTax.text != '' ? _controllerTax.text : '0'),
                  'image': pickedImagePath,
                  'as': 'dish'
                });
                if (response != null) {
                  showSnackBar(context, 'Successfully created');
                  Navigator.pop(context);
                } else {
                  showSnackBar(context, 'Failed to create');
                }
              }
              else{
                showSnackBar(context, 'Please activate license to add more products');
                return;
              }
            },
          ),
        ),
      ),
    );
  }
}
