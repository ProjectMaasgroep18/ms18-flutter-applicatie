import 'package:flutter/material.dart';
import 'package:ms18_applicatie/Models/stock.dart';
import 'package:ms18_applicatie/Orders/orders.dart';
import 'package:ms18_applicatie/Stock/widgets.dart';
import 'package:ms18_applicatie/Widgets/buttons.dart';
import 'package:ms18_applicatie/Widgets/listState.dart';
import 'package:ms18_applicatie/Widgets/popups.dart';
import 'package:ms18_applicatie/config.dart';
import 'package:ms18_applicatie/globals.dart';
import 'package:ms18_applicatie/menu.dart';
import 'package:ms18_applicatie/Stock/functions.dart';
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
                  return const ListErrorIndicator();
                } else if (!snapshot.hasData) {
                  return const ListLoadingIndicator();
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
      PopupAndLoading.showLoading();

      Order order = Order(
        orderedProducts: List.from(shoppingCart),
        totalAmount: calculateTotalAmount(),
        orderDate: DateTime.now(),
      );
      await ApiManager.post(
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
      ).then((value) {
        PopupAndLoading.showSuccess('Bestellen gelukt');

        setState(() {
          shoppingCart.clear();
        });
      }).catchError((error) {
        PopupAndLoading.showError('Bestellen mislukt');
      });

      PopupAndLoading.endLoading();
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

  const ProductListItem({required this.product, required this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(product.name),
      subtitle: Text('Prijs: €${priceFormat.format(product.price)}'),
      leading: Stack(clipBehavior: Clip.none, children: [
        Container(
          width: 45,
          height: 45,
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
          child: Icon(
            productIcons[product.icon],
            color: Colors.white,
          ),
        ),
      ]),
      trailing: SizedBox(
        width: 100,
        child: Button(
          onTap: onAddToCart,
          icon: Icons.add,
        ),
      ),
    );
  }
}

class ShoppingCartPopupMenu extends StatelessWidget {
  final List<StockProduct> shoppingCart;
  final Function(StockProduct) removeFromCart;
  final Function(StockProduct, int) updateQuantity;
  final Function clearCartAndAddToHistory;
  final List<dynamic> orderHistory;

  const ShoppingCartPopupMenu({
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
      padding: const EdgeInsets.all(mobilePadding),
      color: Colors.grey[300],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total: €${priceFormat.format(calculateTotalAmount())}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          const SizedBox(height: 8.0),
          Button(
            isFullWidth: false,
            onTap: () async {
              await clearCartAndAddToHistory();
            },
            text: 'Bestellen',
            icon: Icons.payment,
          ),
          const SizedBox(height: 8.0),
          Button(
            isFullWidth: false,
            onTap: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Orders(
                    userId: globalLoggedInUserValues?.id,
                  ),
                ),
              );
            },
            text: 'Bestellingen bekijken',
            icon: Icons.receipt_long,
          ),
          const SizedBox(height: 8.0),
          const Text('Winkelwagen'),
          ListView.builder(
            shrinkWrap: true,
            itemCount: shoppingCart.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(shoppingCart[index].product.name),
                subtitle: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        updateQuantity(shoppingCart[index], -1);
                      },
                    ),
                    Text('Aantal: ${shoppingCart[index].quantity}'),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        updateQuantity(shoppingCart[index], 1);
                      },
                    ),
                  ],
                ),
                trailing: Text(
                  '€${priceFormat.format(shoppingCart[index].product.price * shoppingCart[index].quantity)}',
                  style: const TextStyle(fontSize: 15),
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
