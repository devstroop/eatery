import 'package:eatery/references.dart';

Color _pageColor = ColorStyle.tertiary;

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
  LibraryImage? image;

  @override
  initState() {
    super.initState();
    setState(() {
      _controllerCategoryName.text = widget.category.name ?? '';
      _controllerCategoryDescription.text = widget.category.description ?? '';

      image = LibraryImage(widget.category.image);
    });
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      backgroundColor: _pageColor,
      foregroundColor: Colors.white,
      leading: IconButton(
        icon: Icon(UIcons.regularStraight.arrow_left),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: const Text('Edit Table Category'),
      actions: [
        IconButton(
          icon: Icon(
            UIcons.regularStraight.trash,
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                // category exists in dining table then show message and return
                if (EateryDB.instance.diningTableBox!.values
                    .any((element) => element.categoryId == widget.category.key)) {
                  return AlertDialog(
                    title: const Text('Delete Category'),
                    content: const Text(
                        'This category is currently in use. Please remove it from dining tables before deleting.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Ok'),
                      ),
                    ],
                  );
                }
                return AlertDialog(
                  title: const Text('Delete Category'),
                  content: const Text(
                      'Are you sure you want to delete this category?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        widget.category.delete().whenComplete(() {
                          Navigator.pop(context);
                          setState(() {});
                        });
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                );
              },
            );
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
            try {
              widget.category.name = _controllerCategoryName.text;
              widget.category.description =
                  _controllerCategoryDescription.text;
              widget.category.image = image?.filename ?? '';
              widget.category.save();
              showSnackBar(context, 'Successfully updated');
              Navigator.pop(context);
            } catch (e) {
              showSnackBar(context, 'Something went wrong');
            }
          },
          child: const Text('Update'),
        ),
      ),
    );
  }

  /*deleteButton(BuildContext context) => IconButton(
        onPressed: () {
          if (EateryDB.instance.diningTableBox.values
              .any((element) => element.categoryId == widget.category.key)) {
            return AlertDialog(
              title: const Text('Delete Category'),
              content: const Text(
                  'This category is currently in use. Please remove it from dining tables before deleting.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Ok'),
                ),
              ],
            );
          }
          if(EateryDB.instance.diningTableBox.values.where((element) => element.categoryId == widget.category.key).isNotEmpty){
            showSnackBar(context, 'Can\'t delete, some dining table is using this category');
            return;





          }
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return DialogBox(
                title: 'Delete',
                message: 'Are you sure?',
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel')),
                  TextButton(
                      onPressed: () async {

                        widget.category.delete().then((value) {
                          showSnackBar(context, 'Deleted successfully');
                          Navigator.pop(context);
                          Navigator.pop(context);
                        }).onError((error, stackTrace) {
                          showSnackBar(context, 'Can\'t delete');
                          Navigator.pop(context);
                        });
                      },
                      child: const Text('OK'))
                ],
              );
            },
          );
        },
        icon: Icon(UIcons.regularStraight.trash),
      );*/
}
