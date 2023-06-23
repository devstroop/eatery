import 'package:flutter/material.dart';
import 'package:eatery/components/custom_text_from_field.dart';
import 'package:eatery/constants/style/color_style.dart';

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
              /*UploadButton(
                label: 'Waiter Image',
                primaryColor: getThemeColor(),
                secondaryColor: ColorStyle.text200,
                uploadType: UploadType.image,
                path: pickedImagePath,
                onChanged: (pickedImagePath) {
                  setState(() {
                    this.pickedImagePath = pickedImagePath;
                  });
                },
              ),*/
              const SizedBox(
                height: 6.0,
              ),
              Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                      hint: 'Waiter Name',
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
            child:
                Container() /*PrimaryButton(
            child: const Text('Save'),
            color: getThemeColor(),
            onPressed: () async {
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
          ),*/
            ),
      ),
    );
  }
}
