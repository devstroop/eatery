import 'package:eatery/references.dart';

Color _pageColor = KColors.tertiary;

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
  final List<FocusNode> _focusNodes = [
    FocusNode(),
    FocusNode(),
  ];

  final _formKey = GlobalKey<FormState>();
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
                LabeledCustomTextFromField(
                  keyboardType: TextInputType.text,
                  controller: _controllerCategoryName,
                  label: 'Category Name',
                  hint: 'eg. Terrace',
                  obscureText: false,
                  themeColor: _pageColor,
                  foregroundColor: KColors.black600,
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
                  foregroundColor: KColors.black600,
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
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: KColors.white,
        child: PrimaryButton(
          color: _pageColor,
          onPressed: () async {
            if (!_formKey.currentState!.validate()) {
              return;
            }
            DiningTableCategory diningTableCategory = DiningTableCategory(
              name: _controllerCategoryName.text,
              description: _controllerCategoryDescription.text,
              isActive: true,
            );
            EateryDB.instance.diningTableCategoryBox!
                .add(
              diningTableCategory,
            )
                .then((value) {
              showMessageDialog(context, 'Dining table category added successfully', MessageType.success).then((value) => Navigator.pop(this.context, diningTableCategory));
            });
          },
          child: const Text('Save'),
        ),
      ),
    );
  }
}
