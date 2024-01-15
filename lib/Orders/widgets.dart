import 'package:flutter/material.dart';
import 'package:ms18_applicatie/Models/order.dart';
import 'package:ms18_applicatie/Models/stock.dart';
import 'package:ms18_applicatie/Stock/widgets.dart';
import 'package:ms18_applicatie/Widgets/inputPopup.dart';
import 'package:ms18_applicatie/config.dart';

class OrderElement extends StatelessWidget {
  final Order order;
  final Function(String?)? onChange;
  final bool isOwnPage;

  const OrderElement({
    super.key,
    required this.order,
    this.onChange,
    this.isOwnPage = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        orderDetailsDialog(context, order);
      },
      leading: Text('€${priceFormat.format(order.totalAmount)}',
          style: const TextStyle(fontSize: 15)),
      title: !isOwnPage ? Text(order.user.name) : null,
      subtitle: !isOwnPage ? Text(order.user.email) : null,
      contentPadding: EdgeInsets.zero,
      trailing:
          Text(order.getDateString(), style: const TextStyle(fontSize: 15)),
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
