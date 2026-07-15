import 'package:eatery_core/theme/app_spacing.dart';
import 'package:eatery_core/theme/app_typography.dart';
import 'package:eatery_core/theme/app_colors.dart';
import 'package:eatery_core/widgets/widgets.dart';
import 'dart:ui' as ui;
import 'package:eatery_core/providers/order_provider.dart';
import 'package:eatery_core/providers/company_provider.dart';
import 'package:intl/intl.dart';
import 'package:eatery/references.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final Color _pageColor = AppColors.warning;

class OrdersPage extends ConsumerStatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  ConsumerState<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends ConsumerState<OrdersPage> {
  final GlobalKey genKey = GlobalKey();
  final ScrollController _scrollCtrl = ScrollController();
  final List<Order> _orders = [];
  static const int _pageSize = 50;
  int _page = 0;
  bool _loading = false;
  bool _hasMore = true;
  DateTime? filterFrom;
  DateTime? filterTill;

  @override
  void initState() {
    super.initState();
    _loadNextPage();
    _scrollCtrl.addListener(() {
      if (_scrollCtrl.position.pixels >=
          _scrollCtrl.position.maxScrollExtent - 200) {
        _loadNextPage();
      }
    });
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadNextPage() async {
    if (_loading || !_hasMore) return;
    setState(() => _loading = true);
    final repo = ref.read(orderRepositoryProvider);
    final newOrders = repo.getOrdersPage(_pageSize, _page * _pageSize);
    setState(() {
      _orders.addAll(newOrders);
      _page++;
      _hasMore = newOrders.length >= _pageSize;
      _loading = false;
    });
  }

  Future<Uint8List> _capturePng() async {
    try {
      RenderRepaintBoundary boundary =
          genKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      var pngBytes = byteData!.buffer.asUint8List();
      var bs64 = base64Encode(pngBytes);
      debugPrint(bs64.length.toString());
      setState(() {});
      return pngBytes;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final orders = _orders;
    final currencySymbol =
        ref.read(companyProvider.notifier).currency?.symbol ?? '';
    return AppPageShell(
      title: 'Orders',
      color: _pageColor,
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () async {
            await showSearch(
              context: context,
              delegate: SearchOrderDelegate(
                orders: orders,
                callback: (order) {
                  GoRouter.of(context)
                      .pushNamed('viewOrder', extra: order)
                      .then((_) => setState(() {}));
                },
                currencySymbol: currencySymbol,
              ),
            );
          },
        ),
      ],
      child: orders.isNotEmpty
          ? ListView(
              controller: _scrollCtrl,
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                ...orders.map(
                  (order) =>
                      _OrderCard(order: order, currencySymbol: currencySymbol),
                ),
                if (_loading)
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                if (!_hasMore && orders.isNotEmpty)
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: Text('No more orders')),
                  ),
              ],
            )
          : Center(
              child: Opacity(
                opacity: 0.5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.receipt_long, size: 64),
                    AppSpacing.gapLg,
                    Text(
                      'No orders received yet',
                      style: AppTypography.headlineSmall.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Create a new sale to get started',
                      style: AppTypography.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

/// Desktop-friendly order card.
class _OrderCard extends StatelessWidget {
  final Order order;
  final String currencySymbol;

  const _OrderCard({required this.order, required this.currencySymbol});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${currencySymbol}${order.finalTotal.toStringAsFixed(2)}',
              style: AppTypography.headlineSmall,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: Color(order.type.color!)),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                order.type.description!,
                style: AppTypography.labelLarge.copyWith(
                  color: Color(order.type.color!),
                ),
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Date: ${DateFormat.yMMMd().format(order.createdAt)}'),
            Text('Customer Phone: ${order.customerPhone ?? 'N/A'}'),
            Text('Total Quantity: ${order.totalQuantity}'),
            Text(
              'Sub Total: ${currencySymbol}${order.subTotal.toStringAsFixed(2)}',
            ),
            Text(
              'Discount: ${currencySymbol}${order.discountTotal.toStringAsFixed(2)}',
            ),
            Text('Tax: ${currencySymbol}${order.taxTotal.toStringAsFixed(2)}'),
            Text(
              'Round Off: ${currencySymbol}${order.roundOff.toStringAsFixed(2)}',
            ),
            Text(
              'Grand Total: ${currencySymbol}${order.grandTotal.toStringAsFixed(2)}',
            ),
            if (order.paidTotal != null)
              Text(
                'Paid Total: ${currencySymbol}${order.paidTotal!.toStringAsFixed(2)}',
              ),
          ],
        ),
        onTap: () {
          GoRouter.of(context).pushNamed('viewOrder', extra: order);
        },
      ),
    );
  }
}
