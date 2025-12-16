import 'package:flutter/foundation.dart';
import '../models/cart_model.dart';
import '../services/api_service.dart';
import '../config/api_config.dart';

class CartRepository {
  final ApiService _apiService = ApiService();

  /// Get all cart items
  Future<List<CartModel>> getAllCartItems() async {
    try {
      final response = await _apiService.get(ApiConfig.cart);
      
      if (response['success'] == true && response['data'] != null) {
        final data = response['data'] as List;
        return data.map((json) => CartModel.fromJson(json)).toList();
      }
      
      throw Exception('Invalid response format');
    } catch (e) {
      throw Exception('Failed to fetch cart items: $e');
    }
  }

  /// Get cart item by ID
  Future<CartModel> getCartItemById(String id) async {
    try {
      final response = await _apiService.get('${ApiConfig.cart}/$id');
      
      if (response['success'] == true && response['data'] != null) {
        return CartModel.fromJson(response['data']);
      }
      
      throw Exception('Cart item not found');
    } catch (e) {
      throw Exception('Failed to fetch cart item: $e');
    }
  }

  /// Add item to cart (save to database)
  Future<CartModel> addToCart(String idPangan, int quantity) async {
    try {
      debugPrint('🛒 Adding to cart - idPangan: $idPangan, quantity: $quantity');
      
      final body = {
        'idPangan': idPangan,
        'Jumlah_Pembelian': quantity,
      };
      
      debugPrint('🛒 Request body: $body');
      debugPrint('🛒 Calling API: ${ApiConfig.cart}');

      final response = await _apiService.post(
        ApiConfig.cart,
        body: body,
      );
      
      debugPrint('🛒 API Response: $response');
      
      if (response['success'] == true && response['data'] != null) {
        debugPrint('✅ Cart item added successfully');
        return CartModel.fromJson(response['data']);
      }
      
      debugPrint('❌ Failed to add to cart: ${response['message']}');
      throw Exception(response['message'] ?? 'Failed to add to cart');
    } catch (e) {
      debugPrint('❌ Exception adding to cart: $e');
      throw Exception('Failed to add to cart: $e');
    }
  }

  /// Update cart item quantity
  Future<CartModel> updateCartItem(String idCart, int newQuantity) async {
    try {
      final body = {
        'Jumlah_Pembelian': newQuantity,
      };

      final response = await _apiService.put(
        '${ApiConfig.cart}/$idCart',
        body: body,
      );
      
      if (response['success'] == true && response['data'] != null) {
        return CartModel.fromJson(response['data']);
      }
      
      throw Exception(response['message'] ?? 'Failed to update cart');
    } catch (e) {
      throw Exception('Failed to update cart: $e');
    }
  }

  /// Remove item from cart
  Future<void> removeFromCart(String idCart) async {
    try {
      final response = await _apiService.delete('${ApiConfig.cart}/$idCart');
      
      if (response != null && response['success'] == false) {
        throw Exception(response['message'] ?? 'Failed to remove from cart');
      }
    } catch (e) {
      throw Exception('Failed to remove from cart: $e');
    }
  }

  /// Clear all cart items
  Future<void> clearCart() async {
    try {
      final cartItems = await getAllCartItems();
      
      for (var item in cartItems) {
        await removeFromCart(item.idCart);
      }
    } catch (e) {
      throw Exception('Failed to clear cart: $e');
    }
  }

  /// Get total cart value
  Future<double> getCartTotal() async {
    try {
      final cartItems = await getAllCartItems();
      
      double total = 0;
      for (var item in cartItems) {
        if (item.pangan != null) {
          total += item.pangan!.hargaPangan * item.jumlahPembelian;
        }
      }
      
      return total;
    } catch (e) {
      throw Exception('Failed to calculate cart total: $e');
    }
  }

  /// Get total items count in cart
  Future<int> getCartItemCount() async {
    try {
      final cartItems = await getAllCartItems();
      return cartItems.fold<int>(0, (sum, item) => sum + item.jumlahPembelian);
    } catch (e) {
      throw Exception('Failed to get cart item count: $e');
    }
  }
}
