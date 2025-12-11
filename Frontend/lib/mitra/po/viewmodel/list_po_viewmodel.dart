import 'package:flutter/material.dart';
import 'pre_order_model.dart';

class ListPOViewModel extends ChangeNotifier {
  List<PreOrderModel> _poList = [];
  bool _isLoading = false;
  String _filterStatus = 'all';

  List<PreOrderModel> get poList => _filteredList;
  bool get isLoading => _isLoading;
  String get filterStatus => _filterStatus;

  List<PreOrderModel> get _filteredList {
    if (_filterStatus == 'all') return _poList;
    return _poList.where((po) => po.status == _filterStatus).toList();
  }

  Future<void> fetchPOList() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    _poList = [
      PreOrderModel(
        id: 'PO-001',
        supplierName: 'Supplier A',
        orderDate: DateTime(2024, 1, 15),
        deliveryDate: DateTime(2024, 1, 25),
        totalAmount: 5000000,
        status: 'approved',
        items: [
          POItem(productName: 'Product A', quantity: 100, price: 20000, unit: 'pcs'),
        ],
      ),
      PreOrderModel(
        id: 'PO-002',
        supplierName: 'Supplier B',
        orderDate: DateTime(2024, 1, 14),
        deliveryDate: DateTime(2024, 1, 24),
        totalAmount: 7500000,
        status: 'pending',
        items: [
          POItem(productName: 'Product B', quantity: 50, price: 150000, unit: 'pcs'),
        ],
      ),
    ];

    _isLoading = false;
    notifyListeners();
  }

  void setFilterStatus(String status) {
    _filterStatus = status;
    notifyListeners();
  }

  void deletePO(String poId) {
    _poList.removeWhere((po) => po.id == poId);
    notifyListeners();
  }
}