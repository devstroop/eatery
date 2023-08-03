import 'package:eatery/references.dart';

Color _pageColor = KColors.tertiary;

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
  final TextEditingController _controllerCapacity = TextEditingController();

  final List<FocusNode> _focusNodes = [
    FocusNode(),
    FocusNode(),
  ];

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _pageColor,
        foregroundColor: Colors.white,
        title: const Text('Add Dining Table'),
        actions: [
          if (_focusNodes[0].hasFocus || _focusNodes[1].hasFocus)
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
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                LabeledCustomTextFormField(
                  label: 'Dining Table Name',
                  controller: _controllerCategoryName,
                  hint:
                      'eg. Table ${EateryDB.instance.diningTableBox!.length + 1}',
                  obscureText: false,
                  themeColor: _pageColor,
                  foregroundColor: KColors.black600,
                  focusNode: _focusNodes[0],
                  suffix: _controllerCategoryName.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              _controllerCategoryName.clear();
                            });
                          },
                        )
                      : IconButton(
                          icon: Icon(
                            Icons.auto_awesome,
                            size: 18.0,
                            color: KColors.black600,
                          ),
                          onPressed: () {
                            setState(() {
                              _controllerCategoryName.text =
                                  'Table ${EateryDB.instance.diningTableBox!.length + 1}';
                            });
                          },
                        ),
                  onFieldSubmitted: (v) {
                    _focusNodes[1].requestFocus();
                  },
                ),
                const SizedBox(
                  height: 12.0,
                ),
                LabeledCustomTextFormField(
                  label: 'Description',
                  controller: _controllerCategoryDescription,
                  hint: 'eg. Regular/ VIP/ Family/ etc.',
                  obscureText: false,
                  themeColor: _pageColor,
                  foregroundColor: KColors.black600,
                  multiline: true,
                  focusNode: _focusNodes[1],
                  onFieldSubmitted: (v) {
                    FocusScope.of(context).unfocus();
                  },
                ),
                const SizedBox(
                  height: 12.0,
                ),
                LabeledCustomTextFormField(
                  label: 'Capacity',
                  controller: _controllerCapacity,
                  hint: 'eg. 4/ 6/ 8/ 10/ etc.',
                  obscureText: false,
                  themeColor: _pageColor,
                  foregroundColor: KColors.black600,
                  keyboardType: TextInputType.number,
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
                    color: KColors.black600,
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
                      ...EateryDB.instance.diningTableCategoryBox!.values
                          .map((e) {
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
                      Container(
                        padding: const EdgeInsets.only(bottom: 6, right: 12),
                        child: InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 24.0, vertical: 24.0),
                                  child: const AddDiningTableCategoryPage()),
                            ).then((value) {
                              setState(() {});
                            });
                          },
                          child: Material(
                            color: Colors.transparent,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Container(
                              width: 54,
                              decoration: BoxDecoration(
                                color: KColors.green,
                                boxShadow: [
                                  BoxShadow(
                                    color: KColors.green.withOpacity(0.2),
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: KColors.green,
                                  width: 1,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.add,
                                color: KColors.white,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: PrimaryButton(
          color: _pageColor,
          onPressed: () async {
            if (!_formKey.currentState!.validate()) {
              return;
            }
            _formKey.currentState!.save();
            DiningTable diningTable = DiningTable(
              name: _controllerCategoryName.text,
              description: _controllerCategoryDescription.text,
              category: diningTableCategory,
              capacity: 0,
            );
            EateryDB.instance.diningTableBox!.add(diningTable).then((value) {
              showMessageDialog(context, 'Dining Table created successfully',
                  MessageType.success, () => Navigator.pop(context));
            }).onError((error, stackTrace) {
              debugPrint(error.toString());
              showMessageDialog(
                context,
                'Failed to create Dining Table',
                MessageType.error,
              );
            });
          },
          child: const Text('Save'),
        ),
      ),
    );
  }
}
