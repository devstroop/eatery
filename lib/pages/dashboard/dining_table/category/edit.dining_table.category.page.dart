import 'package:eatery/references.dart';

Color _pageColor = KColors.tertiary;

class EditDiningTableCategoryPage extends StatefulWidget {
  const EditDiningTableCategoryPage({Key? key, required this.category})
      : super(key: key);
  final DiningTableCategory category;

  @override
  State<EditDiningTableCategoryPage> createState() =>
      _EditDiningTableCategoryPageState();
}

class _EditDiningTableCategoryPageState
    extends State<EditDiningTableCategoryPage> {
  final TextEditingController _controllerCategoryName = TextEditingController();
  final TextEditingController _controllerCategoryDescription =
      TextEditingController();

  final List<FocusNode> _focusNodes = [
    FocusNode(),
    FocusNode(),
  ];

  final _formKey = GlobalKey<FormState>();

  @override
  initState() {
    super.initState();
    setState(() {
      _controllerCategoryName.text = widget.category.name;
      _controllerCategoryDescription.text = widget.category.description ?? '';

    });
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      backgroundColor: _pageColor,
      foregroundColor: Colors.white,
      title: const Text('Edit Table Category'),
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter category name';
                    }
                    return null;
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
                    _focusNodes[1].unfocus();
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
            _formKey.currentState!.save();
            EateryDB.instance.diningTableCategoryBox!.values
                .where((element) => element.id == widget.category.id)
                .first
              ..name = _controllerCategoryName.text
              ..description = _controllerCategoryDescription.text
              ..save()
                  .then((value) => showMessageDialog(context,
                  'Updated successfully', MessageType.success)
                  .then((value) => Navigator.pop(this.context)))
                  .onError((error, stackTrace) => showMessageDialog(
                  context, 'Can\'t update', MessageType.error));
          },
          child: const Text('Update'),
        ),
      ),
    );
  }
}
