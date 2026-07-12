import 'package:eatery/references.dart';
import 'package:eatery/core/theme/app_colors.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({Key? key, this.account}) : super(key: key);
  final dynamic account;

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {


  @override
  void initState() {
    super.initState();
  }

  Color getThemeColor() {
    return AppColors.menuCategories;
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      backgroundColor: getThemeColor(),
      title: const Text('Help'),
    );


    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: appBar,
      body: Stack(
        children: [
          Positioned(top: 12.0, left: 0.0, right: 0.0, bottom: 72, child: Container(color: Colors.blueAccent,)),
        ],
      ),
    );
  }
}
