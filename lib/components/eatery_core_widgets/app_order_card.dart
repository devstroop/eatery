import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eatery_core/data/models/eatery_db.dart';
import 'package:eatery_core/theme/app_colors.dart';
import 'package:eatery_core/theme/app_spacing.dart';
import 'package:eatery_core/theme/app_typography.dart';

/// The role context in which [AppOrderCard] is rendered.
///
/// Each context selects a different layout, action set, and animation preset.
/// All contexts consume [AppColors.status*] tokens for status indicators.
enum OrderCardContext {
  /// Kitchen Display System — large card with product list, elapsed timer,
  /// and Start/Done action buttons. Status badge is prominent.
  kds,

  /// Waiter app — compact card with status color icon, item count, total.
  /// Tappable to navigate to order detail.
  waiter,

  /// Customer-facing display — animated grid card with Lottie burst
  /// (new orders) and pulse (preparing orders). No actions.
  display,

  /// Admin dashboard — full-detail list tile with edit/void/print access.
  admin,
}

/// A single widget that renders an order summary across all four roles.
///
/// Instead of four independent implementations (KDS _TicketCard, Waiter _OrderCard,
/// Display _OrderStatusCard, Admin _OrderCard), this molecule unifies layout,
/// status colors, typography, and spacing into one tokenized widget.
///
/// ```dart
/// AppOrderCard(
///   order: order,
///   context: OrderCardContext.kds,
///   currencySymbol: '\$',
///   onStart: () => repo.startOrder(order),
///   onComplete: () => repo.completeOrder(order),
/// )
/// ```
class AppOrderCard extends ConsumerStatefulWidget {
  final Order order;
  final OrderCardContext context;
  final String currencySymbol;
  final int? crossAxisCount;
  final VoidCallback? onTap;
  final VoidCallback? onStart;
  final VoidCallback? onComplete;
  final VoidCallback? onEdit;
  final VoidCallback? onVoid;
  final Widget? trailing;

  /// Optional leading widget shown in the Display context's status area.
  /// Used to pass Lottie animations for new-order fireworks.
  final Widget? displayLeading;

  const AppOrderCard({
    super.key,
    required this.order,
    required this.context,
    this.currencySymbol = '',
    this.crossAxisCount,
    this.onTap,
    this.onStart,
    this.onComplete,
    this.onEdit,
    this.onVoid,
    this.trailing,
    this.displayLeading,
  });

  @override
  ConsumerState<AppOrderCard> createState() => _AppOrderCardState();
}

class _AppOrderCardState extends ConsumerState<AppOrderCard>
    with SingleTickerProviderStateMixin {
  AnimationController? _pulseController;
  Animation<double>? _pulseAnimation;

  @override
  void initState() {
    super.initState();
    if (widget.context == OrderCardContext.display) {
      _pulseController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1500),
      )..repeat(reverse: true);
      _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
        CurvedAnimation(parent: _pulseController!, curve: Curves.easeInOut),
      );
    }
  }

  @override
  void dispose() {
    _pulseController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return switch (widget.context) {
      OrderCardContext.kds => _buildKdsCard(),
      OrderCardContext.waiter => _buildWaiterCard(),
      OrderCardContext.display => _buildDisplayCard(),
      OrderCardContext.admin => _buildAdminTile(),
    };
  }

  // ── KDS ──────────────────────────────────────────────────────────

  Widget _buildKdsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order #${widget.order.id}',
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _StatusBadge(status: widget.order.status),
              ],
            ),
            AppSpacing.gapSm,
            _buildElapsedTimer(),
            AppSpacing.gapSm,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${widget.currencySymbol}${widget.order.grandTotal.toStringAsFixed(2)}',
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                _buildActionButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildElapsedTimer() {
    final elapsed = DateTime.now().difference(widget.order.createdAt);
    final min = elapsed.inMinutes;
    final sec = elapsed.inSeconds % 60;
    return Text(
      '${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}',
      style: AppTypography.bodySmall.copyWith(
        color: AppColors.timelineLine,
        fontFamily: 'monospace',
      ),
    );
  }

  Widget _buildActionButton() {
    if (widget.order.status == OrderStatus.completed) {
      return const SizedBox.shrink();
    }

    final label = widget.order.status == OrderStatus.pending ? 'Start' : 'Done';
    final color = widget.order.status == OrderStatus.pending
        ? AppColors.info
        : AppColors.success;

    return SizedBox(
      height: 32,
      child: ElevatedButton(
        onPressed: () {
          final cb = widget.order.status == OrderStatus.pending
              ? widget.onStart
              : widget.onComplete;
          cb?.call();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          textStyle: const TextStyle(fontSize: 12),
        ),
        child: Text(label),
      ),
    );
  }

  // ── Waiter ───────────────────────────────────────────────────────

  Widget _buildWaiterCard() {
    final statusColor = OrderStatus.colorFor(widget.order.status);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.receipt, color: statusColor),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order #${widget.order.id}',
                      style: AppTypography.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${widget.order.totalQuantity} item${widget.order.totalQuantity == 1 ? '' : 's'}',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.grey600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${widget.currencySymbol}${widget.order.grandTotal.toStringAsFixed(2)}',
                      style: AppTypography.titleSmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              _StatusBadge(status: widget.order.status),
              if (widget.trailing != null) ...[
                const SizedBox(width: 4),
                widget.trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ── Display ──────────────────────────────────────────────────────

  Widget _buildDisplayCard() {
    final elapsed = DateTime.now().difference(widget.order.createdAt);
    final isPreparing = widget.order.status == OrderStatus.preparing;

    return AnimatedBuilder(
      animation: _pulseAnimation ?? AlwaysStoppedAnimation(1.0),
      builder: (context, child) => Transform.scale(
        scale: isPreparing ? (_pulseAnimation?.value ?? 1.0) : 1.0,
        child: child,
      ),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (widget.order.status == OrderStatus.pending)
                    widget.displayLeading ??
                        const SizedBox(width: 24, height: 24)
                  else
                    Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: OrderStatus.colorFor(widget.order.status),
                      ),
                    ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Order #${widget.order.id}',
                      style: AppTypography.titleLarge.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.grey100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      _formatDuration(elapsed),
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.grey600,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: _StatusBadge(status: widget.order.status),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration d) {
    final min = d.inMinutes;
    final sec = d.inSeconds % 60;
    return '${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }

  // ── Admin ────────────────────────────────────────────────────────

  Widget _buildAdminTile() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${widget.currencySymbol}${widget.order.finalTotal.toStringAsFixed(2)}',
              style: AppTypography.headlineSmall,
            ),
            _OrderTypeBadge(type: widget.order.type),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Date: ${_formatDate(widget.order.createdAt)}'),
            Text('Customer Phone: ${widget.order.customerPhone ?? 'N/A'}'),
            Text('Total Quantity: ${widget.order.totalQuantity}'),
            Text(
              'Sub Total: ${widget.currencySymbol}${widget.order.subTotal.toStringAsFixed(2)}',
            ),
            Text(
              'Discount: ${widget.currencySymbol}${widget.order.discountTotal.toStringAsFixed(2)}',
            ),
            Text(
              'Tax: ${widget.currencySymbol}${widget.order.taxTotal.toStringAsFixed(2)}',
            ),
            Text(
              'Grand Total: ${widget.currencySymbol}${widget.order.grandTotal.toStringAsFixed(2)}',
            ),
            if (widget.order.paidTotal != null)
              Text(
                'Paid Total: ${widget.currencySymbol}${widget.order.paidTotal!.toStringAsFixed(2)}',
              ),
          ],
        ),
        onTap: widget.onTap,
      ),
    );
  }

  String _formatDate(DateTime dt) {
    // Use a basic format to avoid intl dependency here
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  }
}

// ── Shared sub-widgets ──────────────────────────────────────────────

/// Small colored badge showing the order status text.
class _StatusBadge extends StatelessWidget {
  final OrderStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = OrderStatus.colorFor(status);
    final label = switch (status) {
      OrderStatus.pending => 'Pending',
      OrderStatus.preparing => 'Preparing',
      OrderStatus.ready => 'Ready',
      OrderStatus.served => 'Served',
      OrderStatus.completed => 'Completed',
      OrderStatus.voided => 'Voided',
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 12)),
    );
  }
}

/// Badge showing the order type (dine-in, takeaway, delivery).
class _OrderTypeBadge extends StatelessWidget {
  final OrderType type;

  const _OrderTypeBadge({required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Color(type.color!)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        type.description!,
        style: AppTypography.labelLarge.copyWith(color: Color(type.color!)),
      ),
    );
  }
}
