import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_pos/components/upload_button.dart';

import 'package:restaurant_pos/pages/create_account_1_page.dart';
import 'package:restaurant_pos/pages/login_page.dart';
import 'package:restaurant_pos/pages/order_placed_page.dart';
import 'package:restaurant_pos/style/color_style.dart';

import 'database/account.dart';

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
      //home: accounts.isNotEmpty ? const LoginPage() : const CreateAccount1Page(),
      home: FutureBuilder<List<Map<String, dynamic>>>(
        future: Account.getAll(),
        builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot){
          if(!snapshot.hasData){
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
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

