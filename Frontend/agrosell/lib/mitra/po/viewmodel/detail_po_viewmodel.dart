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

    await Future.delayed(const Duration(seconds: 1));

    // Simulate fetching from API
    _poDetail = PreOrderModel(
      id: poId,
      supplierName: 'Supplier A',
      orderDate: DateTime(2024, 1, 15),
      deliveryDate: DateTime(2024, 1, 25),
      totalAmount: 5000000,
      status: 'approved',
      items: [
        POItem(productName: 'Product A', quantity: 100, price: 20000, unit: 'pcs'),
        POItem(productName: 'Product B', quantity: 50, price: 60000, unit: 'pcs'),
        POItem(productName: 'Product C', quantity: 75, price: 35000, unit: 'pcs'),
      ],
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> approvePO(String poId) async {
    if (_poDetail != null) {
      await Future.delayed(const Duration(seconds: 1));
      // Update status
      _poDetail = PreOrderModel(
        id: _poDetail!.id,
        supplierName: _poDetail!.supplierName,
        orderDate: _poDetail!.orderDate,
        deliveryDate: _poDetail!.deliveryDate,
        totalAmount: _poDetail!.totalAmount,
        status: 'approved',
        items: _poDetail!.items,
      );
      notifyListeners();
      return true;
    }
    return false;
  }
}