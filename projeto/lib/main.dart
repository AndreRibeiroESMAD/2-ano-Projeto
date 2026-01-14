import 'package:flutter/material.dart';
import 'package:projeto/MainPage.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF609EE0),
        title: Text(widget.title),
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.all(12),
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
            TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                label: Text("Email"),
              ),
            ),
            TextField(
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              decoration: const InputDecoration(
                label: Text("Password"),
              ),
            ),
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
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Mainpage()));
                  },
                  child: Text(
                    "Log In",
                    style: TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontSize: 18,
                    )
                  ),
                ),
            )
          ],
        )
      ),
    );
  }
}
