import 'package:flutter/material.dart';
import 'package:projeto/MainPages/home.dart';
import 'package:projeto/MainPages/profile.dart';
import 'package:projeto/MainPages/search.dart';
import 'package:projeto/MainPages/add.dart';
import 'package:projeto/MainPages/cart.dart';

class NavBottomBar extends StatefulWidget {
  final VoidCallback onLogout;

  const NavBottomBar({required this.onLogout});

  @override
  State<NavBottomBar> createState() => _NavBottomBarState();
}

class _NavBottomBarState extends State<NavBottomBar> {
  int _selectedindex = 0;

  void _navbottombar(int index){
    setState(() {
      _selectedindex = index;
    });
  }

  List<Widget> get Pages => [
    home(),
    search(),
    addItems(),
    Cart(),
    Profilepage(onLogout: widget.onLogout)
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
