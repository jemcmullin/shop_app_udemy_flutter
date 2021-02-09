import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widgets/user_product_item.dart';
import '../providers/products_provider.dart';
import '../widgets/app_drawer.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                // TODO
              })
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
          padding: const EdgeInsets.all(8),
          child: ListView.builder(
              itemCount: productsData.items.length,
              itemBuilder: (_, index) => UserProductItem(
                    title: productsData.items[index].title,
                    imageUrl: productsData.items[index].imageUrl,
                  ))),
    );
  }
}
