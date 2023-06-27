import 'package:eatery/references.dart';

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
    return ColorStyle.tertiary;
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      backgroundColor: getThemeColor(),
      title: const Text('Help'),
    );


    return Scaffold(
      appBar: appBar,
      body: Stack(
        children: [
          Positioned(top: 12.0, left: 0.0, right: 0.0, bottom: 72, child: Container(color: Colors.blueAccent,)),
        ],
      ),
    );
  }
}
