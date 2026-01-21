import 'package:flutter/material.dart';
import 'package:projeto/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const Signin());
}

class Signin extends StatelessWidget {
  const Signin({super.key});

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
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // Register function that calls the API
  Future<void> registerUser() async {
    String email = emailController.text;
    String username = usernameController.text;
    String password = passwordController.text;

    // Validate fields
    if (email.isEmpty || username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("All fields are required")),
      );
      return;
    }

    try {
      // Make API call to register
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/auth/register'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        // Registration successful
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Registration successful!")),
        );
        
        // Navigate to login page (main.dart)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => login()),
        );
      } else {
        // Registration failed
        final errorData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Registration failed: ${errorData['message']}")),
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
    usernameController.dispose();
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
              "Welcome New User",
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
              controller: usernameController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                hintText: "Username",
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
            Container(
              width: double.infinity,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF609EE0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6)
                  )
                ),
                onPressed: (){
                  registerUser();
                },
                child: Text(
                  "Sign In",
                  style: TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontSize: 18,
                  )
                ),
              ),
            ),
            SizedBox(height: 10),
            Column(
              children: [
                Align(
                    alignment: Alignment.topLeft,
                    child: Text("Already have an account?"),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>login()));
                    },
                    child: Text(
                      "Log in!",
                      style: TextStyle(
                        color: Color(0xFF609EE0),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        )
      ),
    );
  }
}
