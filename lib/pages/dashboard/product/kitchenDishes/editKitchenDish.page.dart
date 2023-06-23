import 'dart:io';
import 'package:eatery/constants/extensions/string_extension.dart';
import 'package:eatery/services/utility/library_image.dart';

import 'package:eatery_db/eatery_db.dart';
import 'package:flutter/material.dart';
import 'package:eatery/components/custom_text_from_field.dart';
import 'package:eatery/components/pos_category_widget.dart';
import 'package:eatery_components/buttons/primary.button.dart';
import 'package:eatery_components/switches/toggle.switch.dart';
import 'package:eatery/services/utility/show_snack_bar.dart';
import 'package:eatery/constants/style/color_style.dart';

import '../../../../constants/global_variables.dart';
import '../../../../widgets/buttons/upload.button.dart';

class EditKitchenDish extends StatefulWidget {
  const EditKitchenDish(
      {Key? key, required this.product})
      : super(key: key);
  final Product product;
  @override
  State<EditKitchenDish> createState() => _EditKitchenDishState();
}

class _EditKitchenDishState extends State<EditKitchenDish> {
  LibraryImage? image;
  ProductCategory? _category;

  FoodType? _foodType;
  TaxSlab? _taxSlab;
  final TextEditingController _ctrlName = TextEditingController();
  final TextEditingController _ctrlMRP = TextEditingController();
  final TextEditingController _ctrlSP = TextEditingController();
  final TextEditingController _ctrlDesc = TextEditingController();

  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final focus3 = FocusNode();
  final focus4 = FocusNode();
  final _formKey = GlobalKey<FormState>();
  String? _currencySymbol;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, (){
      
    });
    try {
      _currencySymbol = EateryDB.instance.currencyBox.values
          .singleWhere((element) => element.id == GlobalVariables.company!.currencyId)
          .symbol;
    } catch (_) {}
    image = LibraryImage(widget.product.image);
    _ctrlName.text = widget.product.name;
    _ctrlMRP.text = widget.product.mrpPrice.toString();
    _ctrlSP.text = widget.product.salePrice != null
        ? widget.product.salePrice.toString()
        : '';
    _foodType = widget.product.foodType;
    _taxSlab = EateryDB.instance.taxSlabBox.values
        .singleWhere((element) => element.id == widget.product.taxSlabId);
    _category = EateryDB.instance.productCategoryBox.values
        .singleWhere((element) => element.id == widget.product.categoryId);
    _ctrlDesc.text = widget.product.description ?? '';
    setState(() {});
  }

  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    Color getThemeColor() {
      return ColorStyle.secondary;
    }

    final appBar = AppBar(
      backgroundColor: getThemeColor(),
      title: const Text('Edit Dish'),
    );
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
                  active: _category == null,
                  image: null,
                  label: "Uncategorized",
                  onTap: () {
                    setState(
                      () {
                        _category = null;
                      },
                    );
                  }),
              for (var category in EateryDB.instance.productCategoryBox.values)
                PosCategoryWidget(
                    active: _category == category,
                    image: category.image != null &&
                            File(category.image!).existsSync()
                        ? Image.file(File(category.image!))
                        : null,
                    label: category.name,
                    onTap: () {
                      setState(
                        () {
                          _category = category;
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
      body: SizedBox(
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
                            controller: _ctrlName,
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
                            controller: _ctrlMRP,
                            keyboardType: TextInputType.number,
                            prefixWidget: _currencySymbol != null
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        _currencySymbol ?? '',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18.0),
                                      ),
                                    ],
                                  )
                                : null,
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
                            controller: _ctrlSP,
                            keyboardType: TextInputType.number,
                            prefixWidget: _currencySymbol != null
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        _currencySymbol ?? '',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18.0),
                                      ),
                                    ],
                                  )
                                : null,
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
                            _foodType != null ? _foodType!.color : Colors.grey,
                        options: [for (var each in FoodType.values) each.name],
                        index: _foodType?.index,
                        onChange: (int? index) {
                          if (index == null) {
                            _foodType = null;
                          } else {
                            _foodType = FoodType.values
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
                            color: _taxSlab != null
                                ? getThemeColor()
                                : Colors.grey,
                            options: [
                              for (var each
                                  in EateryDB.instance.taxSlabBox.values)
                                each.name
                            ],
                            index: _taxSlab?.id,
                            onChange: (int? index) {
                              if (index == null) {
                                _taxSlab = null;
                              } else {
                                _taxSlab = EateryDB.instance.taxSlabBox.values
                                    .singleWhere(
                                        (element) => element.id == index);
                              }
                              setState(() {});
                            },
                          ),
                          if (_taxSlab != null)
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                '${_taxSlab!.rate}% (${_taxSlab!.type.name})',
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
                            controller: _ctrlDesc,
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
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: PrimaryButton(
            color: getThemeColor(),
            onPressed: () async {
              final isValid = _formKey.currentState!.validate();
              if (!isValid) {
                return;
              }
              _formKey.currentState!.save();

              try {
                widget.product.image = image?.filename;
                widget.product.name = _ctrlName.text;
                widget.product.mrpPrice = _ctrlMRP.text.toDouble() ?? 0;
                widget.product.salePrice = _ctrlSP.text.toDouble();
                widget.product.foodType = _foodType;
                widget.product.taxSlabId = _taxSlab?.id;
                widget.product.categoryId = _category?.id;
                widget.product.description = _ctrlDesc.text;
                await widget.product.save().whenComplete(() {
                  showSnackBar(context, 'Successfully updated');
                  Navigator.pop(context);
                });
              } catch (_) {
                showSnackBar(context, 'Failed to update');
              }
            },
            child: const Text('Save'),
          ),
        ),
      ),
    );
  }
}
