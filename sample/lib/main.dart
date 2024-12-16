import 'package:flutter/material.dart';
import 'box.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(230, 234, 248, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(242, 245, 252, 1),
        title: Text(
          "Search the best Freight Rates",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(230, 234, 248, 1),
              foregroundColor: Colors.indigo,
              side: BorderSide(color: Colors.blue, width: 1),
            ),
            child: Text(
              'History',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: Box(),
    );
  }
}
