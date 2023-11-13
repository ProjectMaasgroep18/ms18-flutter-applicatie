import 'package:flutter/material.dart';
import 'package:ms18_applicatie/Models/stock.dart';
import 'package:ms18_applicatie/Widgets/buttons.dart';
import 'package:ms18_applicatie/Widgets/inputFields.dart';
import 'package:ms18_applicatie/Widgets/paddingSpacing.dart';
import 'package:ms18_applicatie/Widgets/statusIndicator.dart';
import '../config.dart';

Future<void> addItemsDialog(
    BuildContext context, Function(StockProduct stockProduct) onSave,
    [StockProduct? stockProduct]) async {
      //Checking if the product is being changed
  bool isChange = stockProduct != null;
  //Adding default product information
  stockProduct ??= StockProduct(
      product:
          Product(color: Colors.black, name: '', price: 0, priceQuantity: 0),
      quantity: 0);

  //Initializing the input controllers
  TextEditingController nameController =
      TextEditingController(text: stockProduct.product.name);
  TextEditingController priceController =
      TextEditingController(text: stockProduct.product.price.toString());
  TextEditingController countController =
      TextEditingController(text: stockProduct.quantity.toString());

  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Item ${isChange ? 'wijzigen' : 'toevoegen'}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
              const Divider(
                color: secondColor,
              )
            ],
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(borderRadius),
            ),
          ),
          content: Container(
              width: double.maxFinite,
              height: 200,
              color: Colors.white,
              child: Column(
                children: [
                  InputField(
                    controller: nameController,
                    labelText: 'Product naam',
                  ),
                  const PaddingSpacing(),
                  InputField(
                    controller: priceController,
                    labelText: 'Prijs',
                  ),
                  const PaddingSpacing(),
                  InputField(
                    controller: countController,
                    labelText: 'Aantal stuks',
                  ),
                ],
              )),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Sluit het dialoogvenster
              },
              child: const Text('Terug'),
            ),
            SizedBox(
              width: 150,
              child: Button(
                onTap: () {
                  Navigator.pop(context);
                  onSave(stockProduct!);
                },
                text: 'Opslaan',
              ),
            )
          ],
        );
      }).then((value) {});
}

class StockElement extends StatelessWidget {
  final StockProduct stockProduct;
  final Function(String)? onChange;
  late TextEditingController stockController;

  StockElement({
    required this.stockProduct,
    this.onChange,
  }) {
    stockController =
        TextEditingController(text: stockProduct.quantity.toString());
  }

  //Increasing or decresing the input by the given amount
  void changeNumber(int change) {
    int currentValue = int.parse(stockController.text);
    currentValue += change;

    stockController.text = currentValue.toString();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        addItemsDialog(context,(stockProduct){}, stockProduct);
      },
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
              child: StatusIndicator(color: successColor)),
        ]),
      ),
      title: Text(stockProduct.product.name),
      subtitle: Text(
          '${stockProduct.product.priceQuantity}: €${stockProduct.product.price}'),
      trailing: SizedBox(
          width: 175,
          child: Row(
            children: [
              SizedBox(
                width: 44,
                height: 44,
                child: Button(
                  onTap: () {
                    changeNumber(-1);
                  },
                  icon: Icons.remove,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Flexible(
                child: InputField(
                  controller: stockController,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              SizedBox(
                width: 44,
                height: 44,
                child: Button(
                  onTap: () {
                    changeNumber(1);
                  },
                  icon: Icons.add,
                ),
              ),
            ],
          )),
    );
  }
}