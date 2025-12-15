import 'package:flutter/material.dart';
import 'pre_order_model.dart';
import '../../../core/services/preorder_repository.dart';

class ListPOViewModel extends ChangeNotifier {
  final PreOrderRepository _repository = PreOrderRepository();
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

  Future<void> fetchPOList({String? idMitra}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = await _repository.getAllPreOrders(idMitra: idMitra);
      _poList = data.map((json) => PreOrderModel(
        id: json['id'] ?? '',
        supplierName: json['supplierName'] ?? 'Unknown',
        orderDate: DateTime.parse(json['orderDate']),
        deliveryDate: json['deliveryDate'] != null ? DateTime.parse(json['deliveryDate']) : DateTime.now(),
        totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
        status: json['status'] ?? 'pending',
        items: (json['items'] as List? ?? []).map((item) => POItem(
          productName: item['productName'] ?? '',
          quantity: item['quantity'] ?? 0,
          price: (item['price'] as num?)?.toDouble() ?? 0.0,
          unit: item['unit'] ?? 'pcs',
        )).toList(),
      )).toList();
    } catch (e) {
      debugPrint('❌ Error fetching PO list: $e');
      _poList = [];
    }

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