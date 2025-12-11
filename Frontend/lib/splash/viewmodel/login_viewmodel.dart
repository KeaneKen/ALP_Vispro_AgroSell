import 'package:flutter/material.dart';

class LoginViewModel with ChangeNotifier {
  bool _isLoading = false;
  bool _isLoggedIn = false;
  bool _isPasswordVisible = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;
  bool get isPasswordVisible => _isPasswordVisible;
  String? get errorMessage => _errorMessage;

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      _errorMessage = 'Email dan password harus diisi';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // For demo purposes, accept any non-empty credentials
      if (email.isNotEmpty && password.isNotEmpty) {
        _isLoggedIn = true;
      } else {
        _errorMessage = 'Email atau password salah';
      }
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan. Coba lagi nanti.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }
}