import 'package:eatery/references.dart';

Color _pageColor = KColors.tertiary;

class AddProductCategoryPage extends StatefulWidget {
  const AddProductCategoryPage({Key? key}) : super(key: key);

  @override
  State<AddProductCategoryPage> createState() => _AddProductCategoryPageState();
}

class _AddProductCategoryPageState extends State<AddProductCategoryPage> {
  LibraryImage? pickedLibraryImage;
  final TextEditingController _controllerCategoryName = TextEditingController();
  final TextEditingController _controllerCategoryDescription =
      TextEditingController();
  List<FocusNode> _focusNodes = [
    FocusNode(),
    FocusNode(),
  ];

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      foregroundColor: Colors.white,
      backgroundColor: _pageColor,
      title: const Text('Add Product Category'),
      actions: [
        if (_focusNodes[0].hasFocus ||
            _focusNodes[1].hasFocus)
          IconButton(
            icon: const Icon(Icons.done),
            onPressed: () {
              FocusScope.of(context).unfocus();
            },
          ),
      ],
    );
    return Scaffold(
      appBar: appBar,
      body: InkWell(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView(
            children: [
              const SizedBox(
                height: 12.0,
              ),
              UploadButton(
                label: 'Product Category Image',
                primaryColor: _pageColor,
                secondaryColor: KColors.black600,
                image: pickedLibraryImage?.image,
                onChanged: (pickedImagePath) {
                  setState(() {
                    pickedLibraryImage = pickedImagePath;
                  });
                },
              ),
              const SizedBox(
                height: 6.0,
              ),
              LabeledCustomTextFormField(
                  label: 'Category Name',
                  hint:
                      'Enter product category name', // Write a hint for category name field
                  foregroundColor: KColors.black600,
                  themeColor: _pageColor,
                  controller: _controllerCategoryName,
                  focusNode: _focusNodes[0],
                  onFieldSubmitted: (v) {
                    _focusNodes[1].requestFocus();
                  }),
              const SizedBox(
                height: 6.0,
              ),
              LabeledCustomTextFormField(
                label: 'Description',
                foregroundColor: KColors.black600,
                themeColor: _pageColor,
                controller: _controllerCategoryDescription,
                multiline: true,
                hint: 'Enter product category description',
                focusNode: _focusNodes[1],
                onFieldSubmitted: (v) {
                  FocusScope.of(context).unfocus();
                },
              ),
              const SizedBox(
                height: 6.0,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: KColors.white,
        child: PrimaryButton(
          color: _pageColor,
          onPressed: () async {
            try {
              EateryDB.instance.productCategoryBox!
                  .add(ProductCategory(
                      name: _controllerCategoryName.text,
                      description: _controllerCategoryDescription.text,
                      image: pickedLibraryImage?.filename))
                  .then((response) {
                    showMessageDialog(context, 'Category created successfully', MessageType.success);
              }).whenComplete(() {
                Navigator.pop(context);
              });
            } catch (_) {
              showMessageDialog(context, 'Failed to create category', MessageType.error);
            }
          },
          child: const Text('Save'),
        ),
      ),
    );
  }
}
