import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class Auth extends ChangeNotifier {
  static const _apiKey = 'AIzaSyCp67lIft2Vw1xn8ScjyovrQRTpKxMPKaw';
  String _token;
  DateTime _expiryTime;
  String _userId;

  Future<void> _authenticate(
      String email, String password, String urlEndpoint) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlEndpoint?key=$_apiKey';
    final response = await http.post(url,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }));
    final responseData = json.decode(response.body) as Map<String, String>;
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }
}
