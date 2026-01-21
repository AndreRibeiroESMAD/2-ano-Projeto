import 'package:flutter/material.dart';
import 'package:projeto/otherPages/itemprofile.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const home());
}

class home extends StatelessWidget {
  const home({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MAIN',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: '')
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
  // Variables to store items data
  List<dynamic> items = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getItems(); // Fetch items when page loads
  }

  // Function to get all items from API
  Future<void> getItems() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/api/items/get'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          items = data['items'];
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
      print("Error fetching items: $error");
    }
  }

  Widget _itempreview (String itemId, String imagem, String nome, String preco){
    return GestureDetector(
    onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (context)=>itempage()));
    },
    child: Container(
        margin: EdgeInsets.all(4),
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Color(0xFF609EE0),
                            width: 3,
                            ),
        ),
        child: Column(
          children: [
            Image(image: AssetImage(imagem)),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                nome,
                style: TextStyle(
                  fontSize: 13
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                preco,
                style: TextStyle(
                  fontSize: 24,
                  color: Color(0xFF609EE0),
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF609EE0),
        title: Text(widget.title),
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
      body:
      isLoading
        ? Center(child: CircularProgressIndicator())
        : items.isEmpty
          ? Center(child: Text("No items found"))
          : Padding(
              padding: EdgeInsets.all(4),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.78
                ),
                itemBuilder: (_, index) {
                  final item = items[index];
                  return _itempreview(
                    item['_id'] ?? '',
                    'images/test.jpg',
                    item['name'] ?? 'No name',
                    "${item['price'] ?? 0}€"
                  );
                },
                itemCount: items.length,
              ),
            ),
      );
  }
}