import 'dart:js';

import 'package:flutter/material.dart';
import 'package:ms18_applicatie/Models/stock.dart';
import 'package:ms18_applicatie/Stock/widgets.dart';
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
            title: const Text(
              "Item toevoegen",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: mainColor,
                fontSize: 20,
              ),
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(3.0)),
            ),
            content: Container(
                width: double.maxFinite,
                height: 250,
                // Set a minimum width to avoid intrinsic dimension issues
                child: Column(
                  children: [
                    Container(
                        child: TextFormField(
                          decoration: InputDecoration(
                              hintText: "Naam product", labelText: "Naam"),
                          validator: (String? value) {
                            if (value == null || value == "") {
                              return "Graag een naam invoeren";
                            }
                          },
                        )),
                    Container(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              hintText: "prijs", labelText: "prijs"),
                          validator: (String? value) {
                            if (value == null || value == "") {
                              return "Graag prijs vermelden";
                            }
                          },
                        )),
                    Container(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              hintText: "Aantal stuks", labelText: "Aantal"),
                          validator: (String? value) {
                            if (value == null || value == "") {
                              return "Graag aantal vermelden";
                            }
                          },
                        )),
                  ],
                )),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Sluit het dialoogvenster
                },
                child: Text('Terug'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Plaats hier de logica om de gegevens op te slaan
                  // en sluit vervolgens het dialoogvenster
                  Navigator.of(context).pop();
                },
                child: Text('Opslaan'),
              ),
            ],
            //       );
            //     },
            //   );
            // }

            // actions: [
            //     Row(
            //       children: [
            //         Expanded(
            //           child: Container(
            //             child: ElevatedButton(
            //               onPressed: () {
            //                 // Close Dialog
            //                 dbHelper.syncOrders(ordernumber: code);
            //               },
            //               style: ElevatedButton.styleFrom(
            //                 backgroundColor: const Color(awlGreen),
            //                 padding: const EdgeInsets.fromLTRB(16, 5, 16, 5),
            //                 shadowColor: const Color(awlGreen),
            //                 elevation: 0,
            //               ),
            //               child: const FittedBox(
            //                 fit: BoxFit.fill,
            //                 child: Text(
            //                   "Nog een keer versturen",
            //                   style: TextStyle(
            //                     fontSize: 14,
            //                   ),
            //                   textAlign: TextAlign.center,
            //                 ),
            //               ),
            //             ),
            //           ),
            //         ),
            //         SizedBox(width: 2),
            //         showOpen ? Expanded(
            //           child: Container(
            //             child: ElevatedButton(
            //               onPressed: () {
            //                 // Close Dialog
            //                 ordernumber = code;
            //                 Navigator.push(
            //                     context,
            //                     MaterialPageRoute(
            //                         builder: (context) =>
            //                         const CreateOrderPage()));
            //               },
            //               style: ElevatedButton.styleFrom(
            //                 backgroundColor: const Color(awlGreen),
            //                 padding: const EdgeInsets.fromLTRB(16, 5, 16, 5),
            //                 shadowColor: const Color(awlGreen),
            //                 elevation: 0,
            //               ),
            //               child: const FittedBox(
            //                 fit: BoxFit.fill,
            //                 child: Text(
            //                   "Openen order",
            //                   style: TextStyle(
            //                     fontSize: 14,
            //                   ),
            //                   textAlign: TextAlign.center,
            //                 ),
            //               ),
            //             ),
            //           ),
            //         ) : Container(),
            //       ],
            //     ),
            //     Row(
            //       children: [
            //         Expanded(
            //           child: Container(
            //             child: ElevatedButton(
            //               onPressed: () {
            //                 orderlines = [];
            //                 // Close Dialog
            //                 Navigator.of(context, rootNavigator: true)
            //                     .pop('dialog');
            //               },
            //               style: ElevatedButton.styleFrom(
            //                 backgroundColor: const Color(awlGrey),
            //                 padding: const EdgeInsets.fromLTRB(16, 5, 16, 5),
            //                 shadowColor: const Color(awlGrey),
            //                 elevation: 0,
            //               ),
            //               child: FittedBox(
            //                 fit: BoxFit.fill,
            //                 child: Text(
            //                   "",
            //                   style: const TextStyle(
            //                     fontSize: 14,
            //                   ),
            //                   textAlign: TextAlign.center,
            //                 ),
            //               ),
            //             ),
            //           ),
            //         )
            //       ],
            //     )
            //   Container(),
            // ],
          );
        }).then((value) {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Menu(
      child: SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PageHeader(title: "Voorraad beheer", onAdd: (){addItemsDialog(context);},),
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
