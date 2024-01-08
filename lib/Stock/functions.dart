import 'dart:math';
import 'package:flutter/material.dart';
import 'package:ms18_applicatie/Api/apiManager.dart';
import 'package:ms18_applicatie/Models/stock.dart';
import 'package:ms18_applicatie/Stock/stockReport.dart';
import 'package:ms18_applicatie/Widgets/popups.dart';
import 'package:ms18_applicatie/Widgets/stringToColor.dart';
import 'package:ms18_applicatie/config.dart';

String colorToString(Color color) {
  return "#${color.value.toRadixString(16).substring(2)}";
}

void reploadPage() {
  navigatorKey.currentState!.pushReplacement(
      MaterialPageRoute(builder: ((context) => StockReport())));
}

Future<List<StockProduct>> getStock() async {
  List<StockProduct> stockItems = [];

  await ApiManager.get<List<dynamic>>(StockReport.url, await getHeaders())
      .then((data) {
    stockItems = castListDynamicToStockProducts(data);
  });
  return stockItems;
}

StockProduct castMapToStockProduct(Map<String, dynamic> apiStockProduct) {
  //Parsing the color from the db
  StockProduct stockProduct = StockProduct(
    product: Product(
        color: Color(stringToColor(apiStockProduct['color'])),
        name: apiStockProduct["name"] ?? '',
        price:
            double.tryParse((apiStockProduct["price"] ?? '').toString()) ?? 0,
        icon: apiStockProduct["icon"] ?? '',
        id: apiStockProduct['id'] ?? ''),
    quantity: apiStockProduct['stock'] ?? apiStockProduct['quantity'] ?? 0,
  );

  return stockProduct;
}

List<StockProduct> castListDynamicToStockProducts(List<dynamic> data) {
  List<StockProduct> stockItems = [];
  for (Map<String, dynamic> product in data) {
    Map<String, dynamic> map = product;

    stockItems.add(castMapToStockProduct(map));
  }
  return stockItems;
}

Map<String, dynamic> getBody(StockProduct stockProduct, [bool hasId = false]) {
  final Product product = stockProduct.product;

  return {
    if (hasId) ...{'id': product.id},
    'name': product.name,
    'price': product.price,
    'icon': product.icon,
    'stock': stockProduct.quantity,
    'color': colorToString(product.color),
    'priceQuantity': 0
  };
}

Future addProduct(StockProduct stockProduct) async {
  stockProduct.product.color =
      Colors.primaries[Random().nextInt(Colors.primaries.length)];

  PopupAndLoading.showLoading();
  await ApiManager.post(
          StockReport.url, getBody(stockProduct), await getHeaders())
      .then((value) {
    PopupAndLoading.showSuccess("Product toevoegen gelukt");
    reploadPage();
  }).catchError((error) {
    PopupAndLoading.showError("Product toevoegen mislukt");
  });
  PopupAndLoading.endLoading();
}

Future updateProduct(StockProduct stockProduct) async {
  PopupAndLoading.showLoading();
  await ApiManager.put("${StockReport.url}/${stockProduct.product.id}",
          getBody(stockProduct, true), await getHeaders())
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
  await ApiManager.delete("${StockReport.url}/$productId", await getHeaders())
      .then((value) {
    PopupAndLoading.showSuccess("Product verwijderen gelukt");
    reploadPage();
  }).catchError((error) {
    PopupAndLoading.showError("Product verwijderen mislukt");
  });
  PopupAndLoading.endLoading();
}

Future updateAllStock(Set<StockProduct> changedProducts,
    ValueNotifier<bool> hasChangedStock) async {
  PopupAndLoading.showLoading();
  // Looping though all the products and updating each of their stock
  await Future.any([
    for (StockProduct changedStock in changedProducts) updateStock(changedStock)
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
  await ApiManager.put("${StockReport.url}/${stockProduct.product.id}/Stock",
      body, await getHeaders());
}
