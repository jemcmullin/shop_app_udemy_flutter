import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';
import '../keys.Dart';

class Auth extends ChangeNotifier {
  final _apiKey = Keys.apiKey;
  String _token;
  DateTime _expiryTime;
  String _userId;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryTime != null &&
        _token != null &&
        _expiryTime.isAfter(DateTime.now())) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String urlEndpoint) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlEndpoint?key=$_apiKey';
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      if (responseData['error'] != null) {
        throw (HttpException(responseData['error']['message']));
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryTime = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData['expiresIn']),
        ),
      );
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }
}
