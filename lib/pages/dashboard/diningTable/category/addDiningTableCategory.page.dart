import 'package:eatery/services/utility/library_image.dart';
import 'package:eatery/widgets/buttons/upload.button.dart';
import 'package:eatery_db/eatery_db.dart';
import 'package:flutter/material.dart';
import 'package:eatery_components/buttons/primary.button.dart';
import 'package:eatery/services/utility/show_snack_bar.dart';
import 'package:eatery/constants/style/color_style.dart';

import '../../../../components/labeled_custom_text_from_field.dart';

Color _pageColor = ColorStyle.tertiary;

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
  LibraryImage? image;
  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
        backgroundColor: _pageColor,
        foregroundColor: Colors.white,
        title: const Text('Add Dining Table Category'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(UIcons.regularStraight.arrow_left),
        ));
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
              primaryColor: _pageColor,
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
            int id = EateryDB.instance.diningTableCategoryBox.nextId();
            EateryDB.instance.diningTableCategoryBox
                .add(
              DiningTableCategory(
                  id: id,
                  name: _controllerCategoryName.text.trim(),
                  description: _controllerCategoryDescription.text.trim(),
                  image: image?.filename,
                  isActive: true),
            )
                .then((value) {
              Navigator.pop(context);
            });
          },
          child: const Text('Save'),
        ),
      ),
    );
  }
}
