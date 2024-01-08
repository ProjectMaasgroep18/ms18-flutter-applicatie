import 'package:ms18_applicatie/Models/stock.dart';
import 'package:ms18_applicatie/Models/user.dart';

class Order {
  final String note;
  final double totalAmount;
  final DateTime dateTimeCreated;
  final List<StockProduct> items;
  final User user;

  String getDateString() {
    return "${dateTimeCreated.day}-${dateTimeCreated.month}-${dateTimeCreated.year}";
  }

  const Order(
      {required this.note,
      required this.totalAmount,
      required this.dateTimeCreated,
      required this.items,
      required this.user});
}

class OrdersTotal {
  final int billCount;
  final double total;
  final int productCount;

  OrdersTotal({
    required this.billCount,
    required this.productCount,
    required this.total,
  });
}
