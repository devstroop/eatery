import 'package:eatery/references.dart';
import 'package:eatery/core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eatery/presentation/providers/order_provider.dart';

Color _pageColor = AppColors.primary;

class TaxSlabsSettingsPage extends ConsumerStatefulWidget {
  const TaxSlabsSettingsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<TaxSlabsSettingsPage> createState() =>
      _TaxSlabsSettingsPageState();
}

class _TaxSlabsSettingsPageState extends ConsumerState<TaxSlabsSettingsPage> {
  @override
  void initState() {
    super.initState();
  }

  /*_edit(TaxSlab taxSlab) =>
      Navigator.push(
        this.context,
        MaterialPageRoute(
            builder: (context) => EditTaxSlabSettingsPage(taxSlab: taxSlab)),
      ).then((_) {
        setState(() {});
        Navigator.of(this.context).pop();
      });

  _delete(TaxSlab taxSlab) async {
    await taxSlab.delete().whenComplete(() {
      setState(() {});
      Navigator.of(this.context).pop();
    });
  }
*/
  @override
  Widget build(BuildContext context) {
    List<TaxSlab> taxSlabs = ref.read(taxRepositoryProvider).getAllTaxSlabs();
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: _pageColor,
        foregroundColor: Colors.white,
        title: const Text('Tax Slab Settings'),
      ),
      body: taxSlabs.isNotEmpty
          ? ListView(
              children: [
                ...ref.read(taxRepositoryProvider).getAllTaxSlabs().map((e) {
                  return ListTile(
                    onTap: () {
                      Navigator.of(context)
                          .push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditTaxSlabSettingsPage(taxSlab: e),
                            ),
                          )
                          .then((_) => setState(() {}));
                    },
                    leading: Text(
                      '${e.rate}%',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: AppColors.black600,
                      ),
                    ),
                    title: Text(
                      e.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(e.type.name ?? 'None'),
                    trailing: const Icon(Icons.chevron_right),
                  );
                }),
              ],
            )
          : const Center(
              child: Opacity(
                opacity: 0.5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.percent, size: 64),
                    SpacingStyle.defaultVerticalSpacing,
                    Text(
                      'No Tax Slabs Found',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Add a tax slab to get started',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AddTaxSlabSettingsPage(),
          ),
        ).then((_) => setState(() {})),
        backgroundColor: _pageColor,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Tax Slab'),
      ),
    );
  }
}
