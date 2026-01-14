import 'package:flutter/material.dart';
import 'package:projeto/main.dart';
import 'package:projeto/home.dart';
import 'package:projeto/profile.dart';
import 'package:projeto/search.dart';
import 'package:projeto/add.dart';
import 'package:projeto/cart.dart';

void main() {
  runApp(const NavBottomBar());
}

class NavBottomBar extends StatelessWidget {
  const NavBottomBar({super.key});

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
  int _selectedindex = 0;

  void _navbottombar(int index){
    setState(() {
      _selectedindex = index;
    });
  }

  final List<Widget> Pages = [
    home(),
    search(),
    addItems(),
    Cart(),
    Profilepage()
  ];

  BottomNavigationBarItem _navitem(
    IconData icon,)
    { return BottomNavigationBarItem(
      label: '',
      icon: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color:Color(0xFF609EE0),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Pages[_selectedindex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF609EE0),
        type: BottomNavigationBarType.fixed,
        iconSize: 40,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: _navbottombar,
        items: [
          _navitem(Icons.home),
          _navitem(Icons.search),
          _navitem(Icons.add),
          _navitem(Icons.shopping_cart),
          _navitem(Icons.person),
        ],
        ),
      );
  }
}
