import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../keys.Dart';

class Auth extends ChangeNotifier {
  final _apiKey = Keys.apiKey;
  String _token;
  DateTime _expiryTime;
  String _userId;
  Timer _authTimer;

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
      _autoLogout();
      notifyListeners();
      final sharedStore = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryTime': _expiryTime.toIso8601String(),
      });
      sharedStore.setString('userData', userData);
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

  Future<bool> tryAutoLogin() async {
    final sharedStore = await SharedPreferences.getInstance();
    //Check for stored data
    if (!sharedStore.containsKey('userData')) {
      return false;
    }
    //Check the token hasn't expired
    final userData =
        json.decode(sharedStore.getString('userData')) as Map<String, dynamic>;
    final storedExpiration = DateTime.parse(userData['expiryTime']);
    if (storedExpiration.isBefore(DateTime.now())) {
      return false;
    }
    //Set user variables
    _token = userData['token'];
    _userId = userData['userId'];
    _expiryTime = storedExpiration;
    _autoLogout();
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryTime = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final sharedStore = await SharedPreferences.getInstance();
    sharedStore.remove('userData');
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final _expirationSeconds = _expiryTime.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: _expirationSeconds), logout);
  }
}
