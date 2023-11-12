import 'package:eatery/references.dart';

Color _pageColor = KColors.secondary;

class EditKitchenDishPage extends StatefulWidget {
  const EditKitchenDishPage(
      {Key? key, required this.product})
      : super(key: key);
  final Product product;
  @override
  State<EditKitchenDishPage> createState() => _EditKitchenDishPageState();
}

class _EditKitchenDishPageState extends State<EditKitchenDishPage> {
  LibraryImage? image;
  ProductCategory? selectedCategory;
  FoodType? selectedFoodType;
  TaxSlab? selectedTaxSlab;

  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerMRP = TextEditingController();
  final TextEditingController _controllerSalePrice = TextEditingController();
  final TextEditingController _controllerDescription = TextEditingController();


  final List<FocusNode> _focusNodes = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
  ];

  final _formKey = GlobalKey<FormState>();
  
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, (){
      setState(() {
        image = LibraryImage(widget.product.image);
        _controllerName.text = widget.product.name;
        _controllerMRP.text = widget.product.mrpPrice.toString();
        _controllerSalePrice.text = widget.product.salePrice != null
            ? widget.product.salePrice.toString()
            : '';
        selectedFoodType = widget.product.foodType;
        selectedTaxSlab = EateryDB.instance.taxSlabBox!.values
            .where((element) => element.id == widget.product.taxSlabId).firstOrNull;
        selectedCategory = EateryDB.instance.productCategoryBox!.values
            .where((element) => element.id == widget.product.categoryId).firstOrNull;
        _controllerDescription.text = widget.product.description ?? '';
      });
    });
    _focusNodes[0].requestFocus();
  }

  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: _pageColor,
        foregroundColor: Colors.white,
        
        title: const Text('Edit Kitchen Dish'),
        actions: [
          if (_focusNodes[0].hasFocus ||
              _focusNodes[1].hasFocus ||
              _focusNodes[2].hasFocus ||
              _focusNodes[3].hasFocus ||
              _focusNodes[4].hasFocus)
            IconButton(
              icon: const Icon(Icons.done),
              onPressed: () {
                FocusScope.of(context).unfocus();
              },
            ),
        ],
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
                secondaryColor: KColors.black600,
                libraryImage: image,
                onChanged: (image) {
                  setState(() {
                    this.image = image;
                  });
                },
              ),
              const SizedBox(
                height: 6.0,
              ),
              LabeledCustomTextFormField(
                  label: 'Name',
                  hint: 'Enter product name',
                  focusNode: _focusNodes[0],
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return 'Name cannot be blank';
                    } else if (value.trim().length < 3) {
                      return 'Name must be at least 3 characters long';
                    } else if (value.trim().length > 50) {
                      return 'Name cannot be more than 50 characters long';
                    } else if (EateryDB.instance.productBox!.values
                        .any((element) =>
                    element.id != widget.product.id &&
                        element.name.toLowerCase() ==
                            value!.trim().toLowerCase())) {
                      return 'Product with this name already exists';
                    }
                    return null;
                  },
                  onFieldSubmitted: (v) {
                    _focusNodes[1].requestFocus();
                  },
                  foregroundColor: KColors.black600,
                  themeColor: _pageColor,
                  controller: _controllerName),
              const SizedBox(
                height: 6.0,
              ),
              Row(
                children: [
                  Flexible(
                    child: LabeledCustomTextFormField(
                        label: 'MRP (Max. retail price)',
                        prefix: const Icon(Icons.currency_rupee, size: 14,),
                        hint: '0.00',
                        themeColor: _pageColor,
                        focusNode: _focusNodes[1],
                        onFieldSubmitted: (v) {
                          _focusNodes[2].requestFocus();
                        },
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return 'Price cannot be blank';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        foregroundColor: KColors.black600,
                        controller: _controllerMRP),
                  ),
                  const SizedBox(width: 12.0,),
                  Flexible(
                    child: LabeledCustomTextFormField(
                        label: 'Sale Price',
                        prefix: const Icon(Icons.currency_rupee, size: 14,),
                        hint: '0.00',
                        themeColor: _pageColor,
                        focusNode: _focusNodes[2],
                        onFieldSubmitted: (v) {
                          _focusNodes[3].requestFocus();
                        },
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return 'Price cannot be blank';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        foregroundColor: KColors.black600,
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
                  color: KColors.white600,
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
                inactiveForegroundColor: KColors.black600,

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
              const SizedBox(
                height: 6.0,
              ),


              Text(
                'Select Tax Slab',
                style: TextStyle(
                  color: KColors.white600,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(
                height: 3.0,
              ),
              ToggleSwitch(
                highlightColor: _pageColor,
                backgroundColor: const Color(0xFFE5E5E5),
                foregroundColor: selectedTaxSlab == null ? Colors.white : KColors.black600,
                children: [
                  'None',
                  for (var each in EateryDB.instance.taxSlabBox!.values)
                    each.name
                ],
                selectedIndex: (selectedTaxSlab?.id == null) ? 0 : selectedTaxSlab?.id,
                onChange: (int? index) {
                  if (index == 0) {
                    selectedTaxSlab = null;
                  } else {
                    selectedTaxSlab = EateryDB
                        .instance.taxSlabBox!.values
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
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              const SizedBox(
                height: 6.0,
              ),
              Text(
                'Select Category',
                style: TextStyle(
                  color: KColors.white600,
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
                    ...EateryDB.instance.productCategoryBox!.values.map((e) {
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
              ),
              const SizedBox(
                height: 6.0,
              ),
              LabeledCustomTextFormField(
                  label: 'Description',
                  hint: 'Enter product description',
                  multiline: true,
                  focusNode: _focusNodes[3],
                  onFieldSubmitted: (v) {
                    FocusScope.of(context).unfocus();
                  },
                  foregroundColor: KColors.black600,
                  themeColor: _pageColor,
                  controller: _controllerDescription),


            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: KColors.white,
        child: PrimaryButton(
          color: _pageColor,
          onPressed: () async {
            final isValid = _formKey.currentState!.validate();
            if (!isValid) {
              return;
            }
            _formKey.currentState!.save();

            widget.product.image = image?.filename;
            widget.product.name = _controllerName.text;
            widget.product.mrpPrice = _controllerMRP.text.toDouble() ?? 0;
            widget.product.salePrice = _controllerSalePrice.text.toDouble();
            widget.product.foodType = selectedFoodType;
            widget.product.taxSlabId = selectedTaxSlab?.id;
            widget.product.categoryId = selectedCategory?.id;
            widget.product.description = _controllerDescription.text;
            await widget.product.save().then((value) {
              showMessageDialog(this.context, 'Product updated successfully', MessageType.success).whenComplete(() => Navigator.pop(this.context));
            }).onError((error, stackTrace) {
              showMessageDialog(this.context, 'Failed to update product', MessageType.error);
            });
          },
          child: const Text('Save'),
        ),
      ),
    );
  }
}
