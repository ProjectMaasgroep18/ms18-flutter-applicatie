// import 'dart:convert';
// import 'package:http/http.dart' as http;
//
// // ... Other imports
//
// class _ShoppingCartState extends State<ShoppingCart> {
//   final List<StockProduct> shoppingCart = [];
//   final List<Order> orderHistory = [];
//
//   @override
//   Widget build(BuildContext context) {
//     return Menu(
//       child: Column(
//         children: [
//           Expanded(
//             child: FutureBuilder(
//               future: getStock(),
//               builder: (context, snapshot) {
//                 // ... (Same as your existing code)
//               },
//             ),
//           ),
//           ShoppingCartPopupMenu(
//             shoppingCart: shoppingCart,
//             removeFromCart: removeFromCart,
//             updateQuantity: updateQuantity,
//             clearCartAndAddToHistory: clearCartAndAddToHistory,
//             orderHistory: orderHistory,
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ... (Other methods)
//
//   void clearCartAndAddToHistory() async {
//     if (shoppingCart.isNotEmpty) {
//       Order order = Order(
//         orderedProducts: List.from(shoppingCart),
//         totalAmount: calculateTotalAmount(),
//         orderDate: DateTime.now(),
//       );
//
//       // Convert the order object to the required format
//       Map<String, dynamic> orderMap = {
//         "lines": order.orderedProducts
//             .map((product) => {
//           "productId": product.product.id, // Assuming there is an 'id' property in your Product class
//           "quantity": product.quantity,
//         })
//             .toList(),
//         "note": "", // Add a note if needed
//         "name": "", // Add the customer's name
//         "email": "", // Add the customer's email
//       };
//
//       // Convert the orderMap to a JSON string
//       String orderJson = jsonEncode(orderMap);
//
//       // Make the API call to send the order to the database
//       try {
//         var response = await http.post(
//           Uri.parse('YOUR_API_ENDPOINT'), // Replace with your actual API endpoint
//           headers: {'Content-Type': 'application/json'},
//           body: orderJson,
//         );
//
//         if (response.statusCode == 200) {
//           // Successfully sent the order to the database
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text('Order confirmed and sent to the database!'),
//             ),
//           );
//
//           // Clear the shopping cart and add to order history locally
//           setState(() {
//             orderHistory.insert(0, order);
//             shoppingCart.clear();
//           });
//         } else {
//           // Failed to send the order to the database
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text('Failed to send the order to the database. Please try again.'),
//             ),
//           );
//         }
//       } catch (error) {
//         print('Error: $error');
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Error occurred while sending the order.'),
//           ),
//         );
//       }
//     }
//   }
//
// // ... (Other methods)
// }
