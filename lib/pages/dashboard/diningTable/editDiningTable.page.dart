import 'package:eatery/references.dart';

Color _pageColor = ColorStyle.tertiary;

class EditDiningTablePage extends StatefulWidget {
  const EditDiningTablePage({Key? key, required this.diningTable}) : super(key: key);
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

  @override
  initState() {
    super.initState();
    Future.delayed(Duration.zero, (){
      setState(() {
        diningTableCategory = EateryDB.instance.diningTableCategoryBox.values.where((elem) => elem.id == widget.diningTable.categoryId).isNotEmpty ? EateryDB.instance.diningTableCategoryBox.values.where((elem) => elem.id == widget.diningTable.categoryId).first : null;
        _controllerCategoryName.text = widget.diningTable.name ?? '';
        _controllerCategoryDescription.text = widget.diningTable.description ?? '';
        image = widget.diningTable.image != null ? LibraryImage(widget.diningTable.image) : null;
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
          IconButton(
            onPressed: () {
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
                            Navigator.pop(context);
                            widget.diningTable.delete()
                                .whenComplete(() {
                              showSnackBar(context, 'Deleted successfully');
                              Navigator.pop(context);
                            });
                          },
                          child: const Text('OK'))
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.delete),
          )
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
                    ...EateryDB.instance.diningTableCategoryBox.values.map((e) {
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
        color: ColorStyle.backgroundColorAlter,
        child: PrimaryButton(
          color: _pageColor,
          onPressed: () async {
            if (_controllerCategoryName.text.trim() == '') {
              showSnackBar(context, '* Dining table name required');
              return;
            }
            if (diningTableCategory == null) {
              showSnackBar(context, '* Select category');
              return;
            }
            widget.diningTable.name = _controllerCategoryName.text;
            widget.diningTable.categoryId = diningTableCategory!.id;
            widget.diningTable.description = _controllerCategoryDescription.text;
            widget.diningTable.image = image?.filename;
            EateryDB.instance.diningTableBox
                .put(widget.diningTable.id, widget.diningTable)
                .whenComplete(() {
              showSnackBar(context, 'Successfully updated');
              Navigator.of(context).pop();
            }).onError((error, stackTrace) {
              showSnackBar(context, 'Something went wrong');
            });
          },
          child: const Text('Update'),
        ),
      ),
    );
  }
}
