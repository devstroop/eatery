import 'package:eatery/components/loaders/loading_screen.dart';
import 'package:eatery/pages/dashboard/waiter/addWaiter.page.dart';
import 'package:eatery_db/eatery_db.dart';
import 'package:flutter/material.dart';
import 'package:eatery/components/waiter_card.dart';
import 'editWaiter.page.dart';
import 'package:eatery/constants/style/color_style.dart';

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

  Color getThemeColor() {
    return ColorStyle.tertiary;
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      backgroundColor: getThemeColor(),
      title: const Text('Waiters'),
    );

    final productsPanel = SizedBox(
      width: double.maxFinite,
      height: double.maxFinite,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: FutureBuilder(
            future: Future.delayed(Duration.zero), // a dummy future
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData && snapshot.data.isNotEmpty) {
                  return Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      for (var waiter in snapshot.data)
                        WaiterCard(
                          id: waiter['id'],
                          name: waiter['name'],
                          image: waiter['image'],
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      EditWaiterPage(id: waiter['id'])),
                            ).then((_) => setState(() {}));
                          },
                        )
                    ],
                  );
                }
                return SizedBox(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: (MediaQuery.of(context).size.width <
                                  MediaQuery.of(context).size.height
                              ? MediaQuery.of(context).size.width
                              : 0.0) *
                          0.5,
                    ),
                    child: Center(
                        child: Image.asset(
                      'assets/images/2748558.png',
                      width: (MediaQuery.of(context).size.width <
                                  MediaQuery.of(context).size.height
                              ? MediaQuery.of(context).size.width
                              : MediaQuery.of(context).size.height) *
                          0.5,
                    )),
                  ),
                );
              } else {
                return LoadingScreen();
              }
            }),
      ),
    );

    return Scaffold(
      appBar: appBar,
      body: Stack(
        children: [
          Positioned(
              top: 12.0,
              left: 0.0,
              right: 0.0,
              bottom: 72,
              child: productsPanel),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: getThemeColor(),
        child: const Icon(Icons.add),
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
