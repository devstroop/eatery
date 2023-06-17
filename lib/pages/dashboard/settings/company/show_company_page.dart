import 'dart:io';

import 'package:eatery/components/bottomsheets/upload_image_bottomsheet.dart';
import 'package:eatery/components/loaders/loading_screen.dart';
import 'package:eatery_components/buttons/primary.button.dart';
import 'package:eatery/constants/style/color_style.dart';
import 'package:eatery/constants/style/spacing_style.dart';
import 'package:eatery_db/eatery_db.dart';
import 'package:eatery_db/models/company/company.dart';
import 'package:eatery_db/models/company/edition.dart';
import 'package:flutter/material.dart';

import 'edit_company_page.dart';

class ShowCompanyPage extends StatefulWidget {
  ShowCompanyPage({Key? key}) : super(key: key);

  @override
  State<ShowCompanyPage> createState() => _ShowCompanyPageState();
}

class _ShowCompanyPageState extends State<ShowCompanyPage> {
  Company? company;

  @override
  void initState() {
    super.initState();
    postInit();
    //WidgetsBinding.instance.addPostFrameCallback((_) => loadCompany());
  }

  void postInit() async {
    /*company = await CompanyLoader(widget.database).load(context);
    setState(() {});*/
  }
  void _changeLogo() => showModalBottomSheet(
      context: context,
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
          }));

  final themeColor = ColorStyle.brandColor;

  @override
  Widget build(BuildContext context) {
    return company != null
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: themeColor,
              title: const Text('Company Details'),
            ),
            body: Padding(
              padding: SpacingStyle.defaultPadding,
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                children: [
                  SpacingStyle.defaultVerticalSpacing,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: _changeLogo,
                        child: Container(
                          height: 96,
                          width: 96,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(48),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: company!.logo != null &&
                                      File(company!.logo!).existsSync()
                                  ? Image.file(
                                      File(company!.logo!),
                                    ).image
                                  : Image.asset('assets/images/default.jpg')
                                      .image,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  //
                  SpacingStyle.defaultVerticalSpacing,
                  ListTile(
                    leading: const Text('Company name'),
                    trailing: Text(
                      company!.name,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  ListTile(
                    leading: const Text('Address'),
                    trailing: Text(
                      company!.address,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  ListTile(
                    leading: const Text('Email'),
                    trailing: Text(
                      company!.email,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  ListTile(
                    leading: const Text('Phone'),
                    trailing: Text(
                      company!.phone,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  ListTile(
                    leading: const Text('Edition'),
                    trailing: Text(
                      Edition.values
                          .singleWhere(
                              (element) => element.id == company!.edition.id)
                          .name,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  ListTile(
                    leading: Text(
                        '${Edition.values.singleWhere((element) => element.id == company!.edition.id).name} License No'),
                    trailing: Text(
                      company!.salesTaxNumber ?? 'Not Available',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  ListTile(
                    leading: Text(
                        '${Edition.values.singleWhere((element) => element.id == company!.edition.id) == Edition.gst ? 'FSSAI' : 'Food'} License No'),
                    trailing: Text(
                      company!.foodLicenseNo ?? 'Not Available',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  ListTile(
                    leading: const Text('Default tax_slab rate'),
                    trailing: Text(
                      company!.defaultTaxSlabId != null
                          ? '${EateryDB().taxSlabBox().values.singleWhere((element) => element.id == company!.defaultTaxSlabId).rate.toString()}%'
                          : 'Not Available',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: BottomAppBar(
              color: ColorStyle.backgroundColorAlter,
              child: Padding(
                padding: SpacingStyle.defaultPadding,
                child: Row(
                  children: [
                    PrimaryButton(
                      color: themeColor,
                      child: const Text('Edit'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditCompanyPage()),
                        ).then((_) async {
                          postInit();
                          setState(() {});
                        });
                      },
                    )
                  ],
                ),
              ),
            ),
          )
        : LoadingScreen();
  }
}
