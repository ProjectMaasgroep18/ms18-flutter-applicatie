import 'package:flutter/material.dart';

class Product {
  final String name;
  final double price;
  final int priceQuantity;
  final Color color;

  Product({
    required this.color,
    required this.name,
    required this.price,
    required this.priceQuantity,
  });
}

class StockProduct {
  final Product product;
  StockStatus get status =>
      quantity == 0 ? StockStatus.Empty : StockStatus.Good;
  final int quantity;

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
