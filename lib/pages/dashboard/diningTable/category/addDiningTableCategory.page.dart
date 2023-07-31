import 'package:eatery/references.dart';

Color _pageColor = ColorStyle.tertiary;

class AddDiningTableCategoryPage extends StatefulWidget {
  const AddDiningTableCategoryPage({Key? key}) : super(key: key);

  @override
  State<AddDiningTableCategoryPage> createState() =>
      _AddDiningTableCategoryPageState();
}

class _AddDiningTableCategoryPageState
    extends State<AddDiningTableCategoryPage> {
  final TextEditingController _controllerCategoryName = TextEditingController();
  final TextEditingController _controllerCategoryDescription =
      TextEditingController();
  LibraryImage? image;
  final List<FocusNode> _focusNodes = [
    FocusNode(),
    FocusNode(),
  ];
  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      backgroundColor: _pageColor,
      foregroundColor: Colors.white,
      title: const Text('Add Dining Table Category'),
      actions: [
        if (_focusNodes[0].hasFocus || _focusNodes[1].hasFocus)
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
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            UploadButton(
              onChanged: (value) {
                setState(() {
                  image = value;
                });
              },
              title: '+ Upload Icon',
              label: 'Table Category Icon',
              image: image?.image,
              primaryColor: _pageColor,
            ),
            const SizedBox(
              height: 6.0,
            ),
            LabeledCustomTextFromField(
              keyboardType: TextInputType.text,
              controller: _controllerCategoryName,
              label: 'Category Name',
              hint: 'eg. Terrace',
              obscureText: false,
              themeColor: _pageColor,
              foregroundColor: ColorStyle.text200,
              focusNode: _focusNodes[0],
              onFieldSubmitted: (v) {
                _focusNodes[1].requestFocus();
              },
            ),
            const SizedBox(
              height: 6.0,
            ),
            LabeledCustomTextFromField(
              keyboardType: TextInputType.text,
              controller: _controllerCategoryDescription,
              label: 'Description',
              hint: 'eg. Terrace',
              obscureText: false,
              themeColor: _pageColor,
              foregroundColor: ColorStyle.text200,
              multiline: true,
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
      bottomNavigationBar: BottomAppBar(
        color: ColorStyle.backgroundColorAlter,
        child: PrimaryButton(
          color: _pageColor,
          onPressed: () async {
            if (_controllerCategoryName.text.trim() == '') {
              showSnackBar(context, '* Category name required');
              return;
            }
            EateryDB.instance.diningTableCategoryBox!
                .add(
              DiningTableCategory(
                  name: _controllerCategoryName.text.trim(),
                  description: _controllerCategoryDescription.text.trim(),
                  image: image?.filename,
                  isActive: true),
            )
                .then((value) {
              Navigator.pop(context);
            });
          },
          child: const Text('Save'),
        ),
      ),
    );
  }
}
