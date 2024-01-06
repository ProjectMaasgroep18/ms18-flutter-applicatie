import 'package:flutter/material.dart';
import 'package:ms18_applicatie/Api/apiManager.dart';
import 'package:ms18_applicatie/Models/stock.dart';
import 'package:ms18_applicatie/Stock/widgets.dart';
import 'package:ms18_applicatie/Widgets/pageHeader.dart';
import 'package:ms18_applicatie/config.dart';
import 'package:ms18_applicatie/menu.dart';

class StockReport extends StatelessWidget {
  StockReport({Key? key}) : super(key: key);

  static Future<List<StockProduct>> getStock() async {
    List<StockProduct> stockItems = [];

    await ApiManager.get<List<dynamic>>("api/v1/Product").then((data) {
      for (Map<String, dynamic> product in data) {
        Map<String, dynamic> map = product as Map<String, dynamic>;
        StockProduct tempProduct = StockProduct(
            product: Product(
                color: Colors.blue,
                name: map["name"],
                price: 1,
                priceQuantity: 1),
                quantity: 1);
        stockItems.add(tempProduct);
      }
    });
    return stockItems;
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
                addItemsDialog(context, (stockProduct) {});
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
