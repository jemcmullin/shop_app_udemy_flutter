import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import './cart_provider.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    const url =
        'https://flutter-shop-app-021821-default-rtdb.firebaseio.com/orders.json';
    final response = await http.get(url);
    final _fetchedData = json.decode(response.body) as Map<String, dynamic>;
    if (_fetchedData == null) {
      return;
    }
    final List<OrderItem> _fetchedOrders = [];
    _fetchedData.forEach(
      (orderId, orderData) {
        _fetchedOrders.add(OrderItem(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>)
              .map((item) => CartItem(
                  id: item['id'],
                  title: item['title'],
                  quantity: item['quantity'],
                  price: item['price']))
              .toList(),
        ));
      },
    );
    _orders = _fetchedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double totalAmount) async {
    final timestamp = DateTime.now();
    const url =
        'https://flutter-shop-app-021821-default-rtdb.firebaseio.com/orders.json';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'dateTime': timestamp.toIso8601String(),
            'amount': totalAmount,
            'products': cartProducts
                .map((eachProduct) => {
                      'id': eachProduct.id,
                      'title': eachProduct.title,
                      'price': eachProduct.price,
                      'quantity': eachProduct.quantity,
                    })
                .toList()
          },
        ),
      );
      _orders.insert(
        0, //Index to insert at beginning
        OrderItem(
          id: json.decode(response.body)['name'],
          amount: totalAmount,
          products: cartProducts,
          dateTime: timestamp,
        ),
      );
      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }
}
