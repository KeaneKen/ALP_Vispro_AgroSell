import 'package:flutter/material.dart';

class RegisterViewModel with ChangeNotifier {
  bool _isLoading = false;
  bool _isRegistered = false;
  bool _isPasswordVisible = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  bool get isRegistered => _isRegistered;
  bool get isPasswordVisible => _isPasswordVisible;
  String? get errorMessage => _errorMessage;

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  Future<void> register(String username, String email, String password) async {
    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      _errorMessage = 'Semua field harus diisi';
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
      if (username.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
        _isRegistered = true;
      } else {
        _errorMessage = 'Gagal mendaftar. Coba lagi nanti.';
      }
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan. Coba lagi nanti.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}