import 'package:flutter/material.dart';
import 'package:projeto/MainPages/BottomNavBar.dart';
import 'package:projeto/signIn.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const login());
}

class login extends StatelessWidget {
  const login({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LOG IN PAGE',
      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'LOG IN'),
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
  // Create controllers for each text field
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Login function that calls the API
  Future<void> loginUser() async {
    String email = emailController.text;
    String password = passwordController.text;

    // Validate fields
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("All fields are required")),
      );
      return;
    }

    try {
      // Make API call to login
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/auth/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        // Login successful
        final data = jsonDecode(response.body);
        final token = data['token'];
        
        // Save token to local storage
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login successful!")),
        );
        
        // Navigate to home page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => NavBottomBar()),
        );
      } else {
        // Login failed
        final errorData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login failed: ${errorData['message']}")),
        );
      }
    } catch (error) {
      // Connection error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${error.toString()}")),
      );
    }
  }

  @override
  void dispose() {
    // Clean up controllers
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsetsGeometry.only(top: 80, left: 12, right: 12, bottom: 12),
        child: Column(
          children: [
            Image(image: AssetImage("images/LOGO.png"),
            width: 220,),
            const Text(
              "Welcome User",
              style: TextStyle(
                fontSize: 25,
                color: Color(0xFF609EE0)
                ),
              ),
            SizedBox(height: 20),
             TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
             TextField(
              controller: passwordController,
              keyboardType: TextInputType.text,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: "Password",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 35),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF609EE0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6)
                  )
                ),
                onPressed: (){
                  loginUser();
                },
                child: Text(
                  "Log In",
                  style: TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontSize: 18,
                  )
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Don't have an account?"),
                Text("Forgot your password?"),
              ],
            ),
            Align(
              alignment: Alignment.topLeft,
                child:  GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Signin()));
                },
                child: Text(
                  "Sign in!",
                  style: TextStyle(
                    color: Color(0xFF609EE0),
                  ),
                ),
              ),
            ),
          ],
        )
      ),
    );
  }
}
