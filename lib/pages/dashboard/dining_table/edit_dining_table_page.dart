import 'dart:io';

import 'package:eatery/components/loaders/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:eatery/components/custom_text_from_field.dart';
import 'package:eatery/components/dialog_box.dart';
import 'package:eatery/components/pos_category_widget.dart';
import 'package:eatery_components/buttons/primary.button.dart';
import 'package:eatery/database/dining_table.dart';
import 'package:eatery/database/dining_table_category.dart';
import 'package:eatery/services/utility/show_snack_bar.dart';
import 'package:eatery/constants/style/color_style.dart';


class EditDiningTablePage extends StatefulWidget {
  const EditDiningTablePage({Key? key, required this.id}) : super(key: key);
  final String id;
  @override
  State<EditDiningTablePage> createState() => _EditDiningTablePageState();
}

class _EditDiningTablePageState extends State<EditDiningTablePage> {
  String? selectedDiningTableCategory;
  final TextEditingController _controllerName = TextEditingController();
  late Map<String, dynamic>? diningTable;


  @override
  initState() {
    super.initState();
    loadData();
  }
  loadData() async {
    var diningTable = await DiningTable.get(widget.id);
    if(diningTable != null){
      setState((){
        this.diningTable = diningTable;
        selectedDiningTableCategory = this.diningTable!['category'];
        _controllerName.text = this.diningTable!['name'];
      });
    }
  }


  Color getThemeColor() {
    return ColorStyle.tertiary;
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      backgroundColor: getThemeColor(),
      title: const Text('Edit Dining Table'),
      actions: [
        TextButton(
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
                          DiningTable.delete(widget.id);
                          showSnackBar(context, 'Deleted successfully');
                          Navigator.pop(context);
                        },
                        child: const Text('OK'))
                  ],
                );
              },
            );
          },
          child: Text('Delete', style: TextStyle(color: ColorStyle.backgroundColorAlter),),
        )
      ],
    );
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(
                height: 12.0,
              ),
              Column(mainAxisSize: MainAxisSize.max, crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                  themeColor: getThemeColor(),
                ),
              ]),
              const SizedBox(
                height: 6.0,
              ),
              SizedBox(
                width: double.maxFinite,
                height: 60,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        FutureBuilder(
                            future: DiningTableCategory.getAll(),
                            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                              if (snapshot.connectionState == ConnectionState.done) {
                                if (snapshot.hasData) {
                                  return Row(
                                    children: [
                                      for (var category in snapshot.data)
                                        PosCategoryWidget(
                                            active: selectedDiningTableCategory == category['id'],
                                            image: category['image'] != null && File(category['image']).existsSync()
                                                ? Image.file(File(category['image']))
                                                : null,
                                            label: category['name'],
                                            onTap: () {
                                              setState(
                                                () {
                                                  selectedDiningTableCategory = category['id'];
                                                },
                                              );
                                            })
                                    ],
                                  );
                                }
                                return Container();
                              } else {
                                return LoadingScreen();
                              }
                            }),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: ColorStyle.backgroundColorAlter,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: PrimaryButton(
            child: const Text('Update'),
            color: getThemeColor(),
            onPressed: () async {
              if (_controllerName.text.trim() == '') {
                showSnackBar(context, '* Dining table name required');
                return;
              }
              if (selectedDiningTableCategory == null) {
                showSnackBar(context, '* Select category');
                return;
              }
              var response = await DiningTable.update({
                'id': widget.id,
                'name': _controllerName.text,
                'category': selectedDiningTableCategory
              });
              if (response) {
                showSnackBar(context, 'Successfully updated');
                Navigator.of(context).pop();
              } else {
                showSnackBar(context, 'Failed to update');
              }
            },
          ),
        ),
      ),
    );
  }
}
