import 'package:eatery/references.dart';

Color _pageColor = const Color(0xFFC2592F);

class StaffsPage extends StatefulWidget {
  const StaffsPage({Key? key}) : super(key: key);

  @override
  State<StaffsPage> createState() => _StaffsPageState();
}

class _StaffsPageState extends State<StaffsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Staff> staffs = EateryDB.instance.staffBox!.values.toList();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _pageColor,
        title: const Text('Staffs'),
        foregroundColor: Colors.white,
        
      ),
      body: staffs.isNotEmpty
          ? ListView(
              children: [
                ...staffs.map((e) {
                  return ListTile(
                      title: Text(
                        e.name,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: e.phone != null ? Text(e.phone!) : null,
                      leading: LeadingImageWidget(
                        image: LibraryImage(e.photo ?? '').image,
                        size: 48,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit,
                                color: _pageColor),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        EditStaffPage(staff: e)),
                              ).then((_) => setState(() {}));
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete,
                                color: _pageColor),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Delete Staff'),
                                    content: const Text(
                                        'Are you sure you want to delete this Staff?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          e.delete()
                                              .whenComplete(() {
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
                      ));
                })
              ],
            )
          : const Center(
              child: Opacity(
              opacity: 0.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person,
                    size: 64,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No Staffs',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Add a staff to get started',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: _pageColor,
        foregroundColor: Colors.white,
        label: const Text('Add Staff'),
        icon: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddStaffPage()),
          ).then((_) => setState(() {}));
        },
      ),
    );
  }
}
