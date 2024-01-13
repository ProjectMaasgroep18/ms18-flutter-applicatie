import 'package:flutter/material.dart';
import 'package:ms18_applicatie/Models/order.dart';
import 'package:ms18_applicatie/Orders/functions.dart';
import 'package:ms18_applicatie/Orders/widgets.dart';
import 'package:ms18_applicatie/Widgets/listState.dart';
import 'package:ms18_applicatie/Widgets/paddingSpacing.dart';
import 'package:ms18_applicatie/Widgets/pageHeader.dart';
import 'package:ms18_applicatie/Widgets/search.dart';
import 'package:ms18_applicatie/config.dart';
import 'package:ms18_applicatie/menu.dart';

class Orders extends StatelessWidget {
  final int? userId;

  Orders({Key? key, this.userId}) : super(key: key);

  // Used to update the results by the search term
  final ValueNotifier<String> searchNotifier = ValueNotifier('');

  @override
  Widget build(BuildContext context) {
    return Menu(
      title: const Text(
        "Order beheer",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            PageHeader(
              onSearch: (value) {
                searchNotifier.value = value;
              },
            ),
            Padding(
              padding: const EdgeInsets.all(mobilePadding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FutureBuilder(
                      future: getOrdersTotal(userId),
                      builder: (context, snapshot) {
                        final OrdersTotal? ordersTotal = snapshot.data;

                        return Row(
                          children: [
                            Text(
                                'Totaal: €${priceFormat.format(ordersTotal?.total ?? 0)}'),
                            const PaddingSpacing(),
                            Text(
                                'Aantal bestellingen: ${ordersTotal?.billCount ?? '-'}')
                          ],
                        );
                      }),
                  const PaddingSpacing(),
                  const Divider(),
                ],
              ),
            ),
            FutureBuilder(
              future: getOrders(userId),
              builder: (context, snapshot) {
                final bool isOwnPage = userId != null;

                if (snapshot.hasError) {
                  return const ListErrorIndicator();
                } else if (snapshot.hasData) {
                  var orders = snapshot.data ?? [];
                  return Flexible(
                    child: Search<Order>(
                      searchValue: searchNotifier,
                      items: orders,
                      getSearchValue: (item) =>
                          '${item.user.name} ${item.getDateString()} ${item.user.email}',
                      builder: (items) => ListView.separated(
                        padding: const EdgeInsets.all(mobilePadding)
                            .copyWith(top: 0),
                        itemCount: items.length,
                        separatorBuilder: (context, index) => const Divider(),
                        itemBuilder: (context, index) {
                          return OrderElement(
                            order: items[index],
                            isOwnPage: isOwnPage,
                          );
                        },
                      ),
                    ),
                  );
                } else {
                  return const ListLoadingIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
