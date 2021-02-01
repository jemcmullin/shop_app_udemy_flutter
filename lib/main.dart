import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/products_provider.dart';
import './providers/cart_provider.dart';
import './screens/products_overview_screen.dart';
import './screens/product_item_detail_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Products(),
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        )
      ],
      child: MaterialApp(
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
      ),
    );
  }
}
