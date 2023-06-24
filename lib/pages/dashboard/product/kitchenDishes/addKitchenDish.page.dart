import 'dart:io';
import 'package:eatery/constants/extensions/string_extension.dart';
import 'package:eatery/constants/global_variables.dart';
import 'package:eatery/services/utility/library_image.dart';

import 'package:eatery_db/eatery_db.dart';
import 'package:flutter/material.dart';
import 'package:eatery/components/custom_text_from_field.dart';
import 'package:eatery/components/pos_category_widget.dart';
import 'package:eatery/services/utility/show_snack_bar.dart';
import 'package:eatery/constants/style/color_style.dart';

import '../../../../components/labeled_custom_text_from_field.dart';
import '../../../../widgets/buttons/primary.button.dart';
import '../../../../widgets/buttons/upload.button.dart';
import '../../../../widgets/switches/toggle.swich.dart';

Color _pageColor = ColorStyle.secondary;
class AddKitchenDish extends StatefulWidget {
  const AddKitchenDish({Key? key}) : super(key: key);

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

    final categoryBar = SizedBox(
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
      appBar: AppBar(
        backgroundColor: _pageColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(UIcons.regularStraight.arrow_left),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Add Kitchen Dish'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: ListView(
            controller: _scrollController,
            children: [
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
                  focusNode: focus1,
                  onFieldSubmitted: (v) {
                    FocusScope.of(context).requestFocus(focus2);
                  },
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
                        prefix: Icon(UIcons.regularStraight.rupee_sign, size: 14,),
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
                        prefix: Icon(UIcons.regularStraight.rupee_sign, size: 14,),
                        hint: '0.00',
                        themeColor: _pageColor,
                        focusNode: focus3,
                        onFieldSubmitted: (v) {
                          FocusScope.of(context).unfocus();
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
              Text(
                'Select Food Type',
                style: TextStyle(
                  color: ColorStyle.text400,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(
                height: 3.0,
              ),
              ToggleSwitch(
                highlightColor: selectedFoodType?.color ?? _pageColor,
                backgroundColor: const Color(0xFFE5E5E5),
                foregroundColor: Colors.white,
                inactiveForegroundColor: ColorStyle.text200,

                children: [
                  'None',
                  ...FoodType.values.map((e) => e.name),
                ],
                selectedIndex: selectedFoodType!= null ? selectedFoodType!.index + 1 : 0,
                onChange: (int? index) {
                  if (index == 0) {
                    setState(() {
                      selectedFoodType = null;
                    });
                  } else {
                    setState(() {
                      selectedFoodType = FoodType.values[index! - 1];
                    });
                  }
                },
              ),



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
