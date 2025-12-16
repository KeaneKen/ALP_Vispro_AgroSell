import 'package:flutter/material.dart';

class PaymentViewModel extends ChangeNotifier {
  // Payment Items - loaded from cart or order
  List<PaymentItem> _paymentItems = [];

  // Payment Methods
  List<PaymentMethod> _paymentMethods = [
    PaymentMethod(name: "Bank Transfer", details: "BCA, Mandiri, BRI"),
    PaymentMethod(name: "E-Wallet", details: "GoPay, OVO, Dana"),
    PaymentMethod(name: "Cicilan", details: "Tenor 3, 6, 12 bulan"),
  ];

  String? _selectedPaymentMethod;
  double _adminFee = 50000;
  double _shippingCost = 10000;
  bool _isLoading = false;

  // Getters
  List<PaymentItem> get paymentItems => _paymentItems;
  List<PaymentMethod> get paymentMethods => _paymentMethods;
  String? get selectedPaymentMethod => _selectedPaymentMethod;
  double get adminFee => _adminFee;
  double get shippingCost => _shippingCost;
  bool get isLoading => _isLoading;

  // Calculated values
  double get subtotal {
    return _paymentItems.fold(0, (sum, item) => sum + item.price);
  }

  double get total {
    return subtotal + _adminFee + _shippingCost;
  }

  // Methods
  void selectPaymentMethod(String methodName) {
    _selectedPaymentMethod = methodName;
    notifyListeners();
  }

  void addPaymentItem(PaymentItem item) {
    _paymentItems.add(item);
    notifyListeners();
  }

  void removePaymentItem(int index) {
    if (index >= 0 && index < _paymentItems.length) {
      _paymentItems.removeAt(index);
      notifyListeners();
    }
  }

  void clearPaymentItems() {
    _paymentItems.clear();
    notifyListeners();
  }

  void setAdminFee(double fee) {
    _adminFee = fee;
    notifyListeners();
  }

  void setShippingCost(double cost) {
    _shippingCost = cost;
    notifyListeners();
  }

  Future<void> processPayment() async {
    if (_selectedPaymentMethod == null) {
      throw Exception("Pilih metode pembayaran terlebih dahulu");
    }

    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Submit payment to backend API
      // await _paymentRepository.createPayment(...)
      await Future.delayed(const Duration(milliseconds: 500));
      
      debugPrint('💳 Payment processed: $_selectedPaymentMethod, Total: $total');
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error processing payment: $e');
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
}

class PaymentItem {
  final String imagePath;
  final String title;
  final double price;

  PaymentItem({
    required this.imagePath,
    required this.title,
    required this.price,
  });
}

class PaymentMethod {
  final String name;
  final String details;

  PaymentMethod({
    required this.name,
    required this.details,
  });
}