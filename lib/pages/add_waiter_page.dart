import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:eatery/components/custom_text_from_field.dart';
import 'package:eatery/components/dialog_box.dart';
import 'package:eatery/components/primary_button.dart';
import 'package:eatery/components/upload_button.dart';
import 'package:eatery/database/waiter.dart';
import 'package:eatery/extensions/app_file_system.dart';
import 'package:eatery/services/utility/generate.dart';
import 'package:eatery/services/utility/show_snack_bar.dart';
import 'package:eatery/style/color_style.dart';
class AddWaiterPage extends StatefulWidget {
  const AddWaiterPage({Key? key}) : super(key: key);

  @override
  State<AddWaiterPage> createState() => _AddWaiterPageState();
}

class _AddWaiterPageState extends State<AddWaiterPage> {
  String? pickedImagePath;
  final TextEditingController _controllerWaiterName = TextEditingController();

  Color getThemeColor() {
    return ColorStyle.tertiary;
  }
  @override
  Widget build(BuildContext context) {

    final appBar = AppBar(
      backgroundColor: getThemeColor(),
      title: const Text('Add Waiter'),
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
              InkWell(
                child: UploadButton(
                  title: '+ Upload Picture',
                  subTitle: 'Waiter Image',
                  primaryColor: getThemeColor(),
                  secondaryColor: ColorStyle.text200,
                  pickedImagePath: pickedImagePath,
                  onCloseTap: () {
                    setState(() {
                      pickedImagePath = null;
                    });
                  },
                ),
                onTap: () async {
                  String? path = await AppFileSystem.pickImage();
                  setState(() {
                    pickedImagePath = path;
                  });
                },
              ),
              const SizedBox(
                height: 6.0,
              ),
              Column(mainAxisSize: MainAxisSize.max, crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  'Waiter Name',
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
                  controller: _controllerWaiterName,
                  labelText: 'Waiter Name',
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
        color: ColorStyle.background100,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: PrimaryButton(
            text: 'Save',
            backgroundColor: getThemeColor(),
            color: ColorStyle.background100,
            height: 50.0,
            onTap: () async {
              if(_controllerWaiterName.text.trim() == ''){
                showSnackBar(context, '* Waiter name required');
                return;
              }
              var response = await Waiter.add({'image': pickedImagePath, 'name': _controllerWaiterName.text});
              if(response != null){
                showSnackBar(context, 'Successfully created');
                Navigator.pop(context);
              }
              else{
                showSnackBar(context, 'Failed to create');
              }
            },
          ),
        ),
      ),
    );
  }
}
