import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const itempage(itemId: ''));
}

class itempage extends StatefulWidget {
  final String itemId;
  
  const itempage({super.key, required this.itemId});

  @override
  State<itempage> createState() => _itempageState();
}

class _itempageState extends State<itempage> {
  // Variables to store item data
  String itemName = 'Loading...';
  String itemPrice = '';
  String itemDescription = '';
  bool isLoading = true;
  bool isAddingToCart = false;

  @override
  void initState() {
    super.initState();
    getItemDetails(); // Fetch item details when page loads
  }

  // Function to get specific item from API
  Future<void> getItemDetails() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:3000/api/items/get/${widget.itemId}'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          itemName = data['item']['name'] ?? 'No name';
          itemPrice = "${data['item']['price'] ?? 0}€";
          itemDescription = data['item']['description'] ?? 'No description';
          isLoading = false;
        });
      } else {
        setState(() {
          itemName = 'Error loading item';
          isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        itemName = 'Error: ${error.toString()}';
        isLoading = false;
      });
    }
  }

  // Function to add item to cart
  Future<void> addToCart() async {
    setState(() {
      isAddingToCart = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please login first")),
        );
        setState(() {
          isAddingToCart = false;
        });
        return;
      }

      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/api/cart/add'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, dynamic>{
          'itemId': widget.itemId,
          'quantity': 1,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Added to cart!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to add to cart")),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${error.toString()}")),
      );
    } finally {
      setState(() {
        isAddingToCart = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF609EE0),
        title: Text(isLoading ? 'Loading...' : itemName),
        toolbarHeight: 80,
        actions: [
          Align(
            alignment: Alignment.bottomRight,
            child: IconButton(
              icon: Icon(Icons.notifications, color: Colors.white),
              iconSize: 35,
              onPressed: () {
              },
            ),
          )
        ],
      ),
      body: isLoading
        ? Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Builder(builder: (context) {
                    final screenWidth = MediaQuery.of(context).size.width;
                    double imageWidth = screenWidth;
                    final imageHeight = imageWidth*0.6;

                    return Center(
                      child: Container(
                        width: imageWidth,
                        height: imageHeight,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey[300],
                          image: const DecorationImage(
                            image: NetworkImage('https://via.placeholder.com/380x270'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 16),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(itemName, style: TextStyle(fontSize: 20, color: Colors.black)),
                            SizedBox(height: 4),
                            Text(itemPrice, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF609EE0))),
                          ],
                        ),
                      ),

                  const SizedBox(width: 12),

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage('https://via.placeholder.com/80'),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.star, color: Colors.yellow),
                          SizedBox(width: 4),
                          Text('NaN', style: TextStyle(fontSize: 15)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: isAddingToCart ? null : addToCart,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF609EE0),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)
                        )
                      ),
                      
                      child: isAddingToCart
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Adicionar', style: TextStyle(color: Colors.white)),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red, width: 3),
                        foregroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)
                        )
                      ),
                      child: const Text('Reportar', style: TextStyle(color: Colors.red)),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Description section
              Text(
                'Description:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                itemDescription,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}