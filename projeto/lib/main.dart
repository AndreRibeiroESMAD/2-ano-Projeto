import 'package:flutter/material.dart';
import 'package:projeto/MainPages/BottomNavBar.dart';
import 'package:projeto/signIn.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool isLoggedIn = false;
  bool isChecking = true;

  @override
  void initState() {
    super.initState();
    checkAuth();
  }

  Future<void> checkAuth() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    setState(() {
      isLoggedIn = token != null;
      isChecking = false;
    });
  }

  void login() {
    setState(() {
      isLoggedIn = true;
    });
  }

  void logout() {
    setState(() {
      isLoggedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isChecking) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return isLoggedIn ? NavBottomBar(onLogout: logout) : LoginPage(onLogin: login);
  }
}

class LoginPage extends StatefulWidget {
  final VoidCallback onLogin;

  const LoginPage({required this.onLogin});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
        Uri.parse('http://10.0.2.2:3000/api/auth/login'),
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
        
        // Notify parent to switch to main app
        widget.onLogin();
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
        padding: EdgeInsets.only(top: 80, left: 12, right: 12, bottom: 12),
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
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Signin()));
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
