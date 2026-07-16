import 'package:eatery_core/widgets/app_page_shell.dart';
import 'package:eatery_core/theme/app_typography.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eatery_core/providers/product_provider.dart';
import 'package:eatery_core/providers/order_provider.dart';
import 'package:eatery/references.dart';
import 'package:eatery_core/theme/app_colors.dart';
import 'package:eatery_core/widgets/app_dialog.dart';

Color _pageColor = AppColors.secondary;

class AddKitchenDish extends ConsumerStatefulWidget {
  const AddKitchenDish({super.key});

  @override
  ConsumerState<AddKitchenDish> createState() => _AddKitchenDishState();
}

class _AddKitchenDishState extends ConsumerState<AddKitchenDish> {
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
  ];

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      final slabs = ref.read(taxRepositoryProvider).getAllTaxSlabs();
      if (slabs.isNotEmpty) {
        setState(() {
          selectedTaxSlab = slabs.first;
        });
      }
    });
    _focusNodes[0].requestFocus();
  }

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final slabs = ref.read(taxRepositoryProvider).getAllTaxSlabs();

    return AppPageShell(
      title: 'Add Kitchen Dish',
      color: _pageColor,
      actions: [
        if (_focusNodes[0].hasFocus ||
            _focusNodes[1].hasFocus ||
            _focusNodes[2].hasFocus ||
            _focusNodes[3].hasFocus)
          IconButton(
            icon: const Icon(Icons.done),
            onPressed: () {
              FocusScope.of(context).unfocus();
            },
          ),
      ],
      bottomNavigationBar: BottomAppBar(
        color: AppColors.white,
        child: AppButton.primary(
          onPressed: () async {
            final isValid = _formKey.currentState!.validate();
            if (!isValid) {
              return;
            }
            _formKey.currentState!.save();

            Product product = Product(
              name: _controllerName.text,
              categoryId: selectedCategory?.id,
              description: _controllerDescription.text,
              image: image?.filename,
              mrpPrice: _controllerMRP.text.toDouble() ?? 0.0,
              salePrice: _controllerSalePrice.text.toDouble(),
              taxSlabId: selectedTaxSlab?.id,
              foodType: selectedFoodType,
              type: ProductType.kitchenDish,
              isActive: true,
            );
            await ref
                .read(productRepositoryProvider)
                .saveProduct(product)
                .then((value) {
                  AppDialog.showMessage(
                    this.context,
                    message: 'Product added successfully',
                    type: MessageType.success,
                  ).whenComplete(() => Navigator.pop(this.context));
                })
                .onError((error, stackTrace) {
                  AppDialog.showMessage(
                    this.context,
                    message: 'Failed to add product',
                    type: MessageType.error,
                  );
                });
          },
          label: 'Save',
        ),
      ),
      child: InkWell(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: _formKey,
            child: ListView(
              controller: _scrollController,
              children: [
                UploadButton(
                  label: 'Product Image',
                  primaryColor: _pageColor,
                  secondaryColor: AppColors.black600,
                  libraryImage: image,
                  onChanged: (image) {
                    setState(() {
                      this.image = image;
                    });
                  },
                ),
                const SizedBox(height: 6.0),
                LabeledCustomTextFormField(
                  label: 'Name',
                  hint: 'Enter product name',
                  focusNode: _focusNodes[0],
                  onFieldSubmitted: (v) {
                    FocusScope.of(context).requestFocus(_focusNodes[1]);
                  },
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return 'Name cannot be blank';
                    } else if (value!.length < 3) {
                      return 'Name must be at least 3 characters long';
                    } else if (value.trim().length > 50) {
                      return 'Name cannot be more than 50 characters long';
                    } else if (ref
                        .read(productRepositoryProvider)
                        .isProductNameTaken(value!.trim())) {
                      return 'Product with this name already exists';
                    }
                    return null;
                  },
                  foregroundColor: AppColors.black600,
                  themeColor: _pageColor,
                  controller: _controllerName,
                ),
                const SizedBox(height: 6.0),
                Row(
                  children: [
                    Flexible(
                      child: LabeledCustomTextFormField(
                        label: 'MRP (Max. retail price)',
                        prefix: const Icon(Icons.currency_rupee, size: 14),
                        hint: '0.00',
                        themeColor: _pageColor,
                        focusNode: _focusNodes[1],
                        onFieldSubmitted: (v) {
                          FocusScope.of(context).requestFocus(_focusNodes[2]);
                        },
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return 'Price cannot be blank';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        foregroundColor: AppColors.black600,
                        controller: _controllerMRP,
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    Flexible(
                      child: LabeledCustomTextFormField(
                        label: 'Sale Price',
                        prefix: const Icon(Icons.currency_rupee, size: 14),
                        hint: '0.00',
                        themeColor: _pageColor,
                        focusNode: _focusNodes[2],
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
                        foregroundColor: AppColors.black600,
                        controller: _controllerSalePrice,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6.0),
                Text(
                  'Select Food Type',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.white600,
                  ),
                ),
                const SizedBox(height: 3.0),
                ToggleSwitch(
                  highlightColor: selectedFoodType?.color ?? _pageColor,
                  backgroundColor: const Color(0xFFE5E5E5),
                  foregroundColor: AppColors.white,
                  inactiveForegroundColor: AppColors.black600,

                  children: ['None', ...FoodType.values.map((e) => e.name)],
                  selectedIndex: selectedFoodType != null
                      ? selectedFoodType!.index + 1
                      : 0,
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
                const SizedBox(height: 6.0),

                Text(
                  'Select Tax Slab',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.white600,
                  ),
                ),
                const SizedBox(height: 3.0),
                ToggleSwitch(
                  highlightColor: _pageColor,
                  backgroundColor: const Color(0xFFE5E5E5),
                  foregroundColor: AppColors.white,
                  inactiveForegroundColor: AppColors.black600,
                  children: ['None', ...slabs.map((e) => e.name)],
                  selectedIndex: (selectedTaxSlab == null)
                      ? 0
                      : slabs.indexOf(selectedTaxSlab!) + 1,
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
                      style: AppTypography.labelLarge.copyWith(
                        color: _pageColor,
                      ),
                    ),
                  ),
                const SizedBox(height: 6.0),
                Text(
                  'Select Category',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.white600,
                  ),
                ),
                const SizedBox(height: 3.0),
                SizedBox(
                  width: double.maxFinite,
                  height: 97,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      CircularCategoryPOSWidget(
                        themeColor: _pageColor,
                        margin: const EdgeInsets.symmetric(horizontal: 8.0),
                        image: const AssetImage('assets/images/default.jpg'),
                        label: 'None',
                        selected: selectedCategory == null,
                        onTap: () {
                          setState(() {
                            selectedCategory = null;
                          });
                        },
                      ),
                      ...ref
                          .read(productRepositoryProvider)
                          .getAllCategories()
                          .map((e) {
                            return CircularCategoryPOSWidget(
                              themeColor: _pageColor,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
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
                const SizedBox(height: 6.0),
                LabeledCustomTextFormField(
                  label: 'Description',
                  hint: 'Enter product description',
                  multiline: true,
                  focusNode: _focusNodes[3],
                  onFieldSubmitted: (v) {
                    FocusScope.of(context).unfocus();
                  },
                  foregroundColor: AppColors.black600,
                  themeColor: _pageColor,
                  controller: _controllerDescription,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
