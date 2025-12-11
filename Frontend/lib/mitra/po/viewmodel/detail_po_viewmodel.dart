import 'package:flutter/material.dart';
import 'pre_order_model.dart';

class DetailPOViewModel extends ChangeNotifier {
  PreOrderModel? _poDetail;
  bool _isLoading = false;

  PreOrderModel? get poDetail => _poDetail;
  bool get isLoading => _isLoading;

  Future<void> fetchPODetail(String poId) async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Fetch PO detail from backend API
      // _poDetail = await _preOrderRepository.getPreOrderById(poId);
      await Future.delayed(const Duration(milliseconds: 500));
      
      _poDetail = null; // Will be populated from backend
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
        // TODO: Approve PO via backend API
        // await _preOrderRepository.updatePreOrderStatus(poId, 'approved');
        await Future.delayed(const Duration(milliseconds: 500));
        
        // Update local status
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
      } catch (e) {
        debugPrint('❌ Error approving PO: $e');
        return false;
      }
    }
    return false;
  }
}