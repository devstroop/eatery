import 'package:eatery_core/theme/app_typography.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eatery_core/providers/product_provider.dart';
import 'package:eatery_core/providers/order_provider.dart';
import 'package:eatery/references.dart';
import 'package:eatery_core/theme/app_colors.dart';

Color _pageColor = AppColors.menuInventory;

class EditInventoryItemPage extends ConsumerStatefulWidget {
  const EditInventoryItemPage({super.key, required this.product});
  final Product product;
  @override
  ConsumerState<EditInventoryItemPage> createState() =>
      _EditInventoryItemPageState();
}

class _EditInventoryItemPageState extends ConsumerState<EditInventoryItemPage> {
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
      setState(() {
        image = LibraryImage(widget.product.image);
        _controllerName.text = widget.product.name;
        _controllerMRP.text = widget.product.mrpPrice.toString();
        _controllerSalePrice.text = widget.product.salePrice != null
            ? widget.product.salePrice.toString()
            : '';
        selectedFoodType = widget.product.foodType;
        selectedTaxSlab = widget.product.taxSlabId != null
            ? ref
                  .read(taxRepositoryProvider)
                  .getTaxSlabById(widget.product.taxSlabId!)
            : null;
        selectedCategory = widget.product.categoryId != null
            ? ref
                  .read(productRepositoryProvider)
                  .getCategoryById(widget.product.categoryId!)
            : null;
        _controllerDescription.text = widget.product.description ?? '';
      });
    });
  }

  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    final slabs = ref.read(taxRepositoryProvider).getAllTaxSlabs();

    return AppPageShell(
      title: 'Edit Inventory Item',
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
      bottomAction: AppButton.primary(
        onPressed: () async {
          final isValid = _formKey.currentState!.validate();
          if (!isValid) {
            return;
          }
          _formKey.currentState!.save();

          final repo = ref.read(productRepositoryProvider);
          final updated = widget.product.copyWith(
            image: image?.filename,
            name: _controllerName.text,
            mrpPrice: _controllerMRP.text.toDouble() ?? 0,
            salePrice: _controllerSalePrice.text.toDouble(),
            foodType: selectedFoodType,
            taxSlabId: selectedTaxSlab?.id,
            categoryId: selectedCategory?.id,
            description: _controllerDescription.text,
          );
          await repo
              .saveProduct(updated)
              .then((value) {
                AppDialog.showMessage(
                  this.context,
                  message: 'Product updated successfully',
                  type: MessageType.success,
                ).whenComplete(() => Navigator.pop(this.context));
              })
              .onError((error, stackTrace) {
                AppDialog.showMessage(
                  this.context,
                  message: 'Failed to update product',
                  type: MessageType.error,
                );
              });
        },
        label: 'Save',
      ),
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
              AppFormField(
                label: 'Name',
                hint: 'Enter product name',
                focusNode: _focusNodes[0],
                focusNext: _focusNodes[1],
                validator: (value) {
                  if (value!.trim().isEmpty) {
                    return 'Name cannot be blank';
                  } else if (value.trim().length < 3) {
                    return 'Name must be at least 3 characters long';
                  } else if (value.trim().length > 50) {
                    return 'Name cannot be more than 50 characters long';
                  } else if (ref
                      .read(productRepositoryProvider)
                      .isProductNameTaken(
                        value.trim(),
                        excludeId: widget.product.id,
                      )) {
                    return 'Product with this name already exists';
                  }
                  return null;
                },
                controller: _controllerName,
              ),
              Row(
                children: [
                  Flexible(
                    child: AppFormField(
                      label: 'MRP (Max. retail price)',
                      prefix: const Icon(Icons.currency_rupee, size: 14),
                      hint: '0.00',
                      focusNode: _focusNodes[1],
                      focusNext: _focusNodes[2],
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          return 'Price cannot be blank';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      controller: _controllerMRP,
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Flexible(
                    child: AppFormField(
                      label: 'Sale Price',
                      prefix: const Icon(Icons.currency_rupee, size: 14),
                      hint: '0.00',
                      focusNode: _focusNodes[2],
                      focusNext: _focusNodes[3],
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          return 'Price cannot be blank';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      controller: _controllerSalePrice,
                    ),
                  ),
                ],
              ),

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
                foregroundColor: selectedTaxSlab == null
                    ? AppColors.white
                    : AppColors.black600,
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
                    style: AppTypography.labelLarge.copyWith(color: _pageColor),
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
              const SizedBox(height: 6.0),
              AppFormField(
                label: 'Description',
                hint: 'Enter product description',
                multiline: true,
                focusNode: _focusNodes[3],
                onFieldSubmitted: (v) {
                  FocusScope.of(context).unfocus();
                },
                controller: _controllerDescription,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
