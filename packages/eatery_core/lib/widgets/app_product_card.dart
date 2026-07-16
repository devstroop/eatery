import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_shadows.dart';
import '../theme/app_typography.dart';

class AppProductCard extends StatelessWidget {
  final Widget image;
  final Widget? badge;
  final Widget? stockBadge;
  final String name;
  final String? description;
  final String? salePrice;
  final String? mrpPrice;
  final String currencySymbol;
  final Color themeColor;
  final int cartQuantity;
  final VoidCallback? onTap;
  final VoidCallback? onAdd;
  final VoidCallback? onRemove;
  final double width;
  final double height;
  final bool isActive;

  const AppProductCard({
    super.key,
    required this.image,
    this.badge,
    this.stockBadge,
    required this.name,
    this.description,
    this.salePrice,
    this.mrpPrice,
    this.currencySymbol = '',
    required this.themeColor,
    this.cartQuantity = 0,
    this.onTap,
    this.onAdd,
    this.onRemove,
    required this.width,
    required this.height,
    this.isActive = true,
  });

  @override
  Widget build(BuildContext context) {
    final cardRadius = BorderRadius.circular(AppSpacing.productCardRadius);
    final inactiveOverlay = !isActive
        ? const BoxDecoration(
            color: Colors.grey,
            backgroundBlendMode: BlendMode.saturation,
            borderRadius: BorderRadius.all(Radius.circular(6.0)),
          )
        : null;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.cardGapY),
      child: Stack(
        children: [
          Container(
            foregroundDecoration: inactiveOverlay,
            margin: EdgeInsets.symmetric(horizontal: AppSpacing.productCardMargin),
            decoration: BoxDecoration(
              boxShadow: AppShadows.cardElevated,
              borderRadius: cardRadius,
            ),
            width: width,
            height: height,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: InkWell(
                    onTap: onTap,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(AppSpacing.productCardRadius),
                                topRight: Radius.circular(AppSpacing.productCardRadius),
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(AppSpacing.productCardRadius),
                                topRight: Radius.circular(AppSpacing.productCardRadius),
                              ),
                              child: image,
                            ),
                          ),
                        ),
                        if (badge != null)
                          Positioned(
                            top: AppSpacing.cardBadgeOffset,
                            right: AppSpacing.cardBadgeOffset,
                            child: badge!,
                          ),
                        if (stockBadge != null)
                          Positioned(
                            top: AppSpacing.cardBadgeOffset,
                            left: AppSpacing.cardBadgeOffset,
                            child: stockBadge!,
                          ),
                      ],
                    ),
                  ),
                ),
                _buildInfoSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection() {
    final hasPriceRow = (salePrice != null || mrpPrice != null) &&
        (onAdd != null || onRemove != null);
    final showMrpStrike = salePrice != null && mrpPrice != null && salePrice != mrpPrice;

    return Container(
      padding: EdgeInsets.all(AppSpacing.productCardInfoPad),
      decoration: const BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(6.0),
          bottomRight: Radius.circular(6.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.productCardName.copyWith(
                  color: AppColors.grey700,
                ),
              ),
              if (description != null && description!.isNotEmpty)
                Text(
                  description!,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.productCardDesc.copyWith(
                    color: AppColors.grey400,
                  ),
                ),
            ],
          ),
          if (hasPriceRow)
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showMrpStrike)
                      Text(
                        '$currencySymbol$mrpPrice',
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.productCardPriceStrike.copyWith(
                          color: AppColors.grey700,
                        ),
                      ),
                    if (salePrice != null)
                      Text(
                        '$currencySymbol$salePrice',
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.productCardPrice.copyWith(
                          color: AppColors.success,
                        ),
                      ),
                    if (salePrice == null && mrpPrice != null)
                      Text(
                        '$currencySymbol$mrpPrice',
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.productCardPrice.copyWith(
                          color: AppColors.success,
                        ),
                      ),
                  ],
                ),
                _buildCartControl(),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildCartControl() {
    if (onAdd == null || onRemove == null) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(color: themeColor, width: 1),
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(
          AppSpacing.productCardCartHSym,
          AppSpacing.productCardCartVSym,
          AppSpacing.productCardCartHSym,
          AppSpacing.productCardCartVSym,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (cartQuantity > 0)
              InkWell(
                onTap: onRemove,
                child: Icon(Icons.remove, color: themeColor, size: AppSpacing.productCardIconSize),
              ),
            if (cartQuantity > 0)
              Padding(
                padding: EdgeInsetsDirectional.only(
                  start: AppSpacing.productCardQtyGap,
                  end: AppSpacing.productCardQtyGap,
                ),
                child: Text(
                  cartQuantity.toString(),
                  style: AppTypography.labelSmall.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            InkWell(
              onTap: onAdd,
              child: Icon(Icons.add, color: themeColor, size: AppSpacing.productCardIconSize),
            ),
          ],
        ),
      ),
    );
  }
}
