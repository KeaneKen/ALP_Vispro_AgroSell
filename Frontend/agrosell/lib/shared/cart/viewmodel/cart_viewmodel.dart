import 'package:flutter/material.dart';

class CartViewModel extends ChangeNotifier {
  // Singleton pattern untuk shared cart state
  static final CartViewModel _instance = CartViewModel._internal();
  factory CartViewModel() => _instance;
  CartViewModel._internal();

  final List<Map<String, dynamic>> _cartItems = [];
  final Set<int> _selectedIndices = {};
  bool _isLoading = false;

  List<Map<String, dynamic>> get cartItems => _cartItems;
  Set<int> get selectedIndices => _selectedIndices;
  bool get isLoading => _isLoading;
  
  bool get isAllSelected => _selectedIndices.length == _cartItems.length && _cartItems.isNotEmpty;
  
  bool isSelected(int index) => _selectedIndices.contains(index);

  int get totalItems {
    return _cartItems.fold(0, (sum, item) => sum + (item['quantity'] as int));
  }

  String get totalPrice {
    int total = 0;
    for (var item in _cartItems) {
      String priceStr = item['price'] as String;
      String numericPrice = priceStr
          .replaceAll('Rp ', '')
          .replaceAll('/kg', '')
          .replaceAll('.', '')
          .trim();
      int pricePerUnit = int.tryParse(numericPrice) ?? 0;
      int quantity = item['quantity'] as int;
      total += pricePerUnit * quantity;
    }

    String formattedTotal = total.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );

    return 'Rp $formattedTotal';
  }

  void addToCart(Map<String, dynamic> product, int quantity) {
    // Check if product already exists in cart
    int existingIndex = _cartItems.indexWhere(
      (item) => item['name'] == product['name'],
    );

    if (existingIndex != -1) {
      // Update quantity if product already exists
      _cartItems[existingIndex]['quantity'] += quantity;
    } else {
      // Add new product to cart
      _cartItems.add({
        ...product,
        'quantity': quantity,
      });
    }

    notifyListeners();
  }

  void removeFromCart(int index) {
    if (index >= 0 && index < _cartItems.length) {
      _cartItems.removeAt(index);
      notifyListeners();
    }
  }

  void updateQuantity(int index, int newQuantity) {
    if (index >= 0 && index < _cartItems.length && newQuantity > 0) {
      _cartItems[index]['quantity'] = newQuantity;
      notifyListeners();
    }
  }

  void incrementQuantity(int index) {
    if (index >= 0 && index < _cartItems.length) {
      _cartItems[index]['quantity']++;
      notifyListeners();
    }
  }

  void decrementQuantity(int index) {
    if (index >= 0 && index < _cartItems.length) {
      if (_cartItems[index]['quantity'] > 1) {
        _cartItems[index]['quantity']--;
        notifyListeners();
      }
    }
  }

  void clearCart() {
    _cartItems.clear();
    _selectedIndices.clear();
    notifyListeners();
  }

  void toggleSelection(int index) {
    if (_selectedIndices.contains(index)) {
      _selectedIndices.remove(index);
    } else {
      _selectedIndices.add(index);
    }
    notifyListeners();
  }

  void selectAll() {
    _selectedIndices.clear();
    for (int i = 0; i < _cartItems.length; i++) {
      _selectedIndices.add(i);
    }
    notifyListeners();
  }

  void deselectAll() {
    _selectedIndices.clear();
    notifyListeners();
  }

  Future<void> checkout() async {
    _isLoading = true;
    notifyListeners();

    // TODO: Implement API call for checkout
    await Future.delayed(const Duration(seconds: 2));

    _isLoading = false;
    notifyListeners();
  }

  String getItemTotalPrice(int index) {
    if (index < 0 || index >= _cartItems.length) return 'Rp 0';

    var item = _cartItems[index];
    String priceStr = item['price'] as String;
    String numericPrice = priceStr
        .replaceAll('Rp ', '')
        .replaceAll('/kg', '')
        .replaceAll('.', '')
        .trim();

    int pricePerUnit = int.tryParse(numericPrice) ?? 0;
    int quantity = item['quantity'] as int;
    int total = pricePerUnit * quantity;

    String formattedTotal = total.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );

    return 'Rp $formattedTotal';
  }
}
