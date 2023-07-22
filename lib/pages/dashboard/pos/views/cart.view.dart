import 'package:eatery/references.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      AppBar(
          title: const Text('Cart'),
          backgroundColor: Colors.transparent,
          foregroundColor: ColorStyle.text200,
      ),

      Container(
        margin: const EdgeInsets.symmetric(horizontal: 12.0),
        height: 0.5,
        color: ColorStyle.text400,
      ),
    ]);
  }
}
