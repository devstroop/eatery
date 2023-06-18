import 'package:flutter/material.dart';
import 'package:eatery/components/custom_text_from_field.dart';
import 'package:eatery_components/buttons/primary.button.dart';
import 'package:eatery/database/dining_table_category.dart';
import 'package:eatery/services/utility/show_snack_bar.dart';
import 'package:eatery/constants/style/color_style.dart';

class AddDiningTableCategoryPage extends StatefulWidget {
  const AddDiningTableCategoryPage({Key? key}) : super(key: key);

  @override
  State<AddDiningTableCategoryPage> createState() =>
      _AddDiningTableCategoryPageState();
}

class _AddDiningTableCategoryPageState
    extends State<AddDiningTableCategoryPage> {
  final TextEditingController _controllerCategoryName = TextEditingController();

  Color getThemeColor() {
    return ColorStyle.tertiary;
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      backgroundColor: getThemeColor(),
      title: const Text('Add Dining Table Category'),
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
                      keyboardType: TextInputType.text,
                      controller: _controllerCategoryName,
                      hint: 'eg. Terrace',
                      obscureText: false,
                      themeColor: getThemeColor(),
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
            color: getThemeColor(),
            onPressed: () async {
              if (_controllerCategoryName.text.trim() == '') {
                showSnackBar(context, '* Category name required');
                return;
              }
              var response = await DiningTableCategory.add(
                  {'name': _controllerCategoryName.text});
              if (response != null) {
                showSnackBar(context, 'Successfully created');
                Navigator.pop(context);
              } else {
                showSnackBar(context, 'Failed to create');
              }
            },
            child: const Text('Save'),
          ),
        ),
      ),
    );
  }
}
