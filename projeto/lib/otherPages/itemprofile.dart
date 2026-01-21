import 'package:flutter/material.dart';

void main() {
  runApp(const itempage());
}

class itempage extends StatelessWidget {
  const itempage({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'profile item',
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Builder(builder: (context) {
                final screenWidth = MediaQuery.of(context).size.width;
                double imageWidth = screenWidth;
                final imageHeight = imageWidth*0.6;

                return Center(
                  child: Container(
                    width: imageWidth,
                    height: imageHeight,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[300],
                      image: const DecorationImage(
                        image: NetworkImage('https://via.placeholder.com/380x270'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              }),

              const SizedBox(height: 16),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Texto preto', style: TextStyle(fontSize: 20, color: Colors.black)),
                        SizedBox(height: 4),
                        Text('Texto azul', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF609EE0))),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage('https://via.placeholder.com/80'),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.star, color: Colors.yellow),
                          SizedBox(width: 4),
                          Text('NaN', style: TextStyle(fontSize: 15)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF609EE0),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)
                        )
                      ),
                      
                      child: const Text('Adicionar', style: TextStyle(color: Colors.white)),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red, width: 3),
                        foregroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)
                        )
                      ),
                      child: const Text('Reportar', style: TextStyle(color: Colors.red)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}