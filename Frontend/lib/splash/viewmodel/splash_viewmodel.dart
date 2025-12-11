import 'package:flutter/material.dart';

class SplashViewModel with ChangeNotifier {
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  Future<void> initializeApp() async {
    // Simulate initialization process
    await Future.delayed(const Duration(seconds: 2));
    
    // Perform any initialization logic here
    // e.g., check user authentication, load config, etc.
    
    _isInitialized = true;
    notifyListeners();
  }

  void navigateToNextScreen(BuildContext context) {
    // Determine where to navigate based on app state
    // For now, we'll just navigate to login
    Navigator.pushReplacementNamed(context, '/login');
  }
}