import 'package:eatery/references.dart';

Color _pageColor = KColors.tertiary;

class AddPaymentPage extends StatefulWidget {
  const AddPaymentPage({Key? key, required this.order}) : super(key: key);
  final Order? order;
  @override
  State<AddPaymentPage> createState() => _AddPaymentPageState();
}

class _AddPaymentPageState extends State<AddPaymentPage> {
  Order? order;
  final TextEditingController _controllerAmount = TextEditingController();
  LibraryImage? image;
  PaymentMode? paymentMode;
  final List<FocusNode> _focusNodes = [
    FocusNode(),
    FocusNode(),
  ];
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        _controllerAmount.text = widget.order!.finalTotal.toString();
        paymentMode = PaymentMode.cash;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _pageColor,
        foregroundColor: Colors.white,
        title: const Text('Add Payment'),
        actions: [
          if (_focusNodes.any((element) => element.hasFocus))
            IconButton(
              icon: const Icon(Icons.done),
              onPressed: () {
                FocusScope.of(context).unfocus();
              },
            ),
        ],
      ),
      body: InkWell(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                // Order selection dropdown
                DropdownButtonFormField<Order>(
                  decoration: const InputDecoration(
                    labelText: 'Order',
                    hintText: 'Select Order',
                    border: OutlineInputBorder(),
                  ),
                  value: order,
                  onChanged: (Order? newValue) {
                    setState(() {
                      order = newValue;
                    });
                  },
                  items: <DropdownMenuItem<Order>>[
                    for (Order order in EateryDB.instance.orderBox!.values)
                      DropdownMenuItem<Order>(
                        value: order,
                        child: Text(order.id.toString()),
                      ),
                  ],
                  validator: (value) {
                    if (value == null) {
                      return 'Please select order';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _controllerAmount,
                  focusNode: _focusNodes[1],
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    hintText: 'Enter Payment Amount',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter payment amount';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<PaymentMode>(
                  decoration: const InputDecoration(
                    labelText: 'Payment Mode',
                    hintText: 'Select Payment Mode',
                    border: OutlineInputBorder(),
                  ),
                  value: paymentMode,
                  onChanged: (PaymentMode? newValue) {
                    setState(() {
                      paymentMode = newValue;
                    });
                  },
                  items: PaymentMode.values.map((PaymentMode paymentMode) {
                    return DropdownMenuItem<PaymentMode>(
                      value: paymentMode,
                      child: Text(paymentMode.toString().split('.').last),
                    );
                  }).toList(),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select payment mode';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
