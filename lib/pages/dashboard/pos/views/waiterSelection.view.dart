import 'package:eatery/references.dart';


class WaiterSelectionView extends StatelessWidget {
  const WaiterSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      AppBar(
          title: const Text('Select Waiter'),
          backgroundColor: Colors.transparent,
          foregroundColor: KColors.text200,
          
      ),

      Container(
        margin: const EdgeInsets.symmetric(horizontal: 12.0),
        height: 0.5,
        color: KColors.text400,
      ),
    ]);
  }
}
