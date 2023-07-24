import 'package:eatery/references.dart';

final _pageColor = ColorStyle.primary;

class ShowCompanyPage extends StatefulWidget {
  const ShowCompanyPage({Key? key}) : super(key: key);

  @override
  State<ShowCompanyPage> createState() => _ShowCompanyPageState();
}

class _ShowCompanyPageState extends State<ShowCompanyPage> {
  Company? company;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, (){
      
    });
    postInit();
    //WidgetsBinding.instance.addPostFrameCallback((_) => loadCompany());
  }

  void postInit() async {
    company = EateryDB.instance.companyBox!.values.first;
    setState(() {});
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
          }));


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _pageColor,
        foregroundColor: Colors.white,
        title: const Text('Company Details'),
      ),
      body: ListView(
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
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: LibraryImage(company!.logo!).image,
                    ),
                  ),
                ),
              ),
            ],
          ),
          //
          SpacingStyle.defaultVerticalSpacing,
          ListTile(
            leading: const Text('Company name',
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),),
            trailing: Text(
              company!.name,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
          ),
          ListTile(
            leading: const Text('Address',
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),),
            trailing: Text(
              company!.address,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
          ),
          ListTile(
            leading: const Text('Email',
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),),
            trailing: Text(
              company!.email,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
          ),
          ListTile(
            leading: const Text('Phone',
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),),
            trailing: Text(
              company!.phone,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
          ),
          ListTile(
            leading: const Text('Edition',
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),),
            trailing: Text(
              Edition.values
                  .singleWhere(
                      (element) => element.id == company!.edition.id)
                  .name,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
          ),
          ListTile(
            leading: Text(
                '${Edition.values.singleWhere((element) => element.id == company!.edition.id).name} License No',
              style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16),),
            trailing: Text(
              (company?.salesTaxNumber != null && company?.salesTaxNumber?.trim() != "") ? company!.salesTaxNumber! : 'Not Available',
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
          ),
          ListTile(
            leading: Text(
                '${Edition.values.singleWhere((element) => element.id == company!.edition.id) == Edition.gst ? 'FSSAI' : 'Food'} License No',
              style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16),),
            trailing: Text(
              (company?.foodLicenseNo != null && company?.foodLicenseNo?.trim() != "") ? company!.foodLicenseNo! : 'Not Available',
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: ColorStyle.backgroundColorAlter,
        child: PrimaryButton(
          color: _pageColor,
          child: const Text('Edit'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const EditCompanyPage()),
            ).then((_) async {
              postInit();
              setState(() {});
            });
          },
        ),
      ),
    );
  }
}
