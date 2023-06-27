import 'package:intl/intl.dart';
import 'package:eatery/references.dart';

class PrintSalesReportPage extends StatefulWidget {
  const PrintSalesReportPage(
      {Key? key, required this.account, required this.orders})
      : super(key: key);
  final dynamic account;
  final List<Map<String, dynamic>> orders;

  @override
  State<PrintSalesReportPage> createState() => _PrintSalesReportPageState();
}

class _PrintSalesReportPageState extends State<PrintSalesReportPage> {
  DateTime from = DateTime.now();
  DateTime till = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  Color getThemeColor() {
    return ColorStyle.tertiary;
  }

  SizedBox options() {
    return SizedBox(
      width: double.maxFinite,
      height: double.maxFinite,
      child:
          ListView(scrollDirection: Axis.vertical, shrinkWrap: true, children: [
        DateTimePicker(
          cursorColor: getThemeColor(),
          initialValue: '',
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
          dateLabelText: 'From',
          onChanged: (val) {
            setState(() {
              from = DateFormat("yyyy-MM-dd").parse(val);
            });
          },
          validator: (val) {
            return null;
          },
          onSaved: (val) => debugPrint(val),
        ),
        DateTimePicker(
          cursorColor: getThemeColor(),
          initialValue: '',
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
          dateLabelText: 'Till',
          onChanged: (val) {
            setState(() {
              till = DateFormat("yyyy-MM-dd").parse(val);
            });
          },
          validator: (val) {
            return null;
          },
          onSaved: (val) => debugPrint(val),
        )
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      backgroundColor: getThemeColor(),
      title: const Text('Sales Report'),
    );

    return Scaffold(
      appBar: appBar,
      body: Stack(
        children: [
          Positioned(
              top: 12.0, left: 12.0, right: 12.0, bottom: 0, child: options()),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: ColorStyle.backgroundColorAlter,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: PrimaryButton(
            color: getThemeColor(),
            onPressed: () async {
              // await PrintReport.printReceipt(
              //     orders: widget.orders,
              //     account: widget.account,
              //     from: from,
              //     till: till);
            },
            child: const Text('Print'),
          ),
        ),
      ),
    );
  }
}
