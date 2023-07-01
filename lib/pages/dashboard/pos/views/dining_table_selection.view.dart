import 'package:eatery/references.dart';

class DiningTableSelectionView extends StatefulWidget {
  const DiningTableSelectionView(
      {super.key,
      this.themeColor,
      this.onDiningTableSelected,
      this.selectedDiningTable,
      this.onOrderInitiated});

  final DiningTable? selectedDiningTable;
  final Color? themeColor;
  final Function(DiningTable diningTable)? onDiningTableSelected;
  final Function(Voucher? voucher)? onOrderInitiated;

  @override
  State<DiningTableSelectionView> createState() =>
      _DiningTableSelectionViewState();
}

class _DiningTableSelectionViewState extends State<DiningTableSelectionView> {
  DiningTableCategory? selectedCategory;

  set selectedOrder(Voucher? value) {
    widget.onOrderInitiated?.call(value);
  }

  set selectedDiningTable(DiningTable value) {
    widget.onDiningTableSelected?.call(value);
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        selectedCategory = null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      AppBar(
          title: const Text('Select Dining Table'),
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
      SizedBox(
        height: 100,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(6.0),
          children: [
            CircularCategoryPOSWidget(
              margin: const EdgeInsets.only(right: 12),
              onTap: () {
                setState(() {
                  selectedCategory = null;
                });
              },
              themeColor: widget.themeColor,
              selected: selectedCategory?.key == null,
              label: 'All',
              image: const AssetImage('assets/icons/all.png'),
            ),
            ...EateryDB.instance.diningTableCategoryBox!.values.map((e) {
              return CircularCategoryPOSWidget(
                margin: const EdgeInsets.only(right: 12),
                onTap: () {
                  setState(() {
                    selectedCategory = e;
                  });
                },
                themeColor: widget.themeColor,
                selected: selectedCategory?.key == e.key,
                label: e.name,
                image: LibraryImage(e.image ?? '').image,
              );
            }),
          ],
        ),
      ),
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 12.0),
        height: 0.5,
        color: ColorStyle.text400,
      ),
      Flexible(
        child: GridView(
          padding: const EdgeInsets.all(12.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12.0,
            mainAxisSpacing: 12.0,
          ),
          children: [
            ...EateryDB.instance.diningTableBox!.values
                .where((element) =>
                    selectedCategory?.key == null ||
                    element.categoryId == selectedCategory?.key)
                .map((diningTable) {
              Voucher? voucher = diningTable.voucherKey != null
                  ? EateryDB.instance.voucherBox!.values.singleWhere(
                      (element) => element.key == diningTable.voucherKey)
                  : null;
              return DiningTableSelectionCard(
                diningTable: diningTable,
                selected: diningTable.key == widget.selectedDiningTable?.key,
                onTap: () => _onDiningTableSelected(diningTable, voucher),
                voucher: voucher,
              );
            }),
          ],
        ),
      )
    ]);
  }

  _onDiningTableSelected(DiningTable diningTable, Voucher? voucher) {
    if (diningTable.key == widget.selectedDiningTable?.key) {
      return;
    }
    if (voucher != null && diningTable.voucherKey == voucher.key && voucher.isClosed) {
      // TODO: Show dialog that order is closed

      return;
    }
    // TODO: Take phone number (*mandatory), Additional info (optional)
    // TODO: Find customer by phone number or create new customer with phone number and additional info or name 'Walk in ${EateryDB.instance.customerBox.nextId()}'
    String phoneNumber = '7488797047';
    String? name = 'Walk in X';
    String? email = '';
    String? address = '';

    Master customer = EateryDB.instance.masterBox!.values.firstWhere(
        (element) =>
            element.phone?.replaceFirst('+', '').trim() ==
            phoneNumber.replaceFirst('+', '').trim(), orElse: () {
      return voucher?.master ??
          Master(
              name: name,
              phone: phoneNumber,
              address: address,
              email: email);
    });

    voucher ??
        Voucher(
            master: customer,
            saleOrderType: SaleOrderType.dine, voucherType: VoucherType.saleOrder);
    setState(() {
      selectedDiningTable = diningTable;
      selectedOrder = voucher;
    });
  }
}
