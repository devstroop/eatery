import 'package:eatery/components/labeled_custom_text_from_field.dart';
import 'package:eatery_components/buttons/upload.button.dart';
import 'package:eatery_db/eatery_db.dart';
import 'package:eatery_db/models/product/product_category.dart';
import 'package:flutter/material.dart';
import 'package:eatery/components/custom_text_from_field.dart';
import 'package:eatery_components/buttons/primary.button.dart';
import 'package:eatery/services/utility/show_snack_bar.dart';
import 'package:eatery/constants/style/color_style.dart';
import 'package:uicons/uicons.dart';

class AddProductCategoryPage extends StatefulWidget {
  const AddProductCategoryPage({Key? key}) : super(key: key);

  @override
  State<AddProductCategoryPage> createState() => _AddProductCategoryPageState();
}

class _AddProductCategoryPageState extends State<AddProductCategoryPage> {
  String? pickedImagePath;
  final TextEditingController _controllerCategoryName = TextEditingController();
  final TextEditingController _controllerCategoryDescription =
      TextEditingController();

  Color getThemeColor() {
    return ColorStyle.tertiary;
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      foregroundColor: Colors.white,
      backgroundColor: getThemeColor(),
      leading: IconButton(
        icon: Icon(UIcons.regularStraight.arrow_left),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: const Text('Add Product Category'),
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
              const SizedBox(
                height: 12.0,
              ),
              UploadButton(
                label: 'Product Category Image',
                primaryColor: getThemeColor(),
                secondaryColor: ColorStyle.text200,
                uploadType: UploadType.image,
                filePath: pickedImagePath,
                onChanged: (pickedImagePath) {
                  setState(() {
                    this.pickedImagePath = pickedImagePath;
                  });
                },
              ),
              const SizedBox(
                height: 6.0,
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
                      hint: 'eg. Starters',
                      obscureText: false,
                      themeColor: getThemeColor(),
                    ),
                  ]),
              const SizedBox(
                height: 6.0,
              ),
              LabeledCustomTextFromField(
                label: 'Description',
                foregroundColor: ColorStyle.text200,
                backgroundColor: getThemeColor(),
                controller: _controllerCategoryDescription,
                multiline: true,
                description: 'eg. Starters are the best',
              ),
              const SizedBox(
                height: 6.0,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: ColorStyle.backgroundColorAlter,
        child: PrimaryButton(
          color: getThemeColor(),
          onPressed: () async {
            if (_controllerCategoryName.text.trim() == '') {
              showSnackBar(context, '* Category name required');
              return;
            }
            try {
              EateryDB()
                  .productCategoryBox()
                  .add(ProductCategory(
                      id: EateryDB().getNewIdentity(
                          EateryDB().productCategoryBox().values),
                      name: _controllerCategoryName.text,
                      description: _controllerCategoryDescription.text,
                      image: pickedImagePath))
                  .then((response) {
                if (response == 1) {
                  showSnackBar(context, 'Created successfully');
                } else {
                  showSnackBar(context, 'Failed to create');
                }
              }).whenComplete(() {
                Navigator.pop(context);
              });
            } catch (_) {
              showSnackBar(context, 'Failed to create');
            }
          },
          child: const Text('Save'),
        ),
      ),
    );
  }
}
