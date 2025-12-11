import 'package:flutter/material.dart';
import 'pre_order_model.dart';

class FormPOViewModel extends ChangeNotifier {
  final List<POItem> _items = [];
  String _supplierName = '';
  DateTime _orderDate = DateTime.now();
  DateTime _deliveryDate = DateTime.now().add(const Duration(days: 7));
  bool _isLoading = false;

  List<POItem> get items => _items;
  String get supplierName => _supplierName;
  DateTime get orderDate => _orderDate;
  DateTime get deliveryDate => _deliveryDate;
  bool get isLoading => _isLoading;

  void setSupplierName(String value) {
    _supplierName = value;
    notifyListeners();
  }

  void setOrderDate(DateTime date) {
    _orderDate = date;
    notifyListeners();
  }

  void setDeliveryDate(DateTime date) {
    _deliveryDate = date;
    notifyListeners();
  }

  void addItem(POItem item) {
    _items.add(item);
    notifyListeners();
  }

  void removeItem(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  void updateItem(int index, POItem item) {
    _items[index] = item;
    notifyListeners();
  }

  Future<bool> submitPO() async {
    if (_supplierName.isEmpty || _items.isEmpty) {
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // Save PO logic here
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updatePO(PreOrderModel po) async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 2));
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}