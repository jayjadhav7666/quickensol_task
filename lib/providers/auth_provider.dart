import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool loggedIn = false;

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    loggedIn = prefs.getString("email") != null;
    notifyListeners();
  }

  Future<void> login(String email, String pass) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("email", email);
    loggedIn = true;
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    loggedIn = false;
    notifyListeners();
  }
}
