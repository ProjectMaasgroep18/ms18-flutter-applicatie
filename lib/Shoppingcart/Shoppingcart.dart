import 'package:flutter/material.dart';
import 'package:ms18_applicatie/Models/stock.dart';
import 'package:ms18_applicatie/Stock/stockReport.dart';
import 'package:ms18_applicatie/Stock/widgets.dart';
import 'package:ms18_applicatie/Widgets/pageHeader.dart';
import 'package:ms18_applicatie/config.dart';
import 'package:ms18_applicatie/globals.dart';
import 'package:ms18_applicatie/menu.dart';
import 'package:ms18_applicatie/Stock/functions.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Api/apiManager.dart';


class ShoppingCart extends StatefulWidget {
  ShoppingCart({Key? key}) : super(key: key);

  @override
  _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  final List<StockProduct> shoppingCart = [];
  final List<Order> orderHistory = [];

  @override
  Widget build(BuildContext context) {
    return Menu(
      child: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: getStock(),
              builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return const Text("Error loading data");
                                    } else if (!snapshot.hasData) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else {
                                      var productList = snapshot.data!;
                                      return ListView.builder(
                                        itemCount: productList.length,
                                        itemBuilder: (context, index) {
                                          StockProduct currentProduct = productList[index];
                                          return ProductListItem(
                                            product: currentProduct.product,
                                            onAddToCart: () {
                                              addToCart(currentProduct.product);
                                            },
                                          );
                                        },
                                      );
                                    }

              },
            ),
          ),
          ShoppingCartPopupMenu(
            shoppingCart: shoppingCart,
            removeFromCart: removeFromCart,
            updateQuantity: updateQuantity,
            clearCartAndAddToHistory: clearCartAndAddToHistory,
            orderHistory: orderHistory,
          ),
        ],
      ),
    );
  }

  void addToCart(Product product) {
    var existingIndex = shoppingCart.indexWhere(
          (item) => item.product.name == product.name,
    );

    if (existingIndex != -1) {
      setState(() {
        shoppingCart[existingIndex] = StockProduct(
          product: product,
          quantity: shoppingCart[existingIndex].quantity + 1,
        );
      });
    } else {
      setState(() {
        shoppingCart.add(
          StockProduct(
            product: product,
            quantity: 1,
          ),
        );
      });
    }
  }

  void removeFromCart(StockProduct product) {
    setState(() {
      shoppingCart.remove(product);
    });
  }

  void updateQuantity(StockProduct product, int change) {
    setState(() {
      int newQuantity = product.quantity + change;
      if (newQuantity > 0) {
        shoppingCart[shoppingCart.indexOf(product)] =
            StockProduct(product: product.product, quantity: newQuantity);
      } else {
        removeFromCart(product);
      }
    });
  }

  void clearCartAndAddToHistory() async {
    if (shoppingCart.isNotEmpty) {
      Order order = Order(
        orderedProducts: List.from(shoppingCart),
        totalAmount: calculateTotalAmount(),
        orderDate: DateTime.now(),
      );
      var res = await ApiManager.post(
        "api/v1/Bill",
        {
          "lines": order.orderedProducts
              .map((product) => {
            "productId": product.product.id,
            "quantity": product.quantity,
          })
              .toList(),
          "note": "", // Add a note if needed
          "name": globalLoggedInUserValues?.name,
          "email": globalLoggedInUserValues?.email,
        },
        {
          "Authorization": "Bearer ${await getToken()}",
          'Content-Type': 'application/json',
        },
      );
      print(res);
      // Clear the shopping cart and update the UI
      setState(() {
        shoppingCart.clear();
      });
    }
  }

  double calculateTotalAmount() {
    double totalAmount = 0.0;
    for (var item in shoppingCart) {
      totalAmount += item.product.price * item.quantity;
    }
    return totalAmount;
  }
}

class ProductListItem extends StatelessWidget {
  final Product product;
  final VoidCallback onAddToCart;

  ProductListItem({required this.product, required this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(product.name),
      subtitle: Text('Price: \€${product.price.toStringAsFixed(2)}'),
      leading: SizedBox(
        width: 45,
        height: 45,
        child: Stack(clipBehavior: Clip.none, children: [
          Container(
            decoration: BoxDecoration(
              color: product.color,
              borderRadius: BorderRadius.circular(
                borderRadius,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
          ),
        ]),
      ),
      trailing: ElevatedButton(
        onPressed: onAddToCart,
        child: Icon(Icons.add),
      ),
    );
  }
}

class ShoppingCartPopupMenu extends StatelessWidget {
  final List<StockProduct> shoppingCart;
  final Function(StockProduct) removeFromCart;
  final Function(StockProduct, int) updateQuantity;
  final VoidCallback clearCartAndAddToHistory;
  final List<Order> orderHistory;

  ShoppingCartPopupMenu({
    required this.shoppingCart,
    required this.removeFromCart,
    required this.updateQuantity,
    required this.clearCartAndAddToHistory,
    required this.orderHistory,
  });

  double calculateTotalAmount() {
    double totalAmount = 0.0;
    for (var item in shoppingCart) {
      totalAmount += item.product.price * item.quantity;
    }
    return totalAmount;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      color: Colors.grey[300],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Total: \€${calculateTotalAmount().toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          SizedBox(height: 8.0),
          ElevatedButton(
            onPressed: () {
              print('Order confirmed!');
              clearCartAndAddToHistory();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Order confirmed!'),
                ),
              );
            },
            child: Text('Bestellen'),
          ),
          SizedBox(height: 8.0),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderHistoryScreen(orderHistory: orderHistory),
                ),
              );
            },
            child: Text('Bestelhistorie'),
          ),
          SizedBox(height: 8.0),
          Text('Winkelwagen'),
          ListView.builder(
            shrinkWrap: true,
            itemCount: shoppingCart.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(shoppingCart[index].product.name),
                subtitle: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        updateQuantity(shoppingCart[index], -1);
                      },
                    ),
                    Text('Quantity: ${shoppingCart[index].quantity}'),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        updateQuantity(shoppingCart[index], 1);
                      },
                    ),
                  ],
                ),
                trailing: Text(
                  '\€${(shoppingCart[index].product.price * shoppingCart[index].quantity).toStringAsFixed(2)}',
                ),
                onTap: () {
                  removeFromCart(shoppingCart[index]);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class OrderHistoryScreen extends StatelessWidget {
  final List<Order> orderHistory;

  OrderHistoryScreen({required this.orderHistory});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bestelhistorie'),
      ),
      body: ListView.builder(
        itemCount: orderHistory.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Bestelling ${index + 1}'),
            subtitle: Text('Totaal: \€${orderHistory[index].totalAmount.toStringAsFixed(2)}'),
            onTap: () {
              // Navigeer naar het gedetailleerde scherm voor deze bestelling
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailedOrderScreen(order: orderHistory[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class DetailedOrderScreen extends StatelessWidget {
  final Order order;

  DetailedOrderScreen({required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bestelling Details'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Besteldatum: ${order.orderDate.toString()}'),
          SizedBox(height: 8.0),
          Text('Bestelde producten:'),
          ListView.builder(
            shrinkWrap: true,
            itemCount: order.orderedProducts.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(order.orderedProducts[index].product.name),
                subtitle: Text('Aantal: ${order.orderedProducts[index].quantity}'),
              );
            },
          ),
          SizedBox(height: 8.0),
          Text('Totaalbedrag: \€${order.totalAmount.toStringAsFixed(2)}'),
          Text('Betaald'),
        ],
      ),
    );
  }
}



class Order {
  final List<StockProduct> orderedProducts;
  final double totalAmount;
  final DateTime orderDate;

  Order({
    required this.orderedProducts,
    required this.totalAmount,
    required this.orderDate,
  });
}



// _future = ApiManager.get<List<dynamic>>("api/v1/user/Bill");