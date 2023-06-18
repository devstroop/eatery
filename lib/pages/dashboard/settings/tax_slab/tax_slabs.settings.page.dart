import 'package:eatery/pages/dashboard/settings/tax_slab/add.tax_slab.settings.page.dart';
import 'package:eatery_db/eatery_db.dart';
import 'package:eatery_db/models/company/company.dart';
import 'package:eatery_db/models/tax/tax_slab.dart';
import 'package:flutter/material.dart';
import 'package:eatery/constants/style/color_style.dart';
import 'package:eatery_components/bottomsheets/tax_slab.bottomsheet.dart';
import 'edit.tax_slab.settings.page.dart';

class TaxSlabsSettingsPage extends StatefulWidget {
  const TaxSlabsSettingsPage({Key? key, required this.company})
      : super(key: key);
  final Company company;

  @override
  State<TaxSlabsSettingsPage> createState() => _TaxSlabsSettingsPageState();
}

class _TaxSlabsSettingsPageState extends State<TaxSlabsSettingsPage> {
  @override
  void initState() {
    super.initState();
  }

  Color getThemeColor() {
    return ColorStyle.primary;
  }

  _edit(TaxSlab taxSlab) => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditTaxSlabSettingsPage(
                company: widget.company, taxSlab: taxSlab)),
      ).then((_) {
        setState(() {});
        Navigator.of(context).pop();
      });

  _delete(TaxSlab taxSlab) async {
    await taxSlab.delete();
    setState(() {});
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      backgroundColor: getThemeColor(),
      title: const Text('Tax Slab Settings'),
    );
    return Scaffold(
      appBar: appBar,
      body: ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: [
          ListView(
            shrinkWrap: true,
            children: [
              for (TaxSlab taxSlab in EateryDB().taxSlabBox().values)
                TextButton(
                  onPressed: () => showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                          bottomLeft: Radius.circular(0),
                          bottomRight: Radius.circular(0),
                        ),
                      ),
                      builder: (context) {
                        return TaxSlabBottomsheet(
                          taxSlab: taxSlab,
                          onEdit: () => _edit(taxSlab),
                          onDelete: () => _delete(taxSlab),
                        );
                      }),
                  child: ListTile(
                    title: Text(
                      taxSlab.name,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    leading: CircleAvatar(
                        backgroundColor: getThemeColor(),
                        child: Text(
                          '${taxSlab.rate}%',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              color: ColorStyle.backgroundColorAlter),
                        )),
                    subtitle: Text(taxSlab.type.name),
                    trailing: const Icon(Icons.arrow_forward_ios),
                  ),
                ),
            ],
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  AddTaxSlabSettingsPage(company: widget.company)),
        ).then((_) => setState(() {})),
        backgroundColor: getThemeColor(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
