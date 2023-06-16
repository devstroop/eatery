//import 'package:eatery_components/buttons/upload.button.dart';
import 'package:flutter/material.dart';
import 'package:eatery/components/custom_text_from_field.dart';
import 'package:eatery/components/dialog_box.dart';
//import 'package:eatery_components/buttons/primary.button.dart';
import 'package:eatery/database/waiter.dart';
import 'package:eatery/services/utility/show_snack_bar.dart';
import 'package:eatery/constants/style/color_style.dart';

class EditWaiterPage extends StatefulWidget {
  const EditWaiterPage({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  State<EditWaiterPage> createState() => _EditWaiterPageState();
}

class _EditWaiterPageState extends State<EditWaiterPage> {
  String? pickedImagePath;
  final TextEditingController _controllerWaiterName = TextEditingController();
  late Map<String, dynamic>? waiter;


  @override
  initState() {
    super.initState();
    loadData();
  }
  loadData() async {
    var waiter = await Waiter.get(widget.id);
    if(waiter != null){
      setState((){
        this.waiter = waiter;
        pickedImagePath = this.waiter!['image'];
        _controllerWaiterName.text = this.waiter!['name'];
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
      title: const Text('Edit Waiter'),
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
                          Waiter.delete(widget.id);
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
          child: Container()/*PrimaryButton(
            child: const Text('Update'),
            color: getThemeColor(),
            onPressed: () async {
              if (_controllerWaiterName.text.trim() == '') {
                showSnackBar(context, '* Waiter name required');
                return;
              }
              var response = await Waiter.update({'id':widget.id, 'image': pickedImagePath, 'name': _controllerWaiterName.text});
              if (response) {
                showSnackBar(context, 'Successfully updated');
                Navigator.of(context).pop();
              } else {
                showSnackBar(context, 'Failed to update');
              }
            },
          ),*/
        ),
      ),
    );
  }
}
