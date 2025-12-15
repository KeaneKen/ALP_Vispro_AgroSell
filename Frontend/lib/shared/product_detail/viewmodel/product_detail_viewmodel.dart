import 'package:flutter/material.dart';
import '../../cart/viewmodel/cart_viewmodel.dart';

class ProductDetailViewModel extends ChangeNotifier {
  final CartViewModel _cartViewModel = CartViewModel();
  Map<String, dynamic>? _product;
  int _quantity = 1;
  bool _isLoading = false;

  Map<String, dynamic>? get product => _product;
  int get quantity => _quantity;
  bool get isLoading => _isLoading;

  void setProduct(Map<String, dynamic> product) {
    debugPrint('🔍 Setting product: $product');
    debugPrint('🔍 Product keys: ${product.keys.toList()}');
    debugPrint('🔍 Product values types: ${product.values.map((v) => v.runtimeType).toList()}');
    _product = product;
    _quantity = 1;
    notifyListeners();
  }

  void incrementQuantity() {
    _quantity++;
    notifyListeners();
  }

  void decrementQuantity() {
    if (_quantity > 1) {
      _quantity--;
      notifyListeners();
    }
  }

  void setQuantity(int value) {
    if (value > 0) {
      _quantity = value;
      notifyListeners();
    }
  }

  Future<void> addToCart() async {
    if (_product == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      // Add to cart - now saves to backend database
      await _cartViewModel.addToCart(_product!, _quantity);
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('Error in addToCart: $e');
      rethrow; // Let the UI handle the error
    }
  }

  String getTotalPrice() {
    if (_product == null) return 'Rp 0';

    // Extract price number from string like "Rp 5.800/kg"
    String? priceStr = _product!['price'] as String?;
    if (priceStr == null) return 'Rp 0';
    
    String numericPrice = priceStr
        .replaceAll('Rp ', '')
        .replaceAll('/kg', '')
        .replaceAll('.', '')
        .trim();

    int pricePerUnit = int.tryParse(numericPrice) ?? 0;
    int total = pricePerUnit * _quantity;

    // Format to Indonesian currency
    String formattedTotal = total.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );

    return 'Rp $formattedTotal';
  }
}
