import 'package:eatery_core/widgets/app_page_shell.dart';
import 'package:eatery_core/theme/app_typography.dart';
import 'package:eatery_core/providers/order_provider.dart';
import 'package:eatery_core/providers/company_provider.dart';
import 'package:eatery/references.dart';
import 'package:eatery_core/theme/app_colors.dart';
import 'package:eatery_core/theme/app_spacing.dart';
import 'package:eatery_core/widgets/app_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Color _pageColor = AppColors.menuCategories;

class AddPaymentPage extends ConsumerStatefulWidget {
  const AddPaymentPage({super.key, this.order});
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
  final List<FocusNode> _focusNodes = [FocusNode(), FocusNode()];
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
    return AppPageShell(
      title: 'Add Payment',
      color: _pageColor,
      actions: [
        if (_focusNodes.any((element) => element.hasFocus))
          IconButton(
            icon: const Icon(Icons.done),
            onPressed: () {
              FocusScope.of(context).unfocus();
            },
          ),
      ],
      bottomNavigationBar: BottomAppBar(
        child: AppButton.primary(
          label: 'Save Payment',
          onPressed: () {
            if (order == null) {
              AppDialog.showMessage(
                context,
                message: 'Please select an order',
                type: MessageType.error,
              );
              return;
            }
            final o = order!;

            if (_formKey.currentState!.validate()) {
              final payment = Payment(
                amount: double.parse(_controllerAmount.text),
                reference: _controllerReference.text,
                mode: paymentMode,
                attachment: image?.filename,
                orderId: o.id,
                date: DateTime.now(),
              );
              ref
                  .read(paymentRepositoryProvider)
                  .savePayment(payment)
                  .then(
                    (value) => AppDialog.showMessage(
                      context,
                      message: 'Payment saved successfully',
                      type: MessageType.success,
                      onConfirm: () async {
                        var diningTable = ref
                            .read(diningTableRepositoryProvider)
                            .getAllTables()
                            .where((element) => element.orderId == order?.id)
                            .firstOrNull;
                        if (diningTable != null) {
                          await ref
                              .read(diningTableRepositoryProvider)
                              .saveTable(
                                diningTable.copyWith(
                                  status: DiningTableStatus.available,
                                  orderId: null,
                                  customerPhone: null,
                                ),
                              );
                        }

                        final newPaidTotal =
                            (o.paidTotal ?? 0) +
                            double.parse(_controllerAmount.text);
                        final isFullyPaid = newPaidTotal >= o.grandTotal;
                        var updatedOrder = o.copyWith(paidTotal: newPaidTotal);
                        if (isFullyPaid && o.status == OrderStatus.pending) {
                          final now = DateTime.now();
                          updatedOrder = updatedOrder.copyWith(
                            status: OrderStatus.completed,
                            updatedAt: now,
                          );
                          ref
                              .read(orderRepositoryProvider)
                              .recordStatusTransition(
                                OrderStatusHistory(
                                  orderId: o.id!,
                                  fromStatus: OrderStatus.pending.id,
                                  toStatus: OrderStatus.completed.id,
                                  changedAt: now,
                                ),
                              );
                        }
                        ref
                            .read(orderRepositoryProvider)
                            .saveOrder(updatedOrder)
                            .then((value) => Navigator.pop(context));
                      },
                    ),
                  )
                  .onError(
                    (error, stackTrace) => AppDialog.showMessage(
                      context,
                      message: 'Error saving payment',
                      type: MessageType.error,
                    ),
                  );
            }
          },
        ),
      ),
      child: InkWell(
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
                    style: AppTypography.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: widget.order != null
                      ? Text(
                          widget.order!.type.name!,
                          style: AppTypography.titleMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                  trailing: Text(
                    (widget.order?.grandTotal ?? '').toString(),
                    style: AppTypography.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () async {
                    showSearch(
                      context: context,
                      delegate: SearchOrderDelegate(
                        orders: ref
                            .read(orderRepositoryProvider)
                            .getAllOrders(),
                        callback: (order) {
                          setState(() {
                            this.order = order;
                            _controllerAmount.text = order.grandTotal
                                .toString();
                          });
                        },
                        currencySymbol: '',
                      ),
                    );
                  },
                ),
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
                              style: AppTypography.titleLarge,
                            ),
                          ),
                          ...PaymentMode.values
                              .map(
                                (e) => ListTile(
                                  leading: Visibility(
                                    visible: paymentMode == e,
                                    child: const Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                    ),
                                  ),
                                  title: Text(e.name),
                                  onTap: () {
                                    Navigator.pop(context, e);
                                  },
                                ),
                              )
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
                AppSpacing.gapXl,
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
                    prefix: Text(
                      '${ref.read(companyProvider.notifier).currency?.symbol ?? ''}  ',
                    ),
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
                AppSpacing.gapXl,
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
                AppSpacing.gapXl,
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
    );
  }
}
