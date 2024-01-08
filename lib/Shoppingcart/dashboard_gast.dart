import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:ms18_applicatie/Api/apiManager.dart';
import 'package:ms18_applicatie/Models/stock.dart';
import 'package:ms18_applicatie/Stock/widgets.dart';
import 'package:ms18_applicatie/Widgets/pageHeader.dart';
import 'package:ms18_applicatie/config.dart';
import 'package:ms18_applicatie/menu.dart';

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

class ProductApiManager {
  static Future<Product> getProductData() async {
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

    try {
      final response = await ApiManager.post(apiUrl,);
      return Product.fromJson(response);
    } catch (e) {
      // Handle exceptions
      throw Exception('Failed to load product data: $e');
    }
  }
}

class StatisticsGrid extends StatelessWidget {
  const StatisticsGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ProductApiManager.getProductData(),
      builder: (context, AsyncSnapshot<Product> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Loading state
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Error state
          return Text('Error: ${snapshot.error}');
        } else {
          // Data loaded successfully
          final product = snapshot.data!;

          return GridView.builder(
            itemCount: 1, // Display only one product for simplicity
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 15,
                childAspectRatio: 1,
                crossAxisCount: 2,
                mainAxisSpacing: 20),
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.lightBlue,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Product Name: ${product.name}',
                        maxLines: 2,
                        softWrap: true,
                        style: const TextStyle(
                          fontSize: 17,
                          color: Color(0xff8EA3B7),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 40,
                            width: 7,
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(15)),
                          ),
                          Text(
                            'Price: \$${product.price}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff006ED3),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      body: StatisticsGrid(),
    ),
  ));
}
