import 'package:flutter/material.dart';

class Product {
  int id;
  String name;
  double price;
  Color color;
  String icon;

  Product({
    required this.id,
    required this.color,
    required this.name,
    required this.price,
    required this.icon
  });
}

class StockProduct {
  Product product;
  StockStatus get status =>
      quantity == 0 ? StockStatus.Empty : StockStatus.Good;
  int quantity;

  StockProduct({
    required this.product,
    required this.quantity,
  });
}

enum StockStatus {
  Good,
  Danger,
  Empty,
  Offline,
}
