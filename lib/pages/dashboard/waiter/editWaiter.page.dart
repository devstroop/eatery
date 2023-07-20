import 'package:eatery/references.dart';

Color _pageColor = const Color(0xFFC2592F);

class EditWaiterPage extends StatefulWidget {
  const EditWaiterPage({Key? key, required this.waiter}) : super(key: key);
  final Waiter waiter;

  @override
  State<EditWaiterPage> createState() => _EditWaiterPageState();
}

class _EditWaiterPageState extends State<EditWaiterPage> {
  LibraryImage? image;
  bool isActive = true;
  final TextEditingController _controllerWaiterName = TextEditingController();
  final TextEditingController _controllerWaiterPhone = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  initState() {
    super.initState();
    Future.delayed(Duration.zero, (){
      setState(() {
        _controllerWaiterName.text = widget.waiter.name;
        _controllerWaiterPhone.text = widget.waiter.phone ?? '';
        isActive = widget.waiter.isActive;
        image = LibraryImage(widget.waiter.photo ?? '');
        
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
      title: const Text('Edit Waiter'),
      actions: [
        IconButton(
          icon: Icon(UIcons.regularStraight.trash),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Delete Waiter'),
                  content: const Text(
                      'Are you sure you want to delete this waiter?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        widget.waiter.delete()
                            .whenComplete(() {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          setState(() {});
                        });
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ],
    );
    return Scaffold(
      appBar: appBar,
      body: InkWell(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Padding(
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

            widget.waiter.name = _controllerWaiterName.text;
            widget.waiter.phone = _controllerWaiterPhone.text;
            widget.waiter.photo = image?.filename;
            widget.waiter.isActive = isActive;
            try {
              EateryDB.instance.waiterBox.put(widget.waiter.key,
                widget.waiter,
              ).whenComplete(() {
                showSnackBar(context, 'Waiter updated successfully');
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
