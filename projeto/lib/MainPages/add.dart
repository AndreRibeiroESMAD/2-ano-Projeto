import 'package:flutter/material.dart';

void main() {
  runApp(const addItems());
}

class addItems extends StatelessWidget {
  const addItems({super.key});

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
        padding: const EdgeInsets.only(top: 80, left: 12, right: 12, bottom: 12), 
        child: Column(
          children: [
            Container(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.blueGrey, width: 3),
                  foregroundColor: Colors.blueGrey,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)
                  )
                ),
                child: Text('Adicionar imagem', 
                  style: TextStyle(color: Colors.blueGrey)
                  ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                hintText: "Nome",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: "Preço",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              keyboardType: TextInputType.multiline,
              maxLines: 10,
              decoration: const InputDecoration(
                hintText: "Descrição",
                border: OutlineInputBorder(),
              ),
            ),
            Expanded(child: Container()),
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
                child: Text('Submeter',
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