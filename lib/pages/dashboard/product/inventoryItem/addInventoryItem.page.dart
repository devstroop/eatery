import 'dart:io';
import 'package:eatery/constants/extensions/string_extension.dart';
import 'package:eatery/services/utility/library_image.dart';
import 'package:eatery/widgets/posWidgets/circularCategory.posWidget.dart';

import 'package:eatery_db/eatery_db.dart';
import 'package:flutter/material.dart';
import 'package:eatery/components/custom_text_from_field.dart';
import 'package:eatery/components/pos_category_widget.dart';
import 'package:eatery_components/buttons/primary.button.dart';
import 'package:eatery_components/switches/toggle.switch.dart';
import 'package:eatery/services/utility/show_snack_bar.dart';
import 'package:eatery/constants/style/color_style.dart';

import '../../../../components/labeled_custom_text_from_field.dart';
import '../../../../constants/global_variables.dart';
import '../../../../widgets/buttons/upload.button.dart';

Color _pageColor = ColorStyle.secondary;

class AddInventoryItem extends StatefulWidget {
  const AddInventoryItem({Key? key}) : super(key: key);

  @override
  State<AddInventoryItem> createState() => _AddInventoryItemState();
}

class _AddInventoryItemState extends State<AddInventoryItem> {
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
    Future.delayed(Duration.zero, () {
      // TODO: If company has default tax slab then set it as selected
    });
  }

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _pageColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(UIcons.regularStraight.arrow_left),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Add Inventory Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(
                height: 12.0,
              ),
              UploadButton(
                label: 'Product Image',
                primaryColor: _pageColor,
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
              LabeledCustomTextFromField(
                  label: 'Category Name',
                  hint: 'Enter product category name',
                  // Write a hint for category name field
                  foregroundColor: ColorStyle.text200,
                  themeColor: _pageColor,
                  controller: _controllerName),
              const SizedBox(
                height: 6.0,
              ),
              Row(
                children: [
                  Flexible(
                    child: LabeledCustomTextFromField(
                        label: 'MRP (Max. retail price)',
                        prefix: Text(
                          GlobalVariables.currency?.symbol ?? '',
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 18.0, color: Colors.black54),
                        ),
                        hint: '0.00',
                        themeColor: _pageColor,
                        focusNode: focus2,
                        onFieldSubmitted: (v) {
                          FocusScope.of(context).requestFocus(focus3);
                        },
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return 'Price cannot be blank';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        foregroundColor: ColorStyle.text200,
                        controller: _controllerMRP),
                  ),
                  const SizedBox(width: 12.0,),
                  Flexible(
                    child: LabeledCustomTextFromField(
                        label: 'Sale Price',
                        prefix: Text(
                          GlobalVariables.currency?.symbol ?? '',
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 18.0, color: Colors.black54),
                        ),
                        hint: '0.00',
                        themeColor: _pageColor,
                        focusNode: focus2,
                        onFieldSubmitted: (v) {
                          FocusScope.of(context).requestFocus(focus3);
                        },
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return 'Price cannot be blank';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        foregroundColor: ColorStyle.text200,
                        controller: _controllerSalePrice),
                  ),
                ],
              ),
              const SizedBox(
                height: 6.0,
              ),
              ToggleSwitch(
                nullableValue: 'None',
                color: selectedFoodType != null
                    ? selectedFoodType?.color
                    : Colors.grey,
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
              const SizedBox(
                height: 6.0,
              ),
              Column(
                children: [
                  ToggleSwitch(
                    nullableValue: 'None',
                    color:
                        selectedTaxSlab != null ? _pageColor : Colors.grey,
                    options: [
                      for (var each in EateryDB.instance.taxSlabBox.values)
                        each.name
                    ],
                    index: selectedTaxSlab?.id,
                    onChange: (int? index) {
                      if (index == null) {
                        selectedTaxSlab = null;
                      } else {
                        selectedTaxSlab = EateryDB
                            .instance.taxSlabBox.values
                            .singleWhere((element) => element.id == index);
                      }
                      setState(() {});
                    },
                  ),
                  if (selectedTaxSlab != null)
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        '${selectedTaxSlab?.rate}% (${selectedTaxSlab?.type.name})',
                        style: TextStyle(
                            color: _pageColor,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                ],
              ),
              const SizedBox(
                height: 6.0,
              ),
              Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select a category',
                      style: TextStyle(
                        color: ColorStyle.text400,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(
                      height: 3.0,
                    ),
                    SizedBox(
                      width: double.maxFinite,
                      height: 97,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          CircularCategoryPOSWidget(
                            themeColor: _pageColor,
                            margin: const EdgeInsets.symmetric(horizontal: 8.0),
                            image: const AssetImage('assets/images/default.jpg'), label: 'None', selected: selectedCategory == null, onTap: (){
                            setState(() {
                              selectedCategory = null;
                            });
                          },),
                          ...EateryDB.instance.productCategoryBox.values.map((e) {
                            return CircularCategoryPOSWidget(
                              themeColor: _pageColor,
                              margin: const EdgeInsets.symmetric(horizontal: 8.0),
                              image: LibraryImage(e.image).image,
                              label: e.name,
                              selected: selectedCategory == e,
                              onTap: () {
                                setState(() {
                                  selectedCategory = e;
                                });
                              },
                            );
                          }),
                        ],
                      ),
                    )
                  ]),
              const SizedBox(
                height: 6.0,
              ),
              LabeledCustomTextFromField(
                  label: 'Description',
                  hint: 'Enter product description',
                  multiline: true,
                  foregroundColor: ColorStyle.text200,
                  themeColor: _pageColor,
                  controller: _controllerDescription),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: ColorStyle.backgroundColorAlter,
        child: PrimaryButton(
          color: _pageColor,
          onPressed: () async {
            final isValid = _formKey.currentState!.validate();
            if (!isValid) {
              return;
            }
            _formKey.currentState!.save();

            try {
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
                  type: ProductType.inventoryItem,
                  isActive: true);
              await EateryDB.instance.productBox
                  .add(product)
                  .whenComplete(() {
                showSnackBar(context, 'Successfully created');
                Navigator.pop(context);
              });
            } catch (_) {
              showSnackBar(context, 'Failed to create');
            }
          },
          child: const Text('Save'),
        ),
      ),
    );
  }
}
