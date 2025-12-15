import 'package:flutter/material.dart';
import '../../../../core/services/preorder_repository.dart';

class ListPoViewModel with ChangeNotifier {
  final PreOrderRepository _repository = PreOrderRepository();
  bool _isLoading = true;
  List<Map<String, dynamic>> _preOrders = [];

  bool get isLoading => _isLoading;
  List<Map<String, dynamic>> get preOrders => _preOrders;

  ListPoViewModel() {
    loadPreOrders();
  }

  Future<void> loadPreOrders({String? idBumDES}) async {
    _isLoading = true;
    notifyListeners();

    try {
      _preOrders = await _repository.getAllPreOrders(idBumDES: idBumDES);
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