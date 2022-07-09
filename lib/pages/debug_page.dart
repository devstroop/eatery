import 'package:flutter/material.dart';
import 'package:eatery/components/primary_button.dart';
import 'package:eatery/database/account.dart';
import 'package:eatery/database/cart.dart';
import 'package:eatery/database/dining_table.dart';
import 'package:eatery/database/dining_table_category.dart';
import 'package:eatery/database/dish_customization.dart';
import 'package:eatery/database/order.dart';
import 'package:eatery/database/product.dart';
import 'package:eatery/database/product_category.dart';
import 'package:eatery/database/waiter.dart';
import 'package:eatery/services/utility/show_snack_bar.dart';
import 'package:eatery/style/color_style.dart';

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
