import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';
import 'dart:convert';

import 'product_provider.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];
  //   Product(
  //     id: 'p1',
  //     title: 'Red Shirt',
  //     description: 'A red shirt - it is pretty red!',
  //     price: 29.99,
  //     imageUrl:
  //         'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
  //   ),
  //   Product(
  //     id: 'p2',
  //     title: 'Trousers',
  //     description: 'A nice pair of trousers.',
  //     price: 59.99,
  //     imageUrl:
  //         'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
  //   ),
  //   Product(
  //     id: 'p3',
  //     title: 'Yellow Scarf',
  //     description: 'Warm and cozy - exactly what you need for the winter.',
  //     price: 19.99,
  //     imageUrl:
  //         'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
  //   ),
  //   Product(
  //     id: 'p4',
  //     title: 'A Pan',
  //     description: 'Prepare any meal you want.',
  //     price: 49.99,
  //     imageUrl:
  //         'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
  //   ),
  // ];
  final String authToken;

  Products(this.authToken, this._items);

  List<Product> get items {
    return [..._items];
  }

  List<Product> get itemsFavorite {
    return items.where((product) => product.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  Future<void> fetchAndSetProducts() async {
    final url =
        'https://flutter-shop-app-021821-default-rtdb.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final List<Product> loadedProductsHandler = [];
      extractedData.forEach((key, productData) {
        loadedProductsHandler.add(Product(
            id: key,
            title: productData['title'],
            description: productData['description'],
            price: productData['price'],
            imageUrl: productData['imageUrl'],
            isFavorite: productData['isFavorite']));
      });
      _items = loadedProductsHandler;
      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://flutter-shop-app-021821-default-rtdb.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'price': product.price,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'isFavorite': product.isFavorite,
        }),
      );
      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);
      _items.insert(0, newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String productId, Product updateProduct) async {
    final productIndex =
        _items.indexWhere((product) => product.id == productId);
    if (productIndex != null) {
      final url =
          'https://flutter-shop-app-021821-default-rtdb.firebaseio.com/products/$productId.json?auth=$authToken';
      try {
        final response = await http.patch(
          url,
          body: json.encode({
            'title': updateProduct.title,
            'price': updateProduct.price,
            'description': updateProduct.description,
            'imageUrl': updateProduct.imageUrl,
          }),
        );
        print('Update: ${response.statusCode}');
      } catch (error) {
        print(error);
        throw (error);
      }
      _items[productIndex] = updateProduct;
    }
    notifyListeners();
  }

  Future<void> removeProduct(String productId) {
    final url =
        'https://flutter-shop-app-021821-default-rtdb.firebaseio.com/products/$productId.json?auth=$authToken';
    final productIndex =
        _items.indexWhere((product) => product.id == productId);
    var existingProduct = _items[productIndex];
    _items.removeWhere((product) => product.id == productId);
    notifyListeners();
    return http.delete(url).then((response) {
      if (response.statusCode >= 400) {
        throw HttpException('Server request Delete failed');
      }
      existingProduct = null;
    }).catchError((error) {
      print(error);
      _items.insert(productIndex, existingProduct);
      notifyListeners();
      throw (error);
    });
  }
}
