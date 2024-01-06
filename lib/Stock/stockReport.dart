import 'package:flutter/material.dart';
import 'package:ms18_applicatie/Models/stock.dart';
import 'package:ms18_applicatie/Stock/functions.dart';
import 'package:ms18_applicatie/Stock/widgets.dart';
import 'package:ms18_applicatie/Widgets/pageHeader.dart';
import 'package:ms18_applicatie/Widgets/search.dart';
import 'package:ms18_applicatie/config.dart';
import 'package:ms18_applicatie/menu.dart';

class StockReport extends StatelessWidget {
  StockReport({Key? key}) : super(key: key);
  static const String url = "api/v1/Product";

  // Used to update the stock amount of the products
  Set<StockProduct> changedProducts = {};
  ValueNotifier<bool> hasChangedStock = ValueNotifier(false);

  // Used to update the results by the search term
  ValueNotifier<String> searchNotifier = ValueNotifier('');


  @override
  Widget build(BuildContext context) {
    return Menu(
      title: const Text(
        "Voorraad beheer",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                PageHeader(
                  onSearch: (value) {
                    searchNotifier.value = value;
                  },
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
                        child: Search<StockProduct>(
                          searchValue: searchNotifier,
                          items: stockProducts,
                          getSearchValue: (item) => item.product.name,
                          builder: (items) => ListView.separated(
                            padding: const EdgeInsets.all(mobilePadding)
                                .copyWith(top: 0),
                            itemCount: items.length,
                            separatorBuilder: (context, index) =>
                                const Divider(),
                            itemBuilder: (context, index) {
                              return StockElement(
                                stockProduct: items[index],
                                onChange: (value) {
                                  // Checking if the product has already been changed
                                  if (!changedProducts.contains(items[index])) {
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
                            updateAllStock(changedProducts,hasChangedStock);
                          }),
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
