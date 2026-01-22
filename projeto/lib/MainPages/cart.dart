import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projeto/main.dart';

void main() {
  runApp(const Cart());
}

class Cart extends StatelessWidget {
  const Cart({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MAIN',
      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'MainPage'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Variables to store cart data
  List<dynamic> cartItems = [];
  bool isLoading = true;
  double totalPrice = 0.0;

  @override
  void initState() {
    super.initState();
    getCart(); // Fetch cart when page loads
  }

  // Function to get cart from API
  Future<void> getCart() async {
    try {
      // Get token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

      if (token == null) {
        // Redirect to login if no token
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => login()),
        );
        return;
      }

      // Call API with token
      final response = await http.get(
        Uri.parse('http://localhost:3000/api/cart/get'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          cartItems = data['cart']['items'] ?? [];
          // Calculate total price
          totalPrice = 0.0;
          for (var item in cartItems) {
            double price = (item['itemId']['price'] ?? 0).toDouble();
            int quantity = item['quantity'] ?? 1;
            totalPrice += (price * quantity);
          }
          isLoading = false;
        });
      } else if (response.statusCode == 404) {
        // No cart found - empty cart
        setState(() {
          cartItems = [];
          totalPrice = 0.0;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching cart: $error");
    }
  }

  // Function to remove item from cart
  Future<void> removeItemFromCart(String itemId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

      if (token == null) return;

      final response = await http.delete(
        Uri.parse('http://localhost:3000/api/cart/remove/$itemId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // Refresh cart after removing
        getCart();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Item removed from cart")),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error removing item")),
      );
    }
  }

  // Function to handle checkout
  Future<void> checkout() async {
    // Show confirmation dialog
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Checkout'),
          content: Text('Do you want to proceed with checkout?\nTotal: ${totalPrice.toStringAsFixed(2)}€'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF609EE0),
              ),
              child: Text('Confirm', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

      if (token == null) return;

      // Delete the entire cart after checkout
      final response = await http.delete(
        Uri.parse('http://localhost:3000/api/cart/delete'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Checkout successful! Order placed.")),
        );
        // Refresh cart to show empty state
        setState(() {
          cartItems = [];
          totalPrice = 0.0;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Checkout failed")),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error during checkout")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
        ? Center(child: CircularProgressIndicator())
        : Padding(
            padding: EdgeInsets.only(top: 60, left: 12, right: 12, bottom: 12),
            child: Column(
              children: [
                // Cart items list
                Expanded(
                  child: cartItems.isEmpty
                    ? Center(
                        child: Text(
                          'Your cart is empty',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final item = cartItems[index];
                          final itemData = item['itemId'];
                          
                          return Container(
                            margin: EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color(0xFF609EE0),
                                width: 3
                              ),
                              borderRadius: BorderRadius.circular(6)
                            ),
                            child: Row(
                              children: [
                                Container(
                                  child: Image(
                                    image: AssetImage("images/test.jpg"),
                                    width: 100
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          itemData['name'] ?? 'Item Name',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Quantity: ${item['quantity'] ?? 1}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          "${itemData['price'] ?? 0}€",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Color(0xFF609EE0),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    removeItemFromCart(itemData['_id']);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                ),
                
                SizedBox(height: 4),
                Divider(color: Colors.grey),
                SizedBox(height: 4),
                
                // Total price
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Total: ${totalPrice.toStringAsFixed(2)}€',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF609EE0)
                    ),
                  ),
                ),
                
                SizedBox(height: 4),
                Divider(color: Colors.grey),
                SizedBox(height: 4),
                
                // Checkout button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: cartItems.isEmpty ? null : checkout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF609EE0),
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)
                      )
                    ),
                    child: Text(
                      'Check out',
                      style: TextStyle(color: Colors.white)
                    ),
                  ),
                )
              ],
            ),
          ),
    );
  }
}
