import 'package:flutter/material.dart';
import './screens/products_overview_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Shop App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        primaryColor: Colors.orange[400],
        accentColor: Colors.teal[400],
      ),
      home: ProductsOverviewScreen(),
    );
  }
}
