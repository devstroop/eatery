import 'package:eatery_components/bottomsheets/tax_slab.bottomsheet.dart';
import 'package:eatery_db/eatery_db.dart';
import 'package:flutter/material.dart';
import 'package:eatery/constants/style/color_style.dart';
import './addTaxSlab.page.dart';
import 'editTaxSlab.page.dart';

class TaxSlabsSettingsPage extends StatefulWidget {
  const TaxSlabsSettingsPage({Key? key})
      : super(key: key);

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
            builder: (context) => EditTaxSlabSettingsPage(taxSlab: taxSlab)),
      ).then((_) {
        setState(() {});
        Navigator.of(context).pop();
      });

  _delete(TaxSlab taxSlab) async {
    await taxSlab.delete().whenComplete(() {
      setState(() {});
      Navigator.of(context).pop();
    });
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
              for (TaxSlab taxSlab in EateryDB.instance.taxSlabBox.values)
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
                    subtitle: Text(taxSlab.type.name ?? 'None'),
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
                  const AddTaxSlabSettingsPage()),
        ).then((_) => setState(() {})),
        backgroundColor: getThemeColor(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
