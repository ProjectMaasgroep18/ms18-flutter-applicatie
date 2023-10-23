import 'package:flutter/material.dart';
import 'package:ms18_applicatie/Models/stock.dart';
import 'package:ms18_applicatie/Widgets/inputFields.dart';
import 'package:ms18_applicatie/Widgets/statusIndicator.dart';
import '../config.dart';

class StockElement extends StatelessWidget {
  final StockProduct stockProduct;
  final Function(String)? onChange;

  const StockElement({
    required this.stockProduct,
    this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SizedBox(
        width: 45,
        height: 45,
        child: Stack(clipBehavior: Clip.none, children: [
          Container(
            decoration: BoxDecoration(
              color: stockProduct.product.color,
              borderRadius: BorderRadius.circular(
                borderRadius,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(2, 2), // changes position of shadow
                ),
              ],
            ),
          ),
          const Positioned(
            bottom: 0,
            right: -3,
            child: StatusIndicator(color: successColor)
          ),
        ]),
      ),
      title: Text(stockProduct.product.name),
      subtitle: Text(
          '${stockProduct.product.priceQuantity}: €${stockProduct.product.price}'),
      trailing: SizedBox(
        width: 75,
        child: InputField(
          controller: TextEditingController(text: stockProduct.quantity.toString()),
          textAlign: TextAlign.center,
        )
      ),
    );
  }
}
