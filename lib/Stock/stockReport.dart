import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ms18_applicatie/Api/apiManager.dart';
import 'package:ms18_applicatie/Models/stock.dart';
import 'package:ms18_applicatie/Stock/widgets.dart';
import 'package:ms18_applicatie/Widgets/pageHeader.dart';
import 'package:ms18_applicatie/Widgets/popups.dart';
import 'package:ms18_applicatie/config.dart';
import 'package:ms18_applicatie/menu.dart';

class StockReport extends StatelessWidget {
  const StockReport({Key? key}) : super(key: key);
  static const String url = "api/v1/Product";

  String colorToString(Color color) {
    return "#${color.value.toRadixString(16).substring(2)}";
  }

  void reploadPage() {
    navigatorKey.currentState!.pushReplacement(
        MaterialPageRoute(builder: ((context) => const StockReport())));
  }

  Future<List<StockProduct>> getStock() async {
    List<StockProduct> stockItems = [];

    await ApiManager.get<List<dynamic>>(url).then((data) {
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
                price: double.parse(map["price"].toString()),
                icon: map["icon"],
                id: map['id']),
            quantity: 1);
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
      'color': colorToString(
          Colors.primaries[Random().nextInt(Colors.primaries.length)])
    };

    PopupAndLoading.showLoading();
    await ApiManager.post(url, body).then((value) {
      PopupAndLoading.showSuccess("Product toevoegen gelukt");
      reploadPage();
    }).catchError((error) {
      PopupAndLoading.showError("Product toevoegen mislukt");
    });
    PopupAndLoading.endLoading();
  }

  Future updateProduct(StockProduct stockProduct) async {
    Map<String, dynamic> body = {
      'id': stockProduct.product.id,
      'name': stockProduct.product.name,
      'price': stockProduct.product.price,
      'icon': stockProduct.product.icon,
      'color': colorToString(stockProduct.product.color)
    };

    PopupAndLoading.showLoading();
    await ApiManager.put("$url/${stockProduct.product.id}", body).then((value) {
      PopupAndLoading.showSuccess("Product wijzigen gelukt");
      reploadPage();
    }).catchError((error) {
      PopupAndLoading.showError("Product wijzigen mislukt");
    });

    PopupAndLoading.endLoading();
  }

  Future deleteProduct(int productId) async {
    PopupAndLoading.showLoading();
    await ApiManager.delete("$url/$productId").then((value) {
      PopupAndLoading.showSuccess("Product verwijderen gelukt");
      reploadPage();
    }).catchError((error) {
      PopupAndLoading.showError("Product verwijderen mislukt");
    });
    PopupAndLoading.endLoading();
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
                addItemsDialog(context, (stockProduct) async {
                  await addProduct(stockProduct);
                });
              },
            ),
            FutureBuilder(
                future: getStock(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text("error");
                  } else if (snapshot.hasData) {
                    var stockProducts = snapshot.data ?? [];
                    return Flexible(
                      child: ListView.separated(
                        padding: const EdgeInsets.all(mobilePadding).copyWith(top: 0),
                        shrinkWrap: true,
                        itemCount: stockProducts.length,
                        separatorBuilder: (context, index) => const Divider(),
                        itemBuilder: (context, index) {
                          return StockElement(
                            stockProduct: stockProducts[index],
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
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }
}
