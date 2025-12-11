// Example file showing how to use ApiService in your viewmodels/controllers
// This is just for reference - adapt the patterns to your specific needs

import 'package:flutter/material.dart';
import 'api_service.dart';
import '../config/api_config.dart';

class ExampleApiUsage {
  final ApiService _apiService = ApiService();

  // Example: Fetch all products (Pangan)
  Future<List<dynamic>> fetchProducts() async {
    try {
      final response = await _apiService.get(ApiConfig.pangans);
      
      // Response is typically a JSON array
      if (response is List) {
        return response;
      } else if (response is Map && response.containsKey('data')) {
        return response['data'] as List;
      }
      return [];
    } on ApiException catch (e) {
      debugPrint('API Error: ${e.message}');
      throw e;
    } catch (e) {
      debugPrint('Unexpected error: $e');
      throw Exception('Failed to fetch products');
    }
  }

  // Example: Fetch single product by ID
  Future<Map<String, dynamic>?> fetchProductById(int id) async {
    try {
      final response = await _apiService.get('${ApiConfig.pangans}/$id');
      
      if (response is Map<String, dynamic>) {
        return response;
      } else if (response is Map && response.containsKey('data')) {
        return response['data'] as Map<String, dynamic>;
      }
      return null;
    } on ApiException catch (e) {
      debugPrint('API Error: ${e.message}');
      return null;
    }
  }

  // Example: Add item to cart
  Future<bool> addToCart(int productId, int quantity) async {
    try {
      final response = await _apiService.post(
        ApiConfig.cart,
        body: {
          'product_id': productId,
          'quantity': quantity,
        },
      );
      
      debugPrint('Cart response: $response');
      return true;
    } on ApiException catch (e) {
      debugPrint('Failed to add to cart: ${e.message}');
      return false;
    }
  }

  // Example: Update cart item
  Future<bool> updateCartItem(int cartId, int quantity) async {
    try {
      await _apiService.put(
        '${ApiConfig.cart}/$cartId',
        body: {'quantity': quantity},
      );
      return true;
    } on ApiException catch (e) {
      debugPrint('Failed to update cart: ${e.message}');
      return false;
    }
  }

  // Example: Delete cart item
  Future<bool> removeFromCart(int cartId) async {
    try {
      await _apiService.delete('${ApiConfig.cart}/$cartId');
      return true;
    } on ApiException catch (e) {
      debugPrint('Failed to remove from cart: ${e.message}');
      return false;
    }
  }

  // Example: Fetch chat messages
  Future<List<dynamic>> fetchChats() async {
    try {
      final response = await _apiService.get(ApiConfig.chat);
      
      if (response is List) {
        return response;
      } else if (response is Map && response.containsKey('data')) {
        return response['data'] as List;
      }
      return [];
    } on ApiException catch (e) {
      debugPrint('Failed to fetch chats: ${e.message}');
      return [];
    }
  }

  // Example: Send chat message
  Future<bool> sendMessage(String receiverId, String message) async {
    try {
      await _apiService.post(
        ApiConfig.chat,
        body: {
          'receiver_id': receiverId,
          'message': message,
        },
      );
      return true;
    } on ApiException catch (e) {
      debugPrint('Failed to send message: ${e.message}');
      return false;
    }
  }

  // Example: Fetch conversation between two participants
  Future<List<dynamic>> fetchConversation(String participant1Id, String participant2Id) async {
    try {
      final response = await _apiService.get(
        ApiConfig.chatConversation,
        queryParams: {
          'participant1': participant1Id,
          'participant2': participant2Id,
        },
      );
      
      if (response is List) {
        return response;
      } else if (response is Map && response.containsKey('data')) {
        return response['data'] as List;
      }
      return [];
    } on ApiException catch (e) {
      debugPrint('Failed to fetch conversation: ${e.message}');
      return [];
    }
  }

  // Example: Submit payment
  Future<Map<String, dynamic>?> submitPayment({
    required double amount,
    required String paymentMethod,
    required List<int> cartItemIds,
  }) async {
    try {
      final response = await _apiService.post(
        ApiConfig.payment,
        body: {
          'amount': amount,
          'payment_method': paymentMethod,
          'cart_items': cartItemIds,
        },
      );
      
      if (response is Map<String, dynamic>) {
        return response;
      }
      return null;
    } on ApiException catch (e) {
      debugPrint('Payment failed: ${e.message}');
      throw Exception(e.message);
    }
  }

  // Example: Fetch order history
  Future<List<dynamic>> fetchOrderHistory() async {
    try {
      final response = await _apiService.get(ApiConfig.riwayat);
      
      if (response is List) {
        return response;
      } else if (response is Map && response.containsKey('data')) {
        return response['data'] as List;
      }
      return [];
    } on ApiException catch (e) {
      debugPrint('Failed to fetch history: ${e.message}');
      return [];
    }
  }

  // Example: Create new Mitra
  Future<bool> createMitra({
    required String name,
    required String email,
    required String phone,
    required String address,
  }) async {
    try {
      await _apiService.post(
        ApiConfig.mitras,
        body: {
          'name': name,
          'email': email,
          'phone': phone,
          'address': address,
        },
      );
      return true;
    } on ApiException catch (e) {
      debugPrint('Failed to create mitra: ${e.message}');
      return false;
    }
  }

  // Example: Update Mitra
  Future<bool> updateMitra(int mitraId, Map<String, dynamic> data) async {
    try {
      await _apiService.put('${ApiConfig.mitras}/$mitraId', body: data);
      return true;
    } on ApiException catch (e) {
      debugPrint('Failed to update mitra: ${e.message}');
      return false;
    }
  }
}

// Example ViewModel/Controller integration
class ProductViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<dynamic> _products = [];
  bool _isLoading = false;
  String? _error;

  List<dynamic> get products => _products;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.get(ApiConfig.pangans);
      
      if (response is List) {
        _products = response;
      } else if (response is Map && response.containsKey('data')) {
        _products = response['data'] as List;
      }
    } on ApiException catch (e) {
      _error = e.message;
      debugPrint('Error loading products: ${e.message}');
    } catch (e) {
      _error = 'An unexpected error occurred';
      debugPrint('Unexpected error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
