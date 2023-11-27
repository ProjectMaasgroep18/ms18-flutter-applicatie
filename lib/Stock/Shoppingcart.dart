
import 'package:flutter/material.dart';
import 'package:ms18_applicatie/Models/stock.dart';
import 'package:ms18_applicatie/Stock/widgets.dart';
import 'package:ms18_applicatie/Widgets/pageHeader.dart';
import 'package:ms18_applicatie/config.dart';
import 'package:ms18_applicatie/menu.dart';

import 'package:flutter/material.dart';

// Define your models (Product and StockProduct) here

class ShoppingCart extends StatefulWidget {
  ShoppingCart({Key? key}) : super(key: key);

  @override
  _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  final List<StockProduct> shoppingCart = [];

  final List<Product> productList = [
    Product(
      priceQuantity: 1,
      color: Colors.redAccent,
      name: 'Bier',
      price: 2.43,
      icon: Icons.local_drink,
    ),
    Product(
      priceQuantity: 1,
      color: Colors.blueAccent,
      name: 'Cola',
      price: 3.13,
      icon: Icons.local_drink,
    ),
    Product(
      priceQuantity: 1,
      color: Colors.yellowAccent,
      name: 'Fanta',
      price: 6.81,
      icon: Icons.local_drink,
    ),
    Product(
      priceQuantity: 1,
      color: Colors.greenAccent,
      name: 'Wiskey',
      price: 0.43,
      icon: Icons.local_drink,
    ),
    // Voeg hier meer producten toe zoals nodig
  ];

  @override
  Widget build(BuildContext context) {
    return Menu(
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: productList.length,
              itemBuilder: (context, index) {
                return ProductListItem(
                  product: productList[index],
                  onAddToCart: () {
                    addToCart(productList[index]);
                  },
                );
              },
            ),
          ),
          ShoppingCartPopupMenu(
            shoppingCart: shoppingCart,
            removeFromCart: removeFromCart,
            updateQuantity: updateQuantity,
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
                  offset: const Offset(2, 2), // changes position of shadow
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

  ShoppingCartPopupMenu({
    required this.shoppingCart,
    required this.removeFromCart,
    required this.updateQuantity,
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
            'Totaal: \€${calculateTotalAmount().toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          SizedBox(height: 8.0),
          ElevatedButton(
            onPressed: () {
              // Implement logic to confirm the order
              print('Order confirmed!');
            },
            child: Text('Bestellen'),
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
                    Text('Aantal: ${shoppingCart[index].quantity}'),
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

class Product {
  final double priceQuantity;
  final Color color;
  final String name;
  final double price;
  final IconData icon;

  Product({
    required this.priceQuantity,
    required this.color,
    required this.name,
    required this.price,
    required this.icon,
  });
}

class StockProduct {
  final Product product;
  final int quantity;

  StockProduct({required this.product, required this.quantity});
}
