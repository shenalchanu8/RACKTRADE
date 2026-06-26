import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  String? _userName;
  String? _userEmail;

  bool get isLoggedIn => _isLoggedIn;
  String? get userName => _userName;
  String? get userEmail => _userEmail;

  AuthProvider() {
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    _userName = prefs.getString('userName');
    _userEmail = prefs.getString('userEmail');
    notifyListeners();
  }

  Future<bool> registerUser(String name, String email, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Check if user already exists
      final existingEmail = prefs.getString('userEmail');
      if (existingEmail == email) {
        return false; // User already exists
      }

      // Save user data
      await prefs.setString('userName', name);
      await prefs.setString('userEmail', email);
      await prefs.setString('userPassword', password);
      await prefs.setBool('isLoggedIn', true);

      _userName = name;
      _userEmail = email;
      _isLoggedIn = true;
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> loginUser(String email, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedEmail = prefs.getString('userEmail');
      final storedPassword = prefs.getString('userPassword');

      if (storedEmail == email && storedPassword == password) {
        await prefs.setBool('isLoggedIn', true);
        _isLoggedIn = true;
        _userName = prefs.getString('userName');
        _userEmail = email;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    _isLoggedIn = false;
    notifyListeners();
  }

  Future<bool> checkUserExists(String email) async {
    final prefs = await SharedPreferences.getInstance();
    final storedEmail = prefs.getString('userEmail');
    return storedEmail == email;
  }
}
