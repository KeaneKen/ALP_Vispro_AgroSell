import 'package:flutter/material.dart';
import '../../../core/services/cart_repository.dart';
import '../../../core/models/cart_model.dart';

class CartViewModel extends ChangeNotifier {
  // Singleton pattern untuk shared cart state
  static final CartViewModel _instance = CartViewModel._internal();
  factory CartViewModel() => _instance;
  CartViewModel._internal();

  final CartRepository _cartRepository = CartRepository();
  final List<Map<String, dynamic>> _cartItems = [];
  final Set<int> _selectedIndices = {};
  bool _isLoading = false;
  String? _errorMessage;

  List<Map<String, dynamic>> get cartItems => _cartItems;
  Set<int> get selectedIndices => _selectedIndices;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  
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

  /// Add item to cart - saves to backend database
  Future<void> addToCart(Map<String, dynamic> product, int quantity) async {
    _errorMessage = null;
    
    // Get product ID from the product map
    String? productId = product['id'] as String?;
    
    if (productId == null || productId.isEmpty) {
      _errorMessage = 'Product ID is missing. Cannot add to cart.';
      notifyListeners();
      return;
    }

    try {
      // Save to backend database
      await _cartRepository.addToCart(productId, quantity);
      
      // Also update local cart for immediate UI update
      int existingIndex = _cartItems.indexWhere(
        (item) => item['id'] == productId,
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
    } catch (e) {
      _errorMessage = 'Failed to add to cart: $e';
      notifyListeners();
      debugPrint('Error adding to cart: $e');
    }
  }

  /// Load cart items from backend database
  Future<void> loadCartFromBackend() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final cartItems = await _cartRepository.getAllCartItems();
      
      // Convert CartModel to Map for existing UI compatibility
      _cartItems.clear();
      for (var item in cartItems) {
        if (item.pangan != null) {
          _cartItems.add({
            'id': item.idPangan,
            'cartId': item.idCart,
            'name': item.pangan!.namaPangan,
            'price': 'Rp ${_formatPrice(item.pangan!.hargaPangan)}/kg',
            'quantity': item.jumlahPembelian,
            'image': 'assets/images/default.jpg', // Default image
          });
        }
      }
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load cart: $e';
      _isLoading = false;
      notifyListeners();
      debugPrint('Error loading cart: $e');
    }
  }

  String _formatPrice(double price) {
    return price.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  /// Remove item from cart - deletes from backend database
  Future<void> removeFromCart(int index) async {
    if (index < 0 || index >= _cartItems.length) return;

    try {
      final cartId = _cartItems[index]['cartId'] as String?;
      
      if (cartId != null && cartId.isNotEmpty) {
        // Remove from backend
        await _cartRepository.removeFromCart(cartId);
      }
      
      // Remove from local list
      _cartItems.removeAt(index);
      _selectedIndices.remove(index);
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to remove item: $e';
      notifyListeners();
      debugPrint('Error removing from cart: $e');
    }
  }

  /// Update item quantity - updates in backend database
  Future<void> updateQuantity(int index, int newQuantity) async {
    if (index < 0 || index >= _cartItems.length || newQuantity <= 0) return;

    try {
      final cartId = _cartItems[index]['cartId'] as String?;
      
      if (cartId != null && cartId.isNotEmpty) {
        // Update in backend
        await _cartRepository.updateCartItem(cartId, newQuantity);
      }
      
      // Update local list
      _cartItems[index]['quantity'] = newQuantity;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to update quantity: $e';
      notifyListeners();
      debugPrint('Error updating quantity: $e');
    }
  }

  void incrementQuantity(int index) {
    if (index >= 0 && index < _cartItems.length) {
      int newQuantity = _cartItems[index]['quantity'] + 1;
      updateQuantity(index, newQuantity);
    }
  }

  void decrementQuantity(int index) {
    if (index >= 0 && index < _cartItems.length) {
      int currentQuantity = _cartItems[index]['quantity'];
      if (currentQuantity > 1) {
        updateQuantity(index, currentQuantity - 1);
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
