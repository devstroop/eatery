import 'package:eatery/references.dart';

Color _pageColor = const Color(0xFFC2592F);

class WaitersPage extends StatefulWidget {
  const WaitersPage({Key? key}) : super(key: key);

  @override
  State<WaitersPage> createState() => _WaitersPageState();
}

class _WaitersPageState extends State<WaitersPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Waiter> waiters = EateryDB.instance.waiterBox.values.toList();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _pageColor,
        title: const Text('Waiters'),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(UIcons.regularStraight.arrow_left),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: waiters.isNotEmpty
          ? ListView(
              children: [
                ...waiters.map((e) {
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
                            icon: Icon(UIcons.regularStraight.pencil,
                                color: _pageColor),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        EditWaiterPage(waiter: e)),
                              ).then((_) => setState(() {}));
                            },
                          ),
                          IconButton(
                            icon: Icon(UIcons.regularStraight.trash,
                                color: _pageColor),
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
          : Center(
              child: Opacity(
              opacity: 0.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    UIcons.regularStraight.user,
                    size: 64,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No Waiters',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Add a waiter to get started',
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
        label: const Text('Add Waiter'),
        icon: Icon(UIcons.regularStraight.plus_small),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddWaiterPage()),
          ).then((_) => setState(() {}));
        },
      ),
    );
  }
}
