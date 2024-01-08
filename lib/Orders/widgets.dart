import 'package:flutter/material.dart';
import 'package:ms18_applicatie/Models/order.dart';
import 'package:ms18_applicatie/Models/stock.dart';
import 'package:ms18_applicatie/Stock/widgets.dart';
import 'package:ms18_applicatie/Widgets/inputPopup.dart';
import 'package:ms18_applicatie/config.dart';

class OrderElement extends StatelessWidget {
  final Order order;
  final Function(String?)? onChange;

  const OrderElement({
    super.key,
    required this.order,
    this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        orderDetailsDialog(context, order);
      },
      leading: Text('€${priceFormat.format(order.totalAmount)}'),
      title: Text(order.user.name),
      subtitle: Text(order.user.email),
      contentPadding: EdgeInsets.zero,
      trailing: Text(order.getDateString()),
    );
  }
}

Future<void> orderDetailsDialog(BuildContext context, Order order) async {
  List<StockProduct> items = order.items;

  await showInputPopup(
    context,
    title: "Order informatie",
    child: SizedBox(
      height: 400,
      child: SingleChildScrollView(
        child: ListView.separated(
          shrinkWrap: true,
          separatorBuilder: (context, index) => const Divider(),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return StockElement(
              stockProduct: items[index],
              isReadOnly: true,
            );
          },
        ),
      ),
    ),
  );
}
