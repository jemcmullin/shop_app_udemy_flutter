import 'package:flutter/material.dart';

import '../screens/product_item_detail_screen.dart';
import '../models/product.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem({Key key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: GestureDetector(
        onTap: () => Navigator.of(context).pushNamed(
            ProductItemDetailScreen.routeName,
            arguments: product.id),
        child: Image.network(
          product.imageUrl,
          fit: BoxFit.cover,
        ),
      ),
      footer: GridTileBar(
        backgroundColor: Colors.black54,
        title: Text(product.title),
        leading: IconButton(
          icon: Icon(Icons.favorite),
          color: Theme.of(context).accentColor,
          onPressed: () {},
        ),
        trailing: IconButton(
          icon: Icon(Icons.shopping_cart),
          color: Theme.of(context).accentColor,
          onPressed: () {},
        ),
      ),
    );
  }
}
