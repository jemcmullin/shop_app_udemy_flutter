import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/cart_screen.dart';
import '../providers/products_provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/badge.dart';
import '../widgets/products_grid.dart';
import '../widgets/app_drawer.dart';

enum FilterOptions {
  All,
  Favorites,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = false;
  var _isLoading = true;

  @override
  void initState() {
    super.initState();
    Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts()
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Overview'),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.filter_list),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: _showOnlyFavorites
                    ? Text('  All')
                    : Row(
                        children: [
                          Icon(Icons.check),
                          Text(' All'),
                        ],
                      ),
                value: FilterOptions.All,
              ),
              PopupMenuItem(
                child: _showOnlyFavorites
                    ? Row(
                        children: [
                          Icon(Icons.check),
                          Text(' Favorites Only'),
                        ],
                      )
                    : Text('  Favorites Only'),
                value: FilterOptions.Favorites,
              ),
            ],
            onSelected: (FilterOptions filter) {
              setState(() {
                if (filter == FilterOptions.Favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
          ),
          Consumer<Cart>(
            builder: (_, cart, builderChild) => Badge(
              child: builderChild,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () =>
                  Navigator.of(context).pushNamed(CartScreen.routeName),
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Container(
              width: double.infinity,
              height: 100,
              alignment: Alignment.center,
              child: CircularProgressIndicator.adaptive(),
            )
          : ProductsGrid(_showOnlyFavorites),
    );
  }
}
