import 'package:flutter/material.dart';

class PendataanViewModel with ChangeNotifier {
  bool _isLoading = true;

  bool get isLoading => _isLoading;

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    _isLoading = false;
    notifyListeners();
  }

  void refreshData() {
    loadData();
  }
}