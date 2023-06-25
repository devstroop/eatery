import 'package:eatery/constants/utils/utils.dart';
import 'package:eatery_db/eatery_db.dart';
import 'package:flutter/material.dart';
import 'package:eatery/constants/style/color_style.dart';
import '../../../components/labeled_custom_text_from_field.dart';
import '../../../services/utility/library_image.dart';
import '../../../widgets/buttons/primary.button.dart';
import '../../../widgets/buttons/upload.button.dart';

Color _pageColor = ColorStyle.primary;

class AddWaiterPage extends StatefulWidget {
  const AddWaiterPage({Key? key}) : super(key: key);

  @override
  State<AddWaiterPage> createState() => _AddWaiterPageState();
}

class _AddWaiterPageState extends State<AddWaiterPage> {
  LibraryImage? image;
  bool isActive = true;
  final TextEditingController _controllerWaiterName = TextEditingController();
  final TextEditingController _controllerWaiterPhone = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: _pageColor,
          foregroundColor: Colors.white,
          title: const Text('Add Waiter'),
          leading: IconButton(
            icon: Icon(UIcons.regularStraight.arrow_left),
            onPressed: () {
              Navigator.pop(context);
            },
          )),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              UploadButton(
                label: 'Waiter Photo',
                primaryColor: _pageColor,
                secondaryColor: ColorStyle.text200,
                image: image?.image,
                onChanged: (image) {
                  setState(() {
                    this.image = image;
                  });
                },
              ),
              const SizedBox(
                height: 6.0,
              ),
              LabeledCustomTextFromField(
                controller: _controllerWaiterName,
                label: 'Waiter Name',
                themeColor: _pageColor,
                foregroundColor: ColorStyle.text200,
                hint: 'Enter Waiter Name',
              ),
              const SizedBox(
                height: 6.0,
              ),
              LabeledCustomTextFromField(
                controller: _controllerWaiterPhone,
                label: 'Phone Number',
                themeColor: _pageColor,
                foregroundColor: ColorStyle.text200,
                keyboardType: TextInputType.phone,
                hint: 'Enter Phone Number',
              ),
              const SizedBox(
                height: 6.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Checkbox(
                      value: isActive,
                      onChanged: (value) {
                        setState(() {
                          isActive = value ?? false;
                        });
                      }),
                  const SizedBox(
                    width: 6.0,
                  ),
                  Text(
                    'Active',
                    style: TextStyle(
                      color: ColorStyle.text200,
                      fontSize: 16.0,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: ColorStyle.backgroundColorAlter,
        child: PrimaryButton(
          color: _pageColor,
          onPressed: () async {
            if (_controllerWaiterName.text.isEmpty) {
              showSnackBar(context, 'Waiter Name is required');
              return;
            }
            final isValid = _formKey.currentState!.validate();
            if (!isValid) {
              return;
            }
            _formKey.currentState!.save();

            try {
              EateryDB.instance.waiterBox.add(
                Waiter(
                  id: EateryDB.instance.waiterBox.nextId(),
                  name: _controllerWaiterName.text,
                  phone: _controllerWaiterPhone.text,
                  photo: image?.filename,
                  isActive: isActive
                ),
              ).whenComplete(() {
                showSnackBar(context, 'Waiter added successfully');
                Navigator.pop(context);
              });
            } catch (_) {
              showSnackBar(context, 'Failed to add waiter');
            }
          },
          child: const Text('Save'),
        ),
      ),
    );
  }
}
