import 'package:flutter/material.dart';
import 'pre_order_model.dart';
import '../../../core/services/preorder_repository.dart';

class DetailPOViewModel extends ChangeNotifier {
  final PreOrderRepository _repository = PreOrderRepository();
  PreOrderModel? _poDetail;
  bool _isLoading = false;

  PreOrderModel? get poDetail => _poDetail;
  bool get isLoading => _isLoading;

  Future<void> fetchPODetail(String poId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final json = await _repository.getPreOrderById(poId);
      if (json != null) {
        _poDetail = PreOrderModel(
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
        );
      }
      debugPrint('📦 PO detail loaded: $poId');
    } catch (e) {
      debugPrint('❌ Error loading PO detail: $e');
      _poDetail = null;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> approvePO(String poId) async {
    if (_poDetail != null) {
      try {
        final success = await _repository.approvePreOrder(poId);
        if (success) {
          _poDetail = PreOrderModel(
            id: _poDetail!.id,
            supplierName: _poDetail!.supplierName,
            orderDate: _poDetail!.orderDate,
            deliveryDate: _poDetail!.deliveryDate,
            totalAmount: _poDetail!.totalAmount,
            status: 'approved',
            items: _poDetail!.items,
          );
          debugPrint('✅ PO approved: $poId');
          notifyListeners();
          return true;
        }
      } catch (e) {
        debugPrint('❌ Error approving PO: $e');
        return false;
      }
    }
    return false;
  }
}