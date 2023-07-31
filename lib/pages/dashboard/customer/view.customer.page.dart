import 'package:eatery/references.dart';

class ViewCustomer extends StatefulWidget {
  const ViewCustomer({super.key, required this.customer});
  final Customer customer;
  @override
  State<ViewCustomer> createState() => _ViewCustomerState();
}

class _ViewCustomerState extends State<ViewCustomer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.customer.name),
            Text(widget.customer.phone, style: const TextStyle(fontSize: 12),),
          ],
        ),
      ),
    );
  }
}
