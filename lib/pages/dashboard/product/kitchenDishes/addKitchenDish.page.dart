import 'dart:io';
import 'package:eatery/constants/extensions/string_extension.dart';
import 'package:eatery/constants/global_variables.dart';
import 'package:eatery/services/utility/library_image.dart';

import 'package:eatery_db/eatery_db.dart';
import 'package:flutter/material.dart';
import 'package:eatery/components/custom_text_from_field.dart';
import 'package:eatery/components/pos_category_widget.dart';
import 'package:eatery_components/buttons/primary.button.dart';
import 'package:eatery_components/switches/toggle.switch.dart';
import 'package:eatery/services/utility/show_snack_bar.dart';
import 'package:eatery/constants/style/color_style.dart';

import '../../../../widgets/buttons/upload.button.dart';

class AddKitchenDish extends StatefulWidget {
  const AddKitchenDish({Key? key, required this.company}) : super(key: key);
  final Company company;

  @override
  State<AddKitchenDish> createState() => _AddKitchenDishState();
}

class _AddKitchenDishState extends State<AddKitchenDish> {
  LibraryImage? image;
  ProductCategory? selectedCategory;
  FoodType? selectedFoodType;
  TaxSlab? selectedTaxSlab;
  
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerMRP = TextEditingController();
  final TextEditingController _controllerSalePrice = TextEditingController();
  final TextEditingController _controllerDescription = TextEditingController();


  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final focus3 = FocusNode();
  final focus4 = FocusNode();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, (){
      // TODO: If company has default tax slab then set it as selected
    });

  }

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    Color getThemeColor() {
      return ColorStyle.secondary;
    }

    final appBar = AppBar(
      backgroundColor: getThemeColor(),
      title: const Text('Add Dish'),
    );
    final categoryBar = InkWell(
        onTap: () {
            Focus.of(context).unfocus();
          },
          child: SizedBox(
      width: double.maxFinite,
      height: 60,
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
          child: Row(
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
              for (var category in EateryDB.instance.productCategoryBox.values)
                PosCategoryWidget(
                    active: selectedCategory == category,
                    image: category.image != null &&
                            File(category.image!).existsSync()
                        ? Image.file(File(category.image!))
                        : null,
                    label: category.name,
                    onTap: () {
                      setState(
                        () {
                          selectedCategory = category;
                        },
                      );
                    }),
            ],
          ),
        ),
      ),
    );

    return Scaffold(
      appBar: appBar,
      body: InkWell(
        onTap: () {
            Focus.of(context).unfocus();
          },
        child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(
                    height: 12.0,
                  ),
                  UploadButton(
                    label: 'Product Image',
                    primaryColor: getThemeColor(),
                    secondaryColor: ColorStyle.text200,
                    image: image?.image,
                    onChanged: (image) {
                      setState(() {
                        this.image = image;
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
                            controller: _controllerName,
                            hint: '',
                            obscureText: false,
                            themeColor: getThemeColor(),
                            focusNode: focus1,
                            onFieldSubmitted: (v) {
                              FocusScope.of(context).requestFocus(focus2);
                            },
                            validator: (value) {
                              if (value!.trim().isEmpty) {
                                return 'Product name cannot be blank';
                              }
                              return null;
                            }),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 2,
                        child: Text(
                          'M.R.P.',
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
                            controller: _controllerMRP,
                            keyboardType: TextInputType.number,
                            prefix: Text(
                              GlobalVariables.currency?.symbol ?? '',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 18.0),
                            ),
                            hint: '0.00',
                            obscureText: false,
                            themeColor: getThemeColor(),
                            focusNode: focus2,
                            onFieldSubmitted: (v) {
                              FocusScope.of(context).requestFocus(focus3);
                            },
                            validator: (value) {
                              if (value!.trim().isEmpty) {
                                return 'Price cannot be blank';
                              }
                              return null;
                            }),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 2,
                        child: Text(
                          'Sale price',
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
                            controller: _controllerSalePrice,
                            keyboardType: TextInputType.number,
                            prefix: Text(
                              GlobalVariables.currency?.symbol ?? '',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 18.0),
                            ),
                            hint: '0.00',
                            obscureText: false,
                            themeColor: getThemeColor(),
                            focusNode: focus3,
                            onFieldSubmitted: (v) {
                              FocusScope.of(context).requestFocus(focus4);
                            },
                            validator: (value) {
                              return null;
                            }),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12.0,
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
                      ToggleSwitch(
                        nullableValue: 'None',
                        color:
                            selectedFoodType != null ? selectedFoodType!.color : Colors.grey,
                        options: [for (var each in FoodType.values) each.name],
                        index: selectedFoodType?.index,
                        onChange: (int? index) {
                          if (index == null) {
                            selectedFoodType = null;
                          } else {
                            selectedFoodType = FoodType.values
                                .singleWhere((element) => element.id == index);
                          }
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tax slab',
                        style: TextStyle(
                          color: ColorStyle.text400,
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Column(
                        children: [
                          ToggleSwitch(
                            nullableValue: 'None',
                            color: selectedTaxSlab != null
                                ? getThemeColor()
                                : Colors.grey,
                            options: [
                              for (var each
                                  in EateryDB.instance.taxSlabBox.values)
                                each.name
                            ],
                            index: selectedTaxSlab?.id,
                            onChange: (int? index) {
                              if (index == null) {
                                selectedTaxSlab = null;
                              } else {
                                selectedTaxSlab = EateryDB.instance.taxSlabBox.values
                                    .singleWhere(
                                        (element) => element.id == index);
                              }
                              setState(() {});
                            },
                          ),
                          if (selectedTaxSlab != null)
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                '${selectedTaxSlab!.rate}% (${selectedTaxSlab!.type.name})',
                                style: TextStyle(
                                    color: getThemeColor(),
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                  Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                            hint:
                                '- Describe your dish \n- Highlight ingredients used\n- Keep it simple',
                            obscureText: false,
                            themeColor: getThemeColor(),
                            minLines: 4,
                            maxLines: 8,
                            focusNode: focus4,
                            onFieldSubmitted: (v) {
                              FocusScope.of(context).unfocus();
                            },
                            validator: (value) {
                              return null;
                            }),
                      ]),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: ColorStyle.backgroundColorAlter,
        child: PrimaryButton(
          color: getThemeColor(),
          onPressed: () async {
            final isValid = _formKey.currentState!.validate();
            if (!isValid) {
              return;
            }
            _formKey.currentState!.save();
            Product product = Product(
                id: EateryDB.instance.productBox.nextId(),
                name: _controllerName.text,
                categoryId: selectedCategory?.id,
                description: _controllerDescription.text,
                image: image?.filename,
                mrpPrice: _controllerMRP.text.toDouble() ?? 0.0,
                salePrice: _controllerSalePrice.text.toDouble(),
                taxSlabId: selectedTaxSlab?.id,
                foodType: selectedFoodType,
                type: ProductType.kitchenDish,
                isActive: true);
            EateryDB.instance.productBox.add(product).whenComplete(() {
              showSnackBar(context, 'Successfully created');
              Navigator.pop(context);
            }).onError((error, stackTrace) {
              showSnackBar(context, 'Failed to create');
              return Future.error(false);
            });
          },
          child: const Text('Save'),
        ),
      ),
    );
  }
}
