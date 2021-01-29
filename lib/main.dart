import 'package:flutter/material.dart';
import 'package:shop_app/screens/product_item_detail_screen.dart';
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
        primaryColor: Colors.tealAccent[400],
        accentColor: Colors.orangeAccent,
        fontFamily: 'Lato',
      ),
      home: ProductsOverviewScreen(),
      routes: {
        ProductItemDetailScreen.routeName: (context) =>
            ProductItemDetailScreen(),
      },
    );
  }
}
