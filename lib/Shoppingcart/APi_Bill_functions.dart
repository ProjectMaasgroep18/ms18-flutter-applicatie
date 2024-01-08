import 'dart:js';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ms18_applicatie/Api/apiManager.dart';
import 'package:ms18_applicatie/Models/bill.dart'; // Assuming you have a Bill model
import 'package:ms18_applicatie/Widgets/popups.dart';
import 'package:ms18_applicatie/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

String colorToString(Color color) {
  return "#${color.value.toRadixString(16).substring(2)}";
}

void reploadPage(BuildContext context) {
  // Replace with your actual page route or logic for page reload
  Navigator.of(context).popUntil((route) => route.isFirst);
}

Future<Map<String, String>> getHeaders() async {
  final prefs = await SharedPreferences.getInstance();
  final res = prefs.getString('token');
  String bearerToken = "Bearer $res";
  return {
    ...apiHeaders,
    ...{"Authorization": bearerToken}
  };
}

Future<List<BillLineItem>> getBillLines() async {
  List<BillLineItem> billLines = [];

  // Constructing the full API URL
  String fullUrl = apiUrl + 'api/v1/Bill';

  await ApiManager.get<List<dynamic>>(fullUrl, await getHeaders()).then((data) {
    for (Map<String, dynamic> lineItem in data) {
      BillLineItem tempLineItem = BillLineItem(
        id: lineItem['id'] ?? 0, // Make sure 'id' is provided in your API response
        billId: lineItem['billId'] ?? 0, // Make sure 'billId' is provided in your API response
        productId: lineItem['productId'] ?? 0,
        name: lineItem['name'] ?? '',
        price: lineItem['price'] ?? 0.0,
        quantity: lineItem['quantity'] ?? 0,
        amount: lineItem['amount'] ?? 0.0,
      );
      billLines.add(tempLineItem);
    }
  });
  return billLines;
}


Map<String, dynamic> getBillBody(Bill bill) {
  return {
    'lines': [
      for (BillLineItem lineItem in bill.lines) {'productId': lineItem.productId, 'quantity': lineItem.quantity}
    ],
    'note': bill.note,
    'name': bill.name,
    'email': bill.email,
  };
}

Future addBill(Bill bill) async {
  PopupAndLoading.showLoading();
  // Constructing the full API URL
  String fullUrl = apiUrl + 'api/v1/Bill';

  await ApiManager.post(fullUrl, getBillBody(bill), await getHeaders()).then((value) {
    PopupAndLoading.showSuccess("Order toevoegen gelukt");
    reploadPage(context as BuildContext);
  }).catchError((error) {
    PopupAndLoading.showError("Order toevoegen mislukt");
  });
  PopupAndLoading.endLoading();
}

Future updateBill(Bill bill) async {
  PopupAndLoading.showLoading();
  // Constructing the full API URL
  String fullUrl = apiUrl + "${'api/v1/Bill'}/${bill.id}";

  await ApiManager.put(fullUrl, getBillBody(bill), await getHeaders()).then((value) {
    PopupAndLoading.showSuccess("Order wijzigen gelukt");
    reploadPage(context as BuildContext);
  }).catchError((error) {
    PopupAndLoading.showError("Order wijzigen mislukt");
  });

  PopupAndLoading.endLoading();
}

Future deleteBill(int billId) async {
  PopupAndLoading.showLoading();
  // Constructing the full API URL
  String fullUrl = apiUrl + "${'api/v1/Bill'}/$billId";

  await ApiManager.delete(fullUrl, await getHeaders()).then((value) {
    PopupAndLoading.showSuccess("Order verwijderen gelukt");
    reploadPage(context as BuildContext);
  }).catchError((error) {
    PopupAndLoading.showError("Order verwijderen mislukt");
  });
  PopupAndLoading.endLoading();
}
