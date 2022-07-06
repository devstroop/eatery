import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_pos/components/upload_button.dart';
import 'package:restaurant_pos/components/waiter_card.dart';
import 'package:restaurant_pos/database/dining_table.dart';
import 'package:restaurant_pos/database/dining_table_category.dart';
import 'package:restaurant_pos/database/printer.dart';
import 'package:restaurant_pos/database/product.dart';
import 'package:restaurant_pos/database/product_category.dart';

import 'package:restaurant_pos/pages/create_account_1_page.dart';
import 'package:restaurant_pos/pages/login_page.dart';
import 'package:restaurant_pos/pages/order_confirmation.dart';
import 'package:restaurant_pos/style/color_style.dart';

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
      title: 'Restaurant POS',
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
              body: Center(
                child: Text("RestaurantPOS", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32.0, color: ColorStyle.primary))/*CircularProgressIndicator()*/,
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

