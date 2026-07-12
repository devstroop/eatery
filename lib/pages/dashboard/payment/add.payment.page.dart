import 'package:eatery/core/theme/app_typography.dart';
import 'package:eatery/presentation/providers/order_provider.dart';
import 'package:eatery/presentation/providers/company_provider.dart';
import 'package:eatery/references.dart';
import 'package:eatery/core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Color _pageColor = AppColors.menuCategories;

class AddPaymentPage extends ConsumerStatefulWidget {
  const AddPaymentPage({Key? key, this.order}) : super(key: key);
  final Order? order;

  @override
  ConsumerState<AddPaymentPage> createState() => _AddPaymentPageState();
}

class _AddPaymentPageState extends ConsumerState<AddPaymentPage> {
  Order? order;
  final TextEditingController _controllerAmount = TextEditingController();
  final TextEditingController _controllerReference = TextEditingController();

  LibraryImage? image;
  PaymentMode paymentMode = PaymentMode.cash;
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
        order = widget.order;
        _controllerAmount.text = (order?.grandTotal ?? '').toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
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
                ListTile(
                    title: Text(
                      '${order?.id ?? 'Select Order'}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: widget.order != null
                        ? Text(
                            widget.order!.type.name!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : null,
                    trailing: Text(
                      (widget.order?.grandTotal ?? '').toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () async {
                      showSearch(
                          context: context,
                          delegate: SearchOrderDelegate(
                            orders: ref.read(orderRepositoryProvider).getAllOrders(),
                            callback: (order) {
                              setState(() {
                                this.order = order;
                                _controllerAmount.text =
                                    order.grandTotal.toString();
                              });
                            },
                            currencySymbol: '',
                          ));
                    }),
                // Payment mode
                ListTile(
                  title: const Text('Payment Mode'),
                  subtitle: Text(paymentMode.name),
                  trailing: const Icon(Icons.arrow_drop_down),
                  onTap: () async {
                    final mode = await showModalBottomSheet<PaymentMode>(
                      context: context,
                      builder: (context) => ListView(
                        shrinkWrap: true,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            child: const Text(
                              'Select Payment Mode',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          ...PaymentMode.values
                              .map((e) => ListTile(
                                    leading: Visibility(
                                      visible: paymentMode == e,
                                      child: const Icon(Icons.check_circle,
                                          color: Colors.green),
                                    ),
                                    title: Text(e.name),
                                    onTap: () {
                                      Navigator.pop(context, e);
                                    },
                                  ))
                              .toList(),
                        ],
                      ),
                    );
                    if (mode != null) {
                      setState(() {
                        paymentMode = mode;
                      });
                    }
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _controllerAmount,
                  focusNode: _focusNodes[1],
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                    signed: false,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    hintText: 'Enter Payment Amount',
                    prefix: Text('${ref.read(companyProvider.notifier).currency?.symbol ?? ''}  '),
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter payment amount';
                    }
                    return null;
                  },
                ),
                // Upload screenshot image
                const SizedBox(height: 20),
                // Reference number
                TextFormField(
                  controller: _controllerReference,
                  focusNode: _focusNodes[0],
                  decoration: const InputDecoration(
                    labelText: 'Reference Number',
                    hintText: 'Enter Reference Number',
                    prefix: Text('#  '),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter reference number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                UploadButton(
                  label: 'Payment Screenshot',
                  primaryColor: _pageColor,
                  secondaryColor: AppColors.black600,
                  libraryImage: image,
                  onChanged: (value) {
                    setState(() {
                      image = value;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: PrimaryButton(
          color: _pageColor,
          child: const Text('Save Payment'),
          onPressed: () {
            if (order == null)
              return showMessageDialog(
                  context, 'Please select an order', MessageType.error);

            if (_formKey.currentState!.validate()) {
              final payment = Payment(
                amount: double.parse(_controllerAmount.text),
                reference: _controllerReference.text,
                mode: paymentMode,
                attachment: image?.filename,
                orderId: order?.id,
              );
              ref.read(paymentRepositoryProvider).savePayment(payment)
                  .then((value) => showMessageDialog(
                          context,
                          'Payment saved successfully',
                          MessageType.success, () async {

                        var diningTable = ref.read(diningTableRepositoryProvider).getAllTables()
                            .where((element) =>
                        element.orderId == order?.id).firstOrNull;
                        if(diningTable != null){
                          diningTable.status = DiningTableStatus.available;
                          diningTable.orderId = null;
                          diningTable.customerPhone = null;
                          await ref.read(diningTableRepositoryProvider).saveTable(diningTable);
                        }

                        order?.paidTotal = (order?.paidTotal ?? 0) +
                            double.parse(_controllerAmount.text);
                        ref.read(orderRepositoryProvider).saveOrder(order!).then((value) => Navigator.pop(context));
                      }))
                  .onError((error, stackTrace) => showMessageDialog(
                      context, 'Error saving payment', MessageType.error));
            }
          },
        ),
      ),
    );
  }
}
