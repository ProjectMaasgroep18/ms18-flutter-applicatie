import 'package:flutter/material.dart';

class Bill {
  final int id;
  final List<BillLineItem> lines;
  final String? note;
  final String name;
  final String email;


  Bill({
    required this.id,
    required this.lines,
    this.note,
    required this.name,
    required this.email,

  });

  factory Bill.fromJson(Map<String, dynamic> json) {
    return Bill(
      id: json['id'],
      lines: (json['lines'] as List<dynamic>)
          .map((lineItem) => BillLineItem.fromJson(lineItem))
          .toList(),
      note: json['note'],
      name: json['name'],
      email: json['email'],

    );
  }
}

class BillLineItem {
  final int productId;
  final int quantity;

  BillLineItem({

    required this.productId,

    required this.quantity,

  });

  factory BillLineItem.fromJson(Map<String, dynamic> json) {
    return BillLineItem(

      productId: json['productId'],

      quantity: json['quantity'],

    );
  }
}






