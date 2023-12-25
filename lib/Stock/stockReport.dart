import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ms18_applicatie/Api/apiManager.dart';
import 'package:ms18_applicatie/Models/stock.dart';
import 'package:ms18_applicatie/Stock/widgets.dart';
import 'package:ms18_applicatie/Widgets/pageHeader.dart';
import 'package:ms18_applicatie/Widgets/popups.dart';
import 'package:ms18_applicatie/config.dart';
import 'package:ms18_applicatie/menu.dart';

class StockReport extends StatefulWidget {
  StockReport({Key? key}) : super(key: key);
  static const String url = "api/v1/Product";

  @override
  State<StockReport> createState() => _StockReportState();
}

class _StockReportState extends State<StockReport> {
  Set<StockProduct> changedProducts = {};
  ValueNotifier<bool> hasChangedStock = ValueNotifier(false);

  String colorToString(Color color) {
    return "#${color.value.toRadixString(16).substring(2)}";
  }

  void reploadPage() {
    navigatorKey.currentState!.pushReplacement(
        MaterialPageRoute(builder: ((context) => StockReport())));
  }

  Future<List<StockProduct>> getStock() async {
    List<StockProduct> stockItems = [];

    await ApiManager.get<List<dynamic>>(StockReport.url).then((data) {
      for (Map<String, dynamic> product in data) {
        Map<String, dynamic> map = product;

        //Parsing the color from the db
        final String hexColor =
            "FF${(map["color"] as String).replaceAll('#', '')}";
        final int color = int.tryParse(hexColor, radix: 16) ?? 0xFFFFFFFF;

        StockProduct tempProduct = StockProduct(
            product: Product(
                color: Color(color),
                name: map["name"],
                price: double.tryParse(map["price"].toString()) ?? 0,
                icon: map["icon"],
                id: map['id']),
            quantity: map['stock'] ?? 0);
        stockItems.add(tempProduct);
      }
    });
    return stockItems;
  }

  Future addProduct(StockProduct stockProduct) async {
    Map<String, dynamic> body = {
      'name': stockProduct.product.name,
      'price': stockProduct.product.price,
      'icon': stockProduct.product.icon,
      // 'stock': stockProduct.quantity,
      'color': colorToString(
          Colors.primaries[Random().nextInt(Colors.primaries.length)]),
      'priceQuantity': 0
    };

    PopupAndLoading.showLoading();
    await ApiManager.post(StockReport.url, body).then((value) {
      PopupAndLoading.showSuccess("Product toevoegen gelukt");
      reploadPage();
    }).catchError((error) {
      print(error);
      PopupAndLoading.showError("Product toevoegen mislukt");
    });
    PopupAndLoading.endLoading();
  }

  Future updateProduct(StockProduct stockProduct) async {
    Map<String, dynamic> body = {
      'id': stockProduct.product.id,
      'name': stockProduct.product.name,
      'price': stockProduct.product.price,
      // 'stock': stockProduct.quantity,
      'icon': stockProduct.product.icon,
      'color': colorToString(stockProduct.product.color),
      'priceQuantity': 0
    };

    PopupAndLoading.showLoading();
    await ApiManager.put("${StockReport.url}/${stockProduct.product.id}", body)
        .then((value) {
      PopupAndLoading.showSuccess("Product wijzigen gelukt");
      reploadPage();
    }).catchError((error) {
      PopupAndLoading.showError("Product wijzigen mislukt");
    });

    PopupAndLoading.endLoading();
  }

  Future deleteProduct(int productId) async {
    PopupAndLoading.showLoading();
    await ApiManager.delete("${StockReport.url}/$productId").then((value) {
      PopupAndLoading.showSuccess("Product verwijderen gelukt");
      reploadPage();
    }).catchError((error) {
      PopupAndLoading.showError("Product verwijderen mislukt");
    });
    PopupAndLoading.endLoading();
  }

  Future updateAllStock() async {
    PopupAndLoading.showLoading();
    // Looping though all the products and updating each of their stock
    await Future.any([
      for (StockProduct changedStock in changedProducts)
        updateStock(changedStock)
    ]).then((value) {
      // Clearing the changed items and hiding the button
      changedProducts = {};
      hasChangedStock.value = false;

      PopupAndLoading.showSuccess("Voorraad wijzigen gelukt");
    }).catchError((error) {
      PopupAndLoading.showError("Voorraad wijzigen mislukt");
    });
    PopupAndLoading.endLoading();
  }

  Future updateStock(StockProduct stockProduct) async {
    Map<String, dynamic> body = {'quantity': stockProduct.quantity};
    await ApiManager.put(
        "${StockReport.url}/${stockProduct.product.id}/Stock", body);
  }

  @override
  Widget build(BuildContext context) {
    return Menu(
      child: SafeArea(
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                PageHeader(
                  title: "Voorraad beheer",
                  onAdd: () {
                    addItemsDialog(context, (stockProduct) async {
                      await addProduct(stockProduct);
                    });
                  },
                ),
                FutureBuilder(
                  future: getStock(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Expanded(
                        child: Center(
                          child: Icon(
                            Icons.error,
                            color: dangerColor,
                            size: 50,
                          ),
                        ),
                      );
                    } else if (snapshot.hasData) {
                      var stockProducts = snapshot.data ?? [];
                      return Flexible(
                        child: ListView.separated(
                          padding: const EdgeInsets.all(mobilePadding)
                              .copyWith(top: 0),
                          itemCount: stockProducts.length,
                          separatorBuilder: (context, index) => const Divider(),
                          itemBuilder: (context, index) {
                            return StockElement(
                              stockProduct: stockProducts[index],
                              onChange: (value) {
                                // Checking if the product has already been changed
                                if (!changedProducts
                                    .contains(stockProducts[index])) {
                                  // Checking id the stock has not changed then show the button
                                  if (!hasChangedStock.value) {
                                    hasChangedStock.value = true;
                                  }

                                  changedProducts.add(stockProducts[index]);
                                }
                              },
                              onSave: (stockProduct) async {
                                await updateProduct(stockProduct);
                              },
                              onDelete: () async {
                                await deleteProduct(
                                    stockProducts[index].product.id);
                              },
                            );
                          },
                        ),
                      );
                    } else {
                      return const Expanded(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: ValueListenableBuilder(
                  valueListenable: hasChangedStock,
                  builder: (context, value, child) {
                    if (value) {
                      return Padding(
                        padding: const EdgeInsets.all(mobilePadding),
                        child: FloatingActionButton(
                            backgroundColor: mainColor,
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              updateAllStock();
                            }),
                      );
                    } else {
                      return const SizedBox();
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }
}
