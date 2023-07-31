import 'package:eatery/references.dart';
import 'package:eatery/widgets/dialogs/showMessageDialog.dart';

Color _pageColor = ColorStyle.tertiary;

class EditDiningTablePage extends StatefulWidget {
  const EditDiningTablePage({Key? key, required this.diningTable})
      : super(key: key);
  final DiningTable diningTable;
  @override
  State<EditDiningTablePage> createState() => _EditDiningTablePageState();
}

class _EditDiningTablePageState extends State<EditDiningTablePage> {
  DiningTableCategory? diningTableCategory;
  final TextEditingController _controllerCategoryName = TextEditingController();
  final TextEditingController _controllerCategoryDescription =
      TextEditingController();
  LibraryImage? image;
  final List<FocusNode> _focusNodes = [
    FocusNode(),
    FocusNode(),
  ];

  bool isActive = true;

  final _formKey = GlobalKey<FormState>();

  @override
  initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        diningTableCategory = EateryDB.instance.diningTableCategoryBox!.values
                .where((elem) => elem.id == widget.diningTable.categoryId)
                .isNotEmpty
            ? EateryDB.instance.diningTableCategoryBox!.values
                .where((elem) => elem.id == widget.diningTable.categoryId)
                .first
            : null;
        _controllerCategoryName.text = widget.diningTable.name;
        _controllerCategoryDescription.text =
            widget.diningTable.description ?? '';
        image = widget.diningTable.image != null
            ? LibraryImage(widget.diningTable.image)
            : null;
        isActive = widget.diningTable.isActive;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _pageColor,
        foregroundColor: Colors.white,
        title: const Text('Edit Dining Table'),
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter dining table name';
                    }
                    return null;
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
                    ],
                  ),
                ),
                const SizedBox(
                  height: 12.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(
                        value: isActive,
                        activeColor: _pageColor,
                        onChanged: (value) {
                          setState(() {
                            isActive = value ?? false;
                          });
                        }),
                    const SizedBox(
                      width: 6.0,
                    ),
                    Text(
                      'Active',
                      style: TextStyle(
                        color: ColorStyle.text200,
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: ColorStyle.backgroundColorAlter,
        child: PrimaryButton(
          color: _pageColor,
          onPressed: () async {
            if (!_formKey.currentState!.validate()) {
              return;
            }

            DiningTable diningTable = EateryDB.instance.diningTableBox!.values.where((element) => element.id == widget.diningTable.id).first;

            diningTable.name = _controllerCategoryName.text;
            diningTable.description = _controllerCategoryDescription.text;
            diningTable.image = image?.filename;
            diningTable.categoryId = diningTableCategory?.id;
            diningTable.isActive = isActive;

            await EateryDB.instance.diningTableBox!
                .put(diningTable.key, diningTable)
                .then((value) {
                  showMessageDialog(context, 'Successfully updated', MessageType.success).then((value) => Navigator.of(this.context).pop());
            }).onError((error, stackTrace) {
              showMessageDialog(context, 'Failed to update', MessageType.error);
            });
          },
          child: const Text('Update'),
        ),
      ),
    );
  }
}
