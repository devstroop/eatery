import 'package:flutter/material.dart';
import 'package:restaurant_pos/components/primary_button.dart';
import 'package:restaurant_pos/services/printing/print_invoice.dart';
import 'package:restaurant_pos/style/color_style.dart';

class OrderConfirmation extends StatefulWidget {
  const OrderConfirmation({Key? key, required this.order, required this.account}) : super(key: key);
  final Map<String, dynamic> order;
  final Map<String, dynamic> account;

  @override
  State<OrderConfirmation> createState() => _OrderConfirmationState();
}

class _OrderConfirmationState extends State<OrderConfirmation> {
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyle.background200,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(12.0),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/success.gif',
                width: 120,
                height: 120,
                fit: BoxFit.contain,
              ),
              Text(
                'Hurray!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Order placed successfully',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
              Text(
                'Order Id: ${widget.order['id']}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 12,
              ),
              /*Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () async {
                        await PrintInvoice.printReceipt(order: widget.order, account: widget.account);
                      },
                      icon: const Icon(
                        Icons.print,
                        size: 48,
                      )),
                  SizedBox(
                    width: 24,
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.whatsapp,
                        size: 48,
                      )),
                ],
              )*/
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: ColorStyle.background100,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: PrimaryButton(
            text: 'Alright',
            backgroundColor: ColorStyle.primary,
            color: ColorStyle.background100,
            height: 50.0,
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }
}
