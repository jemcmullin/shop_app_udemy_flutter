import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shop_app/models/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      this.isFavorite = false});

  Future<void> toggleFavorite(String token, String userId) async {
    final url =
        'https://flutter-shop-app-021821-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$token';
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      final response = await http.put(
        url,
        body: json.encode(
          isFavorite,
        ),
      );
      if (response.statusCode >= 400) {
        throw HttpException('Favorite change failed on server');
      }
      // print('Update: ${response.statusCode}');
    } catch (error) {
      print(error);
      isFavorite = !isFavorite;
      notifyListeners();
      throw (error);
    }
  }
}
