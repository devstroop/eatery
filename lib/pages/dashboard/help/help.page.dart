import 'package:eatery_core/widgets/app_page_shell.dart';
import 'package:eatery/references.dart';
import 'package:eatery_core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HelpPage extends ConsumerStatefulWidget {
  const HelpPage({Key? key, this.account}) : super(key: key);
  final dynamic account;

  @override
  ConsumerState<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends ConsumerState<HelpPage> {


  @override
  void initState() {
    super.initState();
  }

  Color getThemeColor() {
    return AppColors.menuCategories;
  }

  @override
  Widget build(BuildContext context) {
    return AppPageShell(
      title: 'Help',
      color: getThemeColor(),
      child: Stack(
        children: [
          Positioned(top: 12.0, left: 0.0, right: 0.0, bottom: 72, child: Container(color: Colors.blueAccent,)),
        ],
      ),
    );
  }
}
