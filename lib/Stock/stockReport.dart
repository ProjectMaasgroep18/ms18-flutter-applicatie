import 'package:flutter/material.dart';
import 'package:ms18_applicatie/Models/stock.dart';
import 'package:ms18_applicatie/Stock/widgets.dart';
import 'package:ms18_applicatie/Widgets/buttons.dart';
import 'package:ms18_applicatie/Widgets/inputFields.dart';
import 'package:ms18_applicatie/Widgets/paddingSpacing.dart';
import 'package:ms18_applicatie/Widgets/pageHeader.dart';
import 'package:ms18_applicatie/config.dart';
import 'package:ms18_applicatie/menu.dart';

class StockReport extends StatefulWidget {
  const StockReport({Key? key}) : super(key: key);

  @override
  State<StockReport> createState() => StockReportState();
}

class StockReportState extends State<StockReport> {
  final List<StockProduct> stockProducts = [
    StockProduct(
      product: Product(
        priceQuantity: 1,
        color: Colors.redAccent,
        name: 'Bier',
        price: 2.43,
      ),
      quantity: 40,
    ),
    StockProduct(
      product: Product(
        priceQuantity: 1,
        color: Colors.blueAccent,
        name: 'Cola',
        price: 3.13,
      ),
      quantity: 21,
    ),
    StockProduct(
      product: Product(
        priceQuantity: 1,
        color: Colors.redAccent,
        name: 'Bier',
        price: 2.43,
      ),
      quantity: 40,
    ),
    StockProduct(
      product: Product(
        priceQuantity: 1,
        color: Colors.yellowAccent,
        name: 'Fanta',
        price: 6.81,
      ),
      quantity: 12,
    ),
    StockProduct(
      product: Product(
        priceQuantity: 1,
        color: Colors.redAccent,
        name: 'Bier',
        price: 2.43,
      ),
      quantity: 40,
    ),
    StockProduct(
      product: Product(
        priceQuantity: 1,
        color: Colors.greenAccent,
        name: 'Wiskey',
        price: 0.43,
      ),
      quantity: 8,
    ),
    StockProduct(
      product: Product(
        priceQuantity: 1,
        color: Colors.redAccent,
        name: 'Bier',
        price: 2.43,
      ),
      quantity: 40,
    ),
  ];

  Future<void> addItemsDialog(context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            title: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Item toevoegen",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
                Divider(
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
                child: const Column(
                  children: [
                    InputField(
                      labelText: 'Product naam',
                    ),
                    PaddingSpacing(),
                    InputField(
                      labelText: 'Prijs',
                    ),
                    PaddingSpacing(),
                    InputField(
                      labelText: 'Aantal stuks',
                    ),
                  ],
                )),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Sluit het dialoogvenster
                },
                child: Text('Terug'),
              ),
              SizedBox(
                width: 150,
                child: Button(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  text: 'Opslaan',
                ),
              )
            ],
          );
        }).then((value) {});
  }

  @override
  Widget build(BuildContext context) {
    return Menu(
        child: SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PageHeader(
            title: "Voorraad beheer",
            onAdd: () {
              addItemsDialog(context);
            },
          ),
          Flexible(
            child: ListView.separated(
              padding: const EdgeInsets.all(mobilePadding),
              shrinkWrap: true,
              itemCount: stockProducts.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                return StockElement(
                  stockProduct: stockProducts[index],
                );
              },
            ),
          ),
        ],
      ),
    ));
  }
}
