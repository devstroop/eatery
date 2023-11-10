import 'package:eatery/references.dart';
import 'package:flutter/material.dart';

Color themeColor = KColors.secondary2;

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Container(
            margin: const EdgeInsets.only(top: 12),
            child: Image.asset(
              'assets/logo.png',
              height: 48,
            ),
          ),
        ),
        /*body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(
            color: Colors.white70,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.35),
                spreadRadius: 0,
                blurRadius: 10,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
            border: Border.all(
              color: themeColor,
              width: 2,
              // color: Colors.grey[300]!,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              for(var each in EateryDB.instance.companyBox?.values.toList() ?? [])
                ListTile(
                  leading: CircleAvatar(
                    radius: 24,
                    backgroundImage: Common.company?.logo != null
                        ? LibraryImage(Common.company?.logo).image
                        : null,
                  ),
                  title: Text(each.name),
                  subtitle: Text(each.address),
                  onTap: () {
                  },
                ),
            ],
          ),
        ),
      )*/

        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Lottie.asset('assets/lottie/1699652006712.json'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'All-in-one',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    'restaurant POS System',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Manage your restaurant with ease',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    'with Eatery',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            children: [
              Flexible(
                flex: 1,
                child: PrimaryButton(
                  height: 50,
                  width: double.infinity,
                  color: KColors.tertiary3,
                  onPressed: () {},
                  child: const Text('Restore existing'),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Flexible(
                flex: 1,
                child: PrimaryButton(
                  width: double.infinity,
                  height: 50,
                  color: themeColor,
                  onPressed: () {},
                  child: const Text('Create new'),
                ),
              ),
            ],
          ),
        ));
  }
}
