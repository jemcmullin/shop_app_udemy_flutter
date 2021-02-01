import 'package:flutter/material.dart';
import '../widgets/products_grid.dart';

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
        ],
      ),
      body: ProductsGrid(_showOnlyFavorites),
    );
  }
}
