import 'package:eatery_db/eatery_db.dart';
import 'package:flutter/material.dart';
import 'package:eatery/components/custom_text_from_field.dart';
import 'package:eatery/components/dialog_box.dart';
import 'package:eatery/components/pos_category_widget.dart';
import 'package:eatery_components/buttons/primary.button.dart';
import 'package:eatery/services/utility/show_snack_bar.dart';
import 'package:eatery/constants/style/color_style.dart';

Color _pageColor = ColorStyle.tertiary;

class EditDiningTablePage extends StatefulWidget {
  const EditDiningTablePage({Key? key, required this.id}) : super(key: key);
  final int id;
  @override
  State<EditDiningTablePage> createState() => _EditDiningTablePageState();
}

class _EditDiningTablePageState extends State<EditDiningTablePage> {
  DiningTableCategory? diningTableCategory;
  final TextEditingController _controllerName = TextEditingController();
  DiningTable? diningTable;

  @override
  initState() {
    super.initState();
    Future.delayed(Duration.zero, (){
      setState(() {
        diningTable = EateryDB.instance.diningTableBox.get(widget.id);
        diningTableCategory =
            EateryDB.instance.diningTableCategoryBox.get(diningTable?.categoryId);
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
      body: ListView(
        children: [
          Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Category Name',
                  style: TextStyle(
                    color: ColorStyle.text200,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 3.0,
                ),
                CustomTextFromField(
                  controller: _controllerName,
                  hint: 'eg. Table 1 ',
                  obscureText: false,
                  themeColor: _pageColor,
                ),
              ]),
          const SizedBox(
            height: 6.0,
          ),
          Container(
            width: double.maxFinite,
            height: 60,
            margin: const EdgeInsets.symmetric(vertical: 16.0),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                PosCategoryWidget(
                    active: diningTableCategory == null,
                    image: Image.asset(
                      'assets/images/all.png',
                      width: 18,
                      height: 18,
                      fit: BoxFit.cover,
                    ),
                    label: 'All',
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
      bottomNavigationBar: BottomAppBar(
        color: ColorStyle.backgroundColorAlter,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: PrimaryButton(
            color: _pageColor,
            onPressed: () async {
              if (_controllerName.text.trim() == '') {
                showSnackBar(context, '* Dining table name required');
                return;
              }
              if (diningTableCategory == null) {
                showSnackBar(context, '* Select category');
                return;
              }
              if (diningTable != null) {
                diningTable!.name = _controllerName.text;
                diningTable!.categoryId = diningTableCategory!.id;
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
      ),
    );
  }
}
