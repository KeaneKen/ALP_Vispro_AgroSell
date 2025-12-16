import 'package:flutter/material.dart';

class ForgotPasswordViewModel with ChangeNotifier {
  bool _isLoading = false;
  bool _isResetSent = false;
  String? _errorMessage;
  String? _successMessage;

  bool get isLoading => _isLoading;
  bool get isResetSent => _isResetSent;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  Future<void> sendResetEmail(String email) async {
    if (email.isEmpty) {
      _errorMessage = 'Email harus diisi';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // For demo purposes
      _isResetSent = true;
      _successMessage = 'Link reset password telah dikirim ke email Anda';
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan. Coba lagi nanti.';
      _isResetSent = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}