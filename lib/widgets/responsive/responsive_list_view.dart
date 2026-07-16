import 'package:eatery_core/utils/responsive.dart';
import 'package:eatery/references.dart';

/// A list view that automatically switches between single-column ListView
/// (mobile) and multi-column grid layout (tablet/desktop).
///
/// [itemCount] — total items
/// [itemBuilder] — builds each card
/// [crossAxisCount] — override; default from [Responsive.gridColumns]
/// [childAspectRatio] — card aspect ratio (width/height). Default 1.0
/// [maxCrossAxisExtent] — max card width on desktop. Default 420
/// [separator] — shown between items on mobile mode only
class ResponsiveListView extends StatelessWidget {
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;
  final int? crossAxisCount;
  final double childAspectRatio;
  final double maxCrossAxisExtent;
  final Widget Function(BuildContext, int)? separator;

  const ResponsiveListView({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.crossAxisCount,
    this.childAspectRatio = 1.0,
    this.maxCrossAxisExtent = 420,
    this.separator,
  });

  @override
  Widget build(BuildContext context) {
    if (Responsive.isDesktop(context) || Responsive.isTablet(context)) {
      final cols = crossAxisCount ?? Responsive.gridColumns(context);
      // Use a custom-wrap approach to get card-like appearance
      return LayoutBuilder(
        builder: (context, constraints) {
          final effectiveMaxExtent = constraints.maxWidth / cols;
          return GridView.builder(
            padding: EdgeInsets.all(Responsive.spacing(context)),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: effectiveMaxExtent.clamp(
                280,
                maxCrossAxisExtent,
              ),
              crossAxisSpacing: Responsive.spacing(context),
              mainAxisSpacing: Responsive.spacing(context),
              childAspectRatio: childAspectRatio,
            ),
            itemCount: itemCount,
            itemBuilder: itemBuilder,
          );
        },
      );
    }

    // Mobile: plain ListView
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: itemCount,
      separatorBuilder: separator ?? (_, _) => const Divider(height: 1),
      itemBuilder: itemBuilder,
    );
  }
}
