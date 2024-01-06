import 'dart:convert';
import 'package:http/http.dart' as http;

class Product {
  final String name;
  final String color;
  final String icon;
  final int price;
  final int priceQuantity;
  final int stock;

  Product({
    required this.name,
    required this.color,
    required this.icon,
    required this.price,
    required this.priceQuantity,
    required this.stock,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'],
      color: json['color'],
      icon: json['icon'],
      price: json['price'],
      priceQuantity: json['priceQuantity'],
      stock: json['stock'],
    );
  }
}

Future<Product> getProductData() async {
  final String apiUrl = "/api/v1/Product";

  // Replace the following data with your actual data
  final Map<String, dynamic> requestBody = {
    "name": "exampleName",
    "color": "exampleColor",
    "icon": "exampleIcon",
    "price": 10,
    "priceQuantity": 1,
    "stock": 100,
  };

  final response = await http.post(
    Uri.parse(apiUrl),
    body: jsonEncode(requestBody),
    headers: {
      'Content-Type': 'application/json',
      // Add any additional headers if required
    },
  );

  if (response.statusCode == 200) {
    // If the server returns a 200 OK response, parse the JSON
    return Product.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response, throw an exception.
    throw Exception('Failed to load product data');
  }
}
