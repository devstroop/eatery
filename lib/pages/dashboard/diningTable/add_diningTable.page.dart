import 'package:eatery/components/labeled_custom_text_from_field.dart';
import 'package:eatery_db/eatery_db.dart';
import 'package:flutter/material.dart';
import 'package:eatery/components/pos_category_widget.dart';
import 'package:eatery_components/buttons/primary.button.dart';
import 'package:eatery/services/utility/show_snack_bar.dart';
import 'package:eatery/constants/style/color_style.dart';

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
      title: const Text('Add Dining Table'),
    );
    return Scaffold(
      appBar: appBar,
      body: InkWell(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView(
            children: [
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
        child: PrimaryButton(
          color: _pageColor,
          onPressed: () async {
            if (_controllerCategoryName.text.trim() == '') {
              showSnackBar(context, '* Dining table name required');
              return;
            }
            setState(() {
              diningTable = DiningTable(
                name: _controllerCategoryName.text,
                description: _controllerCategoryDescription.text,
                categoryId: diningTableCategory?.id,
                id: EateryDB.instance.diningTableBox.nextId(),
                isActive: true,
              );
            });
            if (diningTable == null) {
              showSnackBar(context, 'Failed to create');
              return;
            }
            EateryDB.instance.diningTableBox.add(diningTable!).then((value) {
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
