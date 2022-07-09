import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:eatery/components/upload_button.dart';
import 'package:eatery/components/waiter_card.dart';
import 'package:eatery/database/dining_table.dart';
import 'package:eatery/database/dining_table_category.dart';
import 'package:eatery/database/printer.dart';
import 'package:eatery/database/product.dart';
import 'package:eatery/database/product_category.dart';

import 'package:eatery/pages/createaccount/create_account_1_page.dart';
import 'package:eatery/pages/login_page.dart';
import 'package:eatery/pages/order_confirmation.dart';
import 'package:eatery/style/color_style.dart';

import 'database/account.dart';
import 'database/cart.dart';
import 'database/dish_customization.dart';
import 'database/order.dart';
import 'database/waiter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eatery',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<List<Map<String, dynamic>>>(
        future: Account.getAll(),
        builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot){
          if(!snapshot.hasData){
            /*Account.clear().then((value) => null);
            Printer.clear().then((value) => null);
            Waiter.clear().then((value) => null);*/

            return Scaffold(
              body: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Spacer(),
                  Center(
                    child: Image.asset("assets/logo.png", height: 150, width: 150,),
                  ),
                  const Spacer(),
                  /*const Center(
                    child: CircularProgressIndicator(),
                  ),
                  const Spacer(),*/
                ],
              ),
            );
          }
          else{
            return snapshot.data!.isNotEmpty ? const LoginPage() : const CreateAccount1Page();
            //return Test();
          }
        },
      ),
    );
  }
}

