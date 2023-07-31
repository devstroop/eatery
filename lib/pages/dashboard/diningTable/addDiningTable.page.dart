import 'package:eatery/references.dart';

Color _pageColor = ColorStyle.tertiary;

class AddDiningTablePage extends StatefulWidget {
  const AddDiningTablePage({Key? key}) : super(key: key);

  @override
  State<AddDiningTablePage> createState() => _AddDiningTablePageState();
}

class _AddDiningTablePageState extends State<AddDiningTablePage> {
  DiningTable? diningTable;
  DiningTableCategory? diningTableCategory;
  final TextEditingController _controllerCategoryName = TextEditingController();
  final TextEditingController _controllerCategoryDescription =
      TextEditingController();
  LibraryImage? image;

  List<FocusNode> _focusNodes = [
    FocusNode(),
    FocusNode(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _pageColor,
        foregroundColor: Colors.white,
        
        title: const Text('Add Dining Table'),
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
      ),
      body: InkWell(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Padding(
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
                label: 'Dining Table Icon',
                image: image?.image,
                primaryColor: _pageColor,
              ),
              const SizedBox(
                height: 6.0,
              ),
              LabeledCustomTextFromField(
                label: 'Dining Table Name',
                controller: _controllerCategoryName,
                hint: 'eg. Table 1 ',
                obscureText: false,
                themeColor: _pageColor,
                foregroundColor: ColorStyle.text200,
                focusNode: _focusNodes[0],
                onFieldSubmitted: (v) {
                  _focusNodes[1].requestFocus();
                },
              ),
              const SizedBox(
                height: 12.0,
              ),
              LabeledCustomTextFromField(
                label: 'Description',
                controller: _controllerCategoryDescription,
                hint: 'eg. Table description',
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
                height: 12.0,
              ),
              Text(
                'Category',
                style: TextStyle(
                  color: ColorStyle.text200,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                width: double.maxFinite,
                height: 60,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    PosCategoryWidget(
                        active: diningTableCategory == null,
                        label: 'None',
                        onTap: () {
                          setState(
                            () {
                              diningTableCategory = null;
                            },
                          );
                        }),
                    ...EateryDB.instance.diningTableCategoryBox!.values.map((e) {
                      return PosCategoryWidget(
                        active: diningTableCategory?.id == e.id,
                        label: e.name,
                        onTap: () {
                          setState(() {
                            diningTableCategory = e;
                          });
                        },
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: PrimaryButton(
          color: _pageColor,
          onPressed: () async {
            if (_controllerCategoryName.text.trim() == '') {
              showSnackBar(context, '* Dining table name required');
              return;
            }
            setState(() {
              diningTable = DiningTable(
                image: image?.filename,
                name: _controllerCategoryName.text,
                description: _controllerCategoryDescription.text,
                categoryId: diningTableCategory?.id,
                isActive: true,
              );
            });
            if (diningTable == null) {
              showSnackBar(context, 'Failed to create');
              return;
            }
            EateryDB.instance.diningTableBox!.add(diningTable!).then((value) {
              showSnackBar(context, 'Successfully created');
              Navigator.pop(context);
            }).onError((error, stackTrace) {
              showSnackBar(context, 'Failed to create');
            });
          },
          child: const Text('Save'),
        ),
      ),
    );
  }
}
