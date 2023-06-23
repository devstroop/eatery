import 'package:eatery/services/utility/library_image.dart';
import 'package:eatery_db/eatery_db.dart';
import 'package:flutter/material.dart';
import 'package:eatery/components/dialog_box.dart';
import 'package:eatery/components/pos_category_widget.dart';
import 'package:eatery_components/buttons/primary.button.dart';
import 'package:eatery/services/utility/show_snack_bar.dart';
import 'package:eatery/constants/style/color_style.dart';

import '../../../components/labeled_custom_text_from_field.dart';
import '../../../widgets/buttons/upload.button.dart';

Color _pageColor = ColorStyle.tertiary;

class EditDiningTablePage extends StatefulWidget {
  const EditDiningTablePage({Key? key, required this.id}) : super(key: key);
  final int id;
  @override
  State<EditDiningTablePage> createState() => _EditDiningTablePageState();
}

class _EditDiningTablePageState extends State<EditDiningTablePage> {
  DiningTable? diningTable;
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
        diningTable = EateryDB.instance.diningTableBox.values.singleWhere((elem) => elem.id == widget.id);
        diningTableCategory = diningTable?.categoryId != null ? EateryDB.instance.diningTableCategoryBox.values.singleWhere((elem) => elem.id == diningTable?.categoryId) : null;
        _controllerCategoryName.text = diningTable?.name ?? '';
        _controllerCategoryDescription.text = diningTable?.description ?? '';
        image = diningTable?.image != null ? LibraryImage(diningTable?.image) : null;
      }); 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _pageColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(UIcons.regularStraight.arrow_left),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
                            EateryDB.instance.diningTableBox
                                .delete(widget.id)
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
            icon: Icon(UIcons.regularStraight.trash),
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
                backgroundColor: _pageColor,
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
                backgroundColor: _pageColor,
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
            if (diningTable != null) {
              diningTable!.name = _controllerCategoryName.text;
              diningTable!.categoryId = diningTableCategory!.id;
              diningTable!.description = _controllerCategoryDescription.text;
              diningTable!.image = image?.filename;
              EateryDB.instance.diningTableBox
                  .put(widget.id, diningTable!)
                  .whenComplete(() {
                showSnackBar(context, 'Successfully updated');
                Navigator.of(context).pop();
              }).onError((error, stackTrace) {
                showSnackBar(context, 'Something went wrong');
              });
            } else {
              showSnackBar(context, 'Something went wrong');
            }
          },
          child: const Text('Update'),
        ),
      ),
    );
  }
}
