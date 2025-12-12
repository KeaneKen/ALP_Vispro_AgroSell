import 'package:flutter/material.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/mitra_repository.dart';
import '../../core/services/bumdes_repository.dart';
import '../../core/models/mitra_model.dart';
import '../../core/models/bumdes_model.dart';

class LoginViewModel with ChangeNotifier {
  final AuthService _authService = AuthService();
  final MitraRepository _mitraRepository = MitraRepository();
  final BumdesRepository _bumdesRepository = BumdesRepository();
  
  bool _isLoading = false;
  bool _isLoggedIn = false;
  bool _isPasswordVisible = false;
  String? _errorMessage;
  String _loginAs = 'mitra'; // 'mitra' or 'bumdes'

  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;
  bool get isPasswordVisible => _isPasswordVisible;
  String? get errorMessage => _errorMessage;
  String get loginAs => _loginAs;

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  void setLoginAs(String type) {
    _loginAs = type;
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
      if (_loginAs == 'mitra') {
        // Login as Mitra
        final MitraModel? mitra = await _mitraRepository.loginMitra(email, password);
        
        if (mitra != null) {
          await _authService.saveMitraSession(mitra);
          _isLoggedIn = true;
        } else {
          _errorMessage = 'Email atau password salah';
        }
      } else {
        // Login as Bumdes
        final BumdesModel? bumdes = await _bumdesRepository.loginBumdes(email, password);
        
        if (bumdes != null) {
          await _authService.saveBumdesSession(bumdes);
          _isLoggedIn = true;
        } else {
          _errorMessage = 'Email atau password salah';
        }
      }
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan. Coba lagi nanti.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    _isLoggedIn = false;
    notifyListeners();
  }

  /// Check if user is already logged in
  Future<void> checkLoginStatus() async {
    _isLoggedIn = await _authService.isLoggedIn();
    notifyListeners();
  }
}