import 'package:flutter/material.dart';

class ListPoViewModel with ChangeNotifier {
  bool _isLoading = true;
  List<Map<String, dynamic>> _preOrders = [];

  bool get isLoading => _isLoading;
  List<Map<String, dynamic>> get preOrders => _preOrders;

  ListPoViewModel() {
    loadPreOrders();
  }

  Future<void> loadPreOrders() async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Fetch pre-orders from backend API
      // await _preOrderRepository.getAllPreOrders();
      await Future.delayed(const Duration(milliseconds: 500));
      _preOrders = [];
      
      debugPrint('📦 Pre-orders loaded: ${_preOrders.length} items');
    } catch (e) {
      debugPrint('❌ Error loading pre-orders: $e');
      _preOrders = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  void refreshData() {
    loadPreOrders();
  }
}