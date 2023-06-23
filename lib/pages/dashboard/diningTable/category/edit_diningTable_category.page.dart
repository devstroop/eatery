import 'package:eatery_db/eatery_db.dart';
import 'package:flutter/material.dart';
import 'package:eatery/components/custom_text_from_field.dart';
import 'package:eatery/components/dialog_box.dart';
import 'package:eatery_components/buttons/primary.button.dart';
import 'package:eatery/services/utility/show_snack_bar.dart';
import 'package:eatery/constants/style/color_style.dart';

import '../../../../components/labeled_custom_text_from_field.dart';
import '../../../../services/utility/library_image.dart';
import '../../../../widgets/buttons/upload.button.dart';

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
  LibraryImage? image;
  DiningTableCategory? diningTableCategory;

  @override
  initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        diningTableCategory =
            EateryDB.instance.diningTableCategoryBox.get(widget.id);
        _controllerCategoryName.text = diningTableCategory?.name ?? '';
        _controllerCategoryDescription.text =
            diningTableCategory?.description ?? '';
        image = LibraryImage(diningTableCategory?.image ?? '');
      });
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
        deleteButton(context),
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
              backgroundColor: _pageColor,
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
              backgroundColor: _pageColor,
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
              diningTableCategory?.name = _controllerCategoryName.text;
              diningTableCategory?.description =
                  _controllerCategoryDescription.text;
              diningTableCategory?.image = image?.filename ?? '';
              diningTableCategory?.save();
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

  deleteButton(BuildContext context) => IconButton(
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
                        diningTableCategory?.delete().then((value) {
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
      );
}
