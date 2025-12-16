import 'package:flutter/material.dart';
import 'pre_order_model.dart';
import '../../../core/services/preorder_repository.dart';
import '../../../core/services/auth_service.dart';

class FormPOViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
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
      // Get logged-in user IDs
      final mitraId = await _authService.getMitraId();
      final userType = await _authService.getUserType();
      
      // Default to test IDs if not logged in
      final effectiveMitraId = mitraId ?? 'M001';
      final effectiveBumdesId = userType == 'bumdes' 
          ? await _authService.getBumdesId() ?? 'B001' 
          : 'B001';
      
      final repository = PreOrderRepository();
      final result = await repository.createPreOrder({
        'idMitra': effectiveMitraId,
        'idBumDES': effectiveBumdesId,
        'order_date': _orderDate.toIso8601String(),
        'delivery_date': _deliveryDate.toIso8601String(),
        'total_amount': _items.fold(0.0, (sum, item) => sum + (item.price * item.quantity)),
        'notes': '',
        'items': _items.map((item) => {
          'idPangan': item.productId ?? 'P001', // Use actual product ID from item
          'quantity': item.quantity,
          'price': item.price,
        }).toList(),
      });
      
      debugPrint('📤 PO submitted: $_supplierName, ${_items.length} items, result: $result');
      _isLoading = false;
      notifyListeners();
      return result != null;
    } catch (e) {
      debugPrint('❌ Error submitting PO: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updatePO(PreOrderModel po) async {
    _isLoading = true;
    notifyListeners();

    try {
      final repository = PreOrderRepository();
      final result = await repository.updatePreOrder(po.id, {
        'delivery_date': _deliveryDate.toIso8601String(),
        'status': 'pending',
        'notes': '',
      });
      
      debugPrint('📤 PO updated: ${po.id}, result: $result');
      _isLoading = false;
      notifyListeners();
      return result;
    } catch (e) {
      debugPrint('❌ Error updating PO: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}