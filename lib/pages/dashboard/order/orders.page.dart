import 'package:eatery_core/theme/app_spacing.dart';
import 'package:eatery_core/theme/app_typography.dart';
import 'package:eatery_core/theme/app_colors.dart';
import 'package:eatery_core/providers/order_provider.dart';
import 'package:eatery_core/providers/company_provider.dart';
import 'package:eatery/references.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final Color _pageColor = AppColors.warning;

class OrdersPage extends ConsumerStatefulWidget {
  const OrdersPage({super.key});

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
    return AppOrderCard(
      order: order,
      context: OrderCardContext.admin,
      currencySymbol: currencySymbol,
      onTap: () => GoRouter.of(context).pushNamed('viewOrder', extra: order),
    );
  }
}
