import 'package:eatery_db/eatery_db.dart';
import 'package:flutter/material.dart';
import 'package:eatery/components/custom_text_from_field.dart';
import 'package:eatery/components/dialog_box.dart';
import 'package:eatery_components/buttons/primary.button.dart';
import 'package:eatery/services/utility/show_snack_bar.dart';
import 'package:eatery/constants/style/color_style.dart';

Color _pageColor = ColorStyle.tertiary;

class EditDiningTableCategoryPage extends StatefulWidget {
  const EditDiningTableCategoryPage({Key? key, required this.id})
      : super(key: key);
  final int id;

  @override
  State<EditDiningTableCategoryPage> createState() =>
      _EditDiningTableCategoryPageState();
}

class _EditDiningTableCategoryPageState
    extends State<EditDiningTableCategoryPage> {
  final TextEditingController _controllerCategoryName = TextEditingController();
  final TextEditingController _controllerCategoryDescription =
      TextEditingController();
  DiningTableCategory? diningTableCategory;

  @override
  initState() {
    super.initState();
    setState(() {
      diningTableCategory =
          EateryDB.instance.diningTableCategoryBox.get(widget.id);
      _controllerCategoryName.text = diningTableCategory?.name ?? '';
      _controllerCategoryDescription.text =
          diningTableCategory?.description ?? '';
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
      title: const Text('Edit Dining Table Category'),
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
                          // DiningTable.getAll(category: widget.id).then((value) {
                          //   if (value.isNotEmpty) {
                          //     showSnackBar(context, 'Can\'t delete');
                          //     return;
                          //   }
                          // });
                          // DiningTableCategory.delete(widget.id).then((value) {
                          //   showSnackBar(context, 'Deleted successfully');
                          //   Navigator.pop(context);
                          // });
                        },
                        child: const Text('OK'))
                  ],
                );
              },
            );
          },
          child: Text(
            'Delete',
            style: TextStyle(color: ColorStyle.backgroundColorAlter),
          ),
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
              Column(
                  mainAxisSize: MainAxisSize.max,
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
                      controller: _controllerCategoryName,
                      hint: 'eg. Terrace',
                      obscureText: false,
                      themeColor: _pageColor,
                    ),
                  ]),
              const SizedBox(
                height: 6.0,
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
            color: _pageColor,
            onPressed: () async {
              if (_controllerCategoryName.text.trim() == '') {
                showSnackBar(context, '* Category name required');
                return;
              }
              // DiningTableCategory.update(
              //         {'id': widget.id, 'name': _controllerCategoryName.text})
              //     .then((response) {
              //   if (response) {
              //     showSnackBar(context, 'Successfully updated');
              //     Navigator.of(context).pop();
              //   } else {
              //     showSnackBar(context, 'Failed to update');
              //   }
              // });
            },
            child: const Text('Update'),
          ),
        ),
      ),
    );
  }
}
