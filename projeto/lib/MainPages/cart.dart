import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top:60, left: 12, right: 12, bottom: 12),
        child: Column(
          children: [
            Expanded(child: Container()),
            SizedBox(height: 4),
            Divider(color: Colors.grey),
            SizedBox(height: 4),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('NaN'+"€",
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
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF609EE0),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)
                  )
                ),
                child: Text('Check out',
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
