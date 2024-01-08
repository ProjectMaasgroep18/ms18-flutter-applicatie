import 'package:ms18_applicatie/Api/apiManager.dart';
import 'package:ms18_applicatie/Models/order.dart';
import 'package:ms18_applicatie/Stock/functions.dart';
import 'package:ms18_applicatie/Users/functions.dart';
import 'package:ms18_applicatie/config.dart';

Future<List<Order>> getOrders(int? userId) async {
  List<Order> orderItems = [];
  String apiUrl = 'api/v1/';
  if (userId != null) {
    apiUrl += "User/$userId/";
  }
  apiUrl += "Bill";

  await ApiManager.get<List<dynamic>>(apiUrl, await getHeaders()).then((data) {
    for (Map<String, dynamic> order in data) {
      Map<String, dynamic> map = order;

      DateTime createDate =
          DateTime.tryParse(map['dateTimeCreated']) ?? DateTime.now();
      Order tempOrder = Order(
          note: map['note'] ?? '',
          totalAmount: double.tryParse((map['totalAmount'] ?? '0').toString()) ?? 0,
          dateTimeCreated: createDate,
          items: castListDynamicToStockProducts(map['lines'] as List<dynamic>),
          user: castMapToUser(map['memberCreated']));
      orderItems.add(tempOrder);
    }
  });
  return orderItems;
}

Future<OrdersTotal> getOrdersTotal(int? userId) async {
  String apiUrl = 'api/v1/';
  if (userId != null) {
    apiUrl += "User/$userId/BillTotal";
  } else {
    apiUrl += "Bill/Total";
  }

  return await ApiManager.get(apiUrl, await getHeaders()).then((data) {
    return OrdersTotal(
      billCount: data['billCount'] ?? 0,
      productCount: data['productQuantity'] ?? 0,
      total: data['totalAmount'] ?? 0,
    );
  });
}
