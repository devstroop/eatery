import 'package:flutter/material.dart';
import 'package:restaurant_pos/components/primary_button.dart';
import 'package:restaurant_pos/database/account.dart';
import 'package:restaurant_pos/database/cart.dart';
import 'package:restaurant_pos/database/dining_table.dart';
import 'package:restaurant_pos/database/dining_table_category.dart';
import 'package:restaurant_pos/database/dish_customization.dart';
import 'package:restaurant_pos/database/order.dart';
import 'package:restaurant_pos/database/product.dart';
import 'package:restaurant_pos/database/product_category.dart';
import 'package:restaurant_pos/database/waiter.dart';
import 'package:restaurant_pos/services/utility/show_snack_bar.dart';
import 'package:restaurant_pos/style/color_style.dart';

class DebugPage extends StatefulWidget {
  const DebugPage({Key? key, required this.account}) : super(key: key);
  final Map<String, dynamic> account;
  @override
  State<DebugPage> createState() => _DebugPageState();
}

class _DebugPageState extends State<DebugPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            Text(
                widget.account.toString()
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: PrimaryButton(
          color: ColorStyle.background100,
          text: 'Flush Database',
          backgroundColor: ColorStyle.primary,
          height: 50,
          onTap: (){
            Account.clear();
            Cart.cart.clear();
            DiningTable.clear();
            DiningTableCategory.clear();
            DishCustomization.clear();
            Order.clear();
            Product.clear();
            ProductCategory.clear();
            Waiter.clear();
            showSnackBar(context, 'Cleared');
          },

        ),
      ),
    );
  }
}
