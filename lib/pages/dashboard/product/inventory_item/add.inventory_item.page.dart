import 'package:eatery_core/theme/app_typography.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eatery_core/providers/product_provider.dart';
import 'package:eatery_core/providers/order_provider.dart';
import 'package:eatery/references.dart';
import 'package:eatery_core/theme/app_colors.dart';

Color _pageColor = AppColors.menuInventory;

class AddInventoryItem extends ConsumerStatefulWidget {
  const AddInventoryItem({super.key});

  @override
  ConsumerState<AddInventoryItem> createState() => _AddInventoryItemState();
}

class _AddInventoryItemState extends ConsumerState<AddInventoryItem> {
  LibraryImage? image;
  ProductCategory? selectedCategory;
  FoodType? selectedFoodType;
  TaxSlab? selectedTaxSlab;

  late final TextEditingController _controllerName = TextEditingController();
  late final TextEditingController _controllerMRP = TextEditingController();
  late final TextEditingController _controllerSalePrice =
      TextEditingController();
  late final TextEditingController _controllerDescription =
      TextEditingController();

  late final List<FocusNode> _focusNodes = List.generate(
    4,
    (index) => FocusNode(),
  );
  late final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      final slabs = ref.read(taxRepositoryProvider).getAllTaxSlabs();
      if (slabs.isNotEmpty) {
        setState(() {
          selectedTaxSlab = slabs.first;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppPageShell(
      title: 'Add Inventory Item',
      color: _pageColor,
      actions: [
        if (_focusNodes.any((node) => node.hasFocus))
          IconButton(
            icon: const Icon(Icons.done),
            onPressed: () {
              FocusScope.of(this.context).unfocus();
            },
          ),
      ],
      bottomAction: AppButton.primary(
        onPressed: () async {
          handleSaveButton();
        },
        label: 'Save',
      ),
      child: buildBody(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: _pageColor,
      foregroundColor: AppColors.white,
      title: const Text('Add Inventory Item'),
      actions: [
        if (_focusNodes.any((node) => node.hasFocus))
          IconButton(
            icon: const Icon(Icons.done),
            onPressed: () {
              FocusScope.of(context).unfocus();
            },
          ),
      ],
    );
  }

  Widget buildBody() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Form(
        key: _formKey,
        child: ListView(
          controller: _scrollController,
          children: [
            buildUploadButton(),
            const SizedBox(height: 6.0),
            buildNameTextField(),
            const SizedBox(height: 6.0),
            buildPriceFields(),
            const SizedBox(height: 6.0),
            buildFoodTypeSwitch(),
            const SizedBox(height: 6.0),
            buildTaxSlabSwitch(),
            if (selectedTaxSlab != null) buildTaxSlabInfo(),
            const SizedBox(height: 6.0),
            buildCategorySelection(),
            const SizedBox(height: 6.0),
            buildDescriptionTextField(),
          ],
        ),
      ),
    );
  }

  Widget buildUploadButton() {
    return UploadButton(
      label: 'Product Image',
      primaryColor: _pageColor,
      secondaryColor: AppColors.black600,
      libraryImage: image,
      onChanged: (image) {
        setState(() {
          this.image = image;
        });
      },
    );
  }

  Widget buildNameTextField() {
    return AppFormField(
      label: 'Name',
      hint: 'Enter product name',
      controller: _controllerName,
      focusNode: _focusNodes[0],
      focusNext: _focusNodes[1],
      validator: (value) {
        if (value?.trim().isEmpty ?? true) {
          return 'Name cannot be blank';
        } else if (value!.length < 3) {
          return 'Name must be at least 3 characters long';
        } else if (value.trim().length > 50) {
          return 'Name cannot be more than 50 characters long';
        } else if (ref
            .read(productRepositoryProvider)
            .isProductNameTaken(value.trim())) {
          return 'Product with this name already exists';
        }
        return null;
      },
    );
  }

  Widget buildPriceFields() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: AppFormField(
            label: 'MRP (Max. retail price)',
            prefix: const Icon(Icons.currency_rupee, size: 14),
            hint: '0.00',
            validator: (value) => validatePriceField(value),
            keyboardType: TextInputType.number,
            controller: _controllerMRP,
            focusNode: _focusNodes[1],
            focusNext: _focusNodes[2],
          ),
        ),
        const SizedBox(width: 12.0),
        Flexible(
          child: AppFormField(
            label: 'Sale Price',
            prefix: const Icon(Icons.currency_rupee, size: 14),
            hint: '0.00',
            focusNode: _focusNodes[2],
            validator: (value) => validatePriceField(value),
            keyboardType: TextInputType.number,
            controller: _controllerSalePrice,
            onFieldSubmitted: (v) {
              FocusScope.of(context).unfocus();
            },
          ),
        ),
      ],
    );
  }

  Widget buildFoodTypeSwitch() {
    return buildToggleSwitch(
      label: 'Select Food Type',
      items: ['None', ...FoodType.values.map((e) => e.name)],
      selectedIndex: selectedFoodType != null ? selectedFoodType!.index + 1 : 0,
      onChange: (index) {
        handleFoodTypeSwitch(index);
      },
    );
  }

  Widget buildTaxSlabSwitch() {
    final slabs = ref.read(taxRepositoryProvider).getAllTaxSlabs();
    return buildToggleSwitch(
      label: 'Select Tax Slab',
      items: ['None', ...slabs.map((e) => e.name)],
      selectedIndex: (selectedTaxSlab == null)
          ? 0
          : slabs.indexOf(selectedTaxSlab!) + 1,
      onChange: (index) {
        handleTaxSlabSwitch(index, slabs);
      },
    );
  }

  Widget buildTaxSlabInfo() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(
        '${selectedTaxSlab?.rate}% (${selectedTaxSlab?.type.name})',
        style: AppTypography.labelLarge.copyWith(color: _pageColor),
      ),
    );
  }

  Widget buildCategorySelection() {
    return SizedBox(
      width: double.maxFinite,
      height: 97,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          buildCircularCategoryWidget(
            image: const AssetImage('assets/images/default.jpg'),
            label: 'None',
            selected: selectedCategory == null,
            onTap: () {
              setState(() {
                selectedCategory = null;
              });
            },
          ),
          ...ref.read(productRepositoryProvider).getAllCategories().map((e) {
            return buildCircularCategoryWidget(
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
    );
  }

  Widget buildDescriptionTextField() {
    return AppFormField(
      label: 'Description',
      hint: 'Enter product description',
      multiline: true,
      focusNode: _focusNodes[3],
      onFieldSubmitted: (v) {
        FocusScope.of(context).unfocus();
      },
      controller: _controllerDescription,
    );
  }

  Widget buildCircularCategoryWidget({
    required ImageProvider<Object> image,
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return CircularCategoryPOSWidget(
      themeColor: _pageColor,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      image: image,
      label: label,
      selected: selected,
      onTap: onTap,
    );
  }

  Widget buildToggleSwitch({
    required String label,
    required List<String> items,
    required int selectedIndex,
    required Function(int?) onChange,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.labelMedium.copyWith(color: AppColors.black600),
        ),
        const SizedBox(height: 3.0),
        ToggleSwitch(
          highlightColor: selectedFoodType?.color ?? _pageColor,
          backgroundColor: const Color(0xFFE5E5E5),
          foregroundColor: AppColors.white,
          inactiveForegroundColor: AppColors.black600,
          children: items,
          selectedIndex: selectedIndex,
          onChange: onChange,
        ),
      ],
    );
  }

  String? validatePriceField(String? value) {
    if (value?.trim().isEmpty ?? true) {
      return 'Price cannot be blank';
    }
    return null;
  }

  void handleFoodTypeSwitch(int? index) {
    if (index == 0) {
      setState(() {
        selectedFoodType = null;
      });
    } else {
      setState(() {
        selectedFoodType = FoodType.values[index! - 1];
      });
    }
  }

  void handleTaxSlabSwitch(int? index, List<TaxSlab> slabs) {
    if (index == 0 || index == null) {
      selectedTaxSlab = null;
    } else {
      selectedTaxSlab = slabs[index - 1];
    }
    setState(() {});
  }

  void handleSaveButton() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();

    final repo = ref.read(productRepositoryProvider);

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
      isActive: true,
    );

    await repo
        .saveProduct(product)
        .then((value) {
          AppDialog.showMessage(
            context,
            message: 'Product created successfully',
            type: MessageType.success,
          ).whenComplete(() => Navigator.of(context).pop());
        })
        .onError((error, stackTrace) {
          AppDialog.showMessage(
            context,
            message: 'Error creating product',
            type: MessageType.error,
          );
        });
  }
}
