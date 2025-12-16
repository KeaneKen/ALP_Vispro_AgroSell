import 'package:flutter/material.dart';
import '../../../core/services/cart_repository.dart';
import '../../../core/services/payment_repository.dart';
import '../../../core/services/riwayat_repository.dart';
import '../../../core/models/cart_model.dart';

class CartViewModel extends ChangeNotifier {
  // Singleton pattern untuk shared cart state
  static final CartViewModel _instance = CartViewModel._internal();
  factory CartViewModel() => _instance;
  CartViewModel._internal();

  final CartRepository _cartRepository = CartRepository();
  final PaymentRepository _paymentRepository = PaymentRepository();
  final RiwayatRepository _riwayatRepository = RiwayatRepository();
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
      String? priceStr = item['price'] as String?;
      if (priceStr == null) continue;
      
      String numericPrice = priceStr
          .replaceAll('Rp ', '')
          .replaceAll('/kg', '')
          .replaceAll('.', '')
          .trim();
      int pricePerUnit = int.tryParse(numericPrice) ?? 0;
      int quantity = item['quantity'] as int? ?? 0;
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
      // Save to backend database and get the cart item with cartId
      final cartItem = await _cartRepository.addToCart(productId, quantity);
      
      debugPrint('🛒 Cart item received: idCart=${cartItem.idCart}');
      
      // Update local cart with cartId from backend
      int existingIndex = _cartItems.indexWhere(
        (item) => item['id'] == productId,
      );

      if (existingIndex != -1) {
        // Update quantity and cartId if product already exists
        _cartItems[existingIndex]['quantity'] += quantity;
        _cartItems[existingIndex]['cartId'] = cartItem.idCart;
      } else {
        // Add new product to cart with cartId
        _cartItems.add({
          ...product,
          'quantity': quantity,
          'cartId': cartItem.idCart,  // ✅ Store the cartId from backend!
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

  Future<bool> checkout({
    String? deliveryAddress,
    String? phoneNumber,
    String? notes,
  }) async {
    if (_cartItems.isEmpty) {
      _errorMessage = 'Cart is empty';
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Step 1: Calculate total price
      double totalPrice = 0;
      for (var item in _cartItems) {
        String? priceStr = item['price'] as String?;
        if (priceStr == null) continue;
        
        String numericPrice = priceStr
            .replaceAll('Rp ', '')
            .replaceAll('/kg', '')
            .replaceAll('.', '')
            .trim();
        int pricePerUnit = int.tryParse(numericPrice) ?? 0;
        int quantity = item['quantity'] as int? ?? 0;
        totalPrice += (pricePerUnit * quantity);
      }

      // Step 2: Get the first cart item's cartId (we'll use this for payment)
      // In a real app, you might want to create a new "order" entity
      String? cartId = _cartItems.isNotEmpty ? _cartItems[0]['cartId'] as String? : null;
      
      if (cartId == null || cartId.isEmpty) {
        _errorMessage = 'Invalid cart data';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      debugPrint('💳 Processing checkout...');
      debugPrint('💳 Cart ID: $cartId');
      debugPrint('💳 Total: Rp ${totalPrice.toStringAsFixed(0)}');

      // Step 3: Create payment record (mock payment)
      final payment = await _paymentRepository.createPayment(cartId, totalPrice);
      debugPrint('✅ Payment created: ${payment.idPayment}');

      // Step 4: Create riwayat (order history) record with delivery info
      final riwayat = await _riwayatRepository.createRiwayat(
        payment.idPayment,
        status: 'processing',
        deliveryAddress: deliveryAddress,
        phoneNumber: phoneNumber,
        notes: notes,
      );
      debugPrint('✅ Order history created: ${riwayat.idHistory}');

      // Step 5: Clear cart items from backend
      for (var item in _cartItems) {
        final itemCartId = item['cartId'] as String?;
        if (itemCartId != null && itemCartId.isNotEmpty) {
          try {
            await _cartRepository.removeFromCart(itemCartId);
          } catch (e) {
            debugPrint('⚠️ Failed to remove cart item $itemCartId: $e');
          }
        }
      }

      // Step 6: Clear local cart
      _cartItems.clear();
      _selectedIndices.clear();
      
      _isLoading = false;
      notifyListeners();
      
      debugPrint('✅ Checkout completed successfully!');
      return true;

    } catch (e) {
      _errorMessage = 'Checkout failed: $e';
      _isLoading = false;
      notifyListeners();
      debugPrint('❌ Checkout error: $e');
      return false;
    }
  }

  String getItemTotalPrice(int index) {
    if (index < 0 || index >= _cartItems.length) return 'Rp 0';

    var item = _cartItems[index];
    String? priceStr = item['price'] as String?;
    if (priceStr == null) return 'Rp 0';
    
    String numericPrice = priceStr
        .replaceAll('Rp ', '')
        .replaceAll('/kg', '')
        .replaceAll('.', '')
        .trim();

    int pricePerUnit = int.tryParse(numericPrice) ?? 0;
    int quantity = item['quantity'] as int? ?? 0;
    int total = pricePerUnit * quantity;

    String formattedTotal = total.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );

    return 'Rp $formattedTotal';
  }
}
