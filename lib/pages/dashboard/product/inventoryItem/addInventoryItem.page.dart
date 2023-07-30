import 'package:eatery/references.dart';

Color _pageColor = ColorStyle.alternate;

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
    List<TaxSlab> slabs = EateryDB.instance.taxSlabBox!.values.toList();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _pageColor,
        foregroundColor: Colors.white,
        
        title: const Text('Add Inventory Item'),
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
                  label: 'Name',
                  hint: 'Enter product name',
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
                  Container(
                    child: LabeledCustomTextFromField(
                        label: 'MRP',
                        prefix: const Icon(Icons.currency_rupee, size: 14,),
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
                        controller: _controllerMRP) 
                  ),
                  const SizedBox(width: 12.0,),
                  Flexible(
                    child: LabeledCustomTextFromField(
                        label: 'Sale Price',
                        prefix: const Icon(Icons.currency_rupee, size: 14,),
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
                  color: ColorStyle.text200,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
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
              const SizedBox(
                height: 6.0,
              ),


              Text(
                'Select Tax Slab',
                style: TextStyle(
                  color: ColorStyle.text200,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 3.0,
              ),
              ToggleSwitch(
                highlightColor: _pageColor,
                backgroundColor: const Color(0xFFE5E5E5),
                foregroundColor: Colors.white,
                inactiveForegroundColor: ColorStyle.text200,
                children: [
                  'None',
                  ...slabs.map((e) => e.name)
                ],
                selectedIndex: (selectedTaxSlab == null) ? 0 : slabs.indexOf(selectedTaxSlab!) + 1,
                onChange: (int? index) {
                  if (index == 0 || index == null) {
                    selectedTaxSlab = null;
                  } else {
                    selectedTaxSlab = slabs[index - 1];
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
              const SizedBox(
                height: 6.0,
              ),
              Text(
                'Select Category',
                style: TextStyle(
                  color: ColorStyle.text200,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
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
              LabeledCustomTextFromField(
                  label: 'Description',
                  hint: 'Enter product description',
                  multiline: true,
                  focusNode: focus4,
                  onFieldSubmitted: (v) {
                    FocusScope.of(context).unfocus();
                  },
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
              await EateryDB.instance.productBox!
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
