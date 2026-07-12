import 'package:eatery/references.dart';
import 'package:eatery/core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eatery/presentation/providers/company_provider.dart';

final _pageColor = AppColors.primary;

class ShowCompanyPage extends ConsumerStatefulWidget {
  const ShowCompanyPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ShowCompanyPage> createState() => _ShowCompanyPageState();
}

class _ShowCompanyPageState extends ConsumerState<ShowCompanyPage> {
  @override
  void initState() {
    super.initState();
  }

  void _changeLogo() => showModalBottomSheet(
    context: this.context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(24),
        topRight: Radius.circular(24),
        bottomLeft: Radius.circular(0),
        bottomRight: Radius.circular(0),
      ),
    ),
    builder: (context) => UploadImageBottomSheet(context, (pickedImagePath) {
      /*company!.logo = pickedImagePath;
        widget.database.companyDao.updateEntity(company!);
        showSnackBar(context, 'Successfully updated');
        setState(() {});*/
    }),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: _pageColor,
        foregroundColor: Colors.white,
        title: const Text('Company'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              showMenu(
                context: context,
                position: const RelativeRect.fromLTRB(100, 100, 0, 100),
                items: [
                  const PopupMenuItem(value: 'edit', child: Text('Edit')),
                  const PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
              ).then((value) {
                if (value == 'edit') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditCompanyPage(),
                    ),
                  ).then((_) async {
                    setState(() {});
                  });
                } else if (value == 'delete') {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('⚠️ Dangerous Action'),
                      content: const Text(
                        'Are you sure you want to delete this company?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => _onDeleteCompanyPressed(context),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  );
                }
              });
            },
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          Company? company = ref.read(companyProvider);
          return ListView(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            children: [
              SpacingStyle.defaultVerticalSpacing,
              SpacingStyle.defaultVerticalSpacing,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: _changeLogo,
                    child: Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black.withOpacity(0.2),
                            blurRadius: 12,
                            offset: const Offset(0, 2),
                          ),
                        ],
                        image: company?.logo != null
                            ? DecorationImage(
                                fit: BoxFit.cover,
                                image: LibraryImage(company!.logo!).image,
                              )
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
              //
              SpacingStyle.defaultVerticalSpacing,
              Container(
                padding: const EdgeInsets.all(16.0),
                margin: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withOpacity(0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const Text(
                        'Company name',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                      trailing: Text(
                        company!.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    ListTile(
                      leading: const Text(
                        'Address',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                      trailing: Text(
                        company.address,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    ListTile(
                      leading: const Text(
                        'Email',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                      trailing: Text(
                        company.email,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    ListTile(
                      leading: const Text(
                        'Phone',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                      trailing: Text(
                        company.phone,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    ListTile(
                      leading: const Text(
                        'Taxation',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                      trailing: Text(
                        Taxation.values
                            .singleWhere(
                              (element) => element.id == company.taxation.id,
                            )
                            .name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Text(
                        '${Taxation.values.singleWhere((element) => element.id == company.taxation.id).name} License No',
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                      trailing: Text(
                        (company.salesTaxNumber != null &&
                                company.salesTaxNumber?.trim() != "")
                            ? company.salesTaxNumber!
                            : 'Not Available',
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Text(
                        '${Taxation.values.singleWhere((element) => element.id == company.taxation.id) == Taxation.gst ? 'FSSAI' : 'Food'} License No',
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                      trailing: Text(
                        (company.foodLicenseNo != null &&
                                company.foodLicenseNo?.trim() != "")
                            ? company.foodLicenseNo!
                            : 'Not Available',
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      // bottomNavigationBar: BottomAppBar(
      //   color: AppColors.white,
      //   child: PrimaryButton(
      //     color: _pageColor,
      //     child: const Text('Edit'),
      //     onPressed: () {
      //       Navigator.push(
      //         context,
      //         MaterialPageRoute(builder: (context) => const EditCompanyPage()),
      //       ).then((_) async {
      //         setState(() {});
      //       });
      //     },
      //   ),
      // ),
    );
  }

  _onDeleteCompanyPressed(BuildContext context) {
    final TextEditingController securePinController = TextEditingController();
    Navigator.pop(context);

    // Confirm Password
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Secure PIN'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Please enter your secure pin to continue'),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: securePinController,
              obscureText: true,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Secure PIN',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your pin';
                }
                return null;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);

              if (securePinController.text !=
                  ref.read(companyProvider)?.password) {
                showMessageDialog(
                  context,
                  'Invalid secure pin',
                  MessageType.error,
                );
                return;
              }

              /*EateryDB.instance.flush().then((value) {
                showMessageDialog(
                    context, 'Company deleted successfully', MessageType.success).then((value) => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const CreateCompanyPage()),
                        (route) => false));
              });*/
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
