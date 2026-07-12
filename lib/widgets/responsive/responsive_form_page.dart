import 'package:eatery/core/utils/responsive.dart';
import 'package:eatery/references.dart';
import 'package:eatery/core/theme/app_colors.dart';

/// A scaffold wrapper for form/detail pages that constrains content
/// width on desktop while allowing full-width on mobile.
///
/// [title] — AppBar title
/// [color] — AppBar background color
/// [actions] — AppBar action buttons
/// [child] — the form/list content (typically a ListView)
/// [floatingActionButton] — optional FAB
/// [bottomNavigationBar] — optional bottom bar
class ResponsiveFormPage extends StatelessWidget {
  final String title;
  final Color color;
  final List<Widget>? actions;
  final Widget child;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final bool resizeToAvoidBottomInset;

  const ResponsiveFormPage({
    super.key,
    required this.title,
    required this.color,
    this.actions,
    required this.child,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.resizeToAvoidBottomInset = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      backgroundColor: AppColors.grey200,
      appBar: AppBar(
        backgroundColor: color,
        foregroundColor: AppColors.white,
        title: Text(title),
        actions: actions,
      ),
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      body: isDesktop
          ? Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: child,
              ),
            )
          : child,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
