import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projeto/main.dart';

void main() {
  runApp(const Profilepage());
}

class Profilepage extends StatelessWidget {
  const Profilepage({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MAIN',
      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: ''),
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
  // Variables to store user data
  String username = 'Loading...';
  String email = 'Loading...';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getUserData(); // Fetch data when page loads
  }

  // Function to get user data from API
  Future<void> getUserData() async {
    try {
      // Get token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

      if (token == null) {
        // Redirect to login page if no token found
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => login()),
        );
        return;
      }

      // Call API with token
      final response = await http.get(
        Uri.parse('http://10.0.2.2:3000/api/users/getuser'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          username = data['user']['name'] ?? 'No name';
          email = data['user']['email'] ?? 'No email';
          isLoading = false;
        });
      } else {
        setState(() {
          username = 'Error loading user';
          isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        username = 'Error: ${error.toString()}';
        isLoading = false;
      });
    }
  }

  Widget _statItem(String title, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, color: Colors.black54)),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 80, left: 12, right: 12, bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Builder(builder: (context) {
                final screenWidth = MediaQuery.of(context).size.width;
                double diameter = screenWidth * 0.5;
                if (diameter > 300) diameter = 300;

                return Center(
                  child: Container(
                    width: diameter,
                    height: diameter,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[300],
                      image: const DecorationImage(
                        image: NetworkImage('https://via.placeholder.com/400'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              }),

              const SizedBox(height: 12),
              Text(
                isLoading ? 'Loading...' : username,
                style: const TextStyle(fontSize: 25)
              ),
              const SizedBox(height: 6),
              Text(
                email,
                style: const TextStyle(fontSize: 16, color: Colors.grey)
              ),
              const SizedBox(height: 12),
              const Divider(color: Colors.grey),
              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _statItem('Vendas', 'NaN'),
                  _statItem('Compras', 'NaN'),
                  _statItem('Posts', 'NaN'),
                ],
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _statItem('Reviews', 'NaN'),
                  _statItem('Rating', 'NaN'),
                ],
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}