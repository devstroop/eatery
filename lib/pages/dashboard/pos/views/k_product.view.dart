import 'package:eatery/references.dart';

class KProductView extends StatelessWidget {
  const KProductView({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppBar(
              title: Text(product.name),
              backgroundColor: Colors.transparent,
              foregroundColor: ColorStyle.text200,
              leading: IconButton(
                icon: Icon(UIcons.regularStraight.arrow_left),
                onPressed: () {
                  Navigator.pop(context);
                },
              )),

          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12.0),
            height: 0.5,
            color: ColorStyle.text400,
          ),
          Container(
            height: 200,
            margin: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
                color: ColorStyle.text400.withOpacity(0.36),
                borderRadius: BorderRadius.circular(12.0),
                image: DecorationImage(
                    image: LibraryImage(product.image).image,
                    fit: product.type==ProductType.inventoryItem ? BoxFit.contain : BoxFit.cover,
                )),
            child: Stack(
              children: [
                Positioned(
                  top: 12.0,
                  right: 12.0,
                  child: FoodTypeBadge(
                    foodType: product.foodType,
                    backgroundColor: Colors.white,
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Description',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                Text(product.description ?? '', style: TextStyle(color: ColorStyle.text300, fontSize: 12),),
              ],
            ),
          ),
          const SizedBox(
            height: 48,
          )
        ]);
  }
}
