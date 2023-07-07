import 'package:flutter/material.dart';
import 'package:foodrecipe/Loading.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe App',
      theme: ThemeData(
        fontFamily: 'Agdasima',
      ),
      home: Loading(),
    );
  }
}
