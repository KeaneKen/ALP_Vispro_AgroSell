import '../models/bumdes_model.dart';
import '../services/api_service.dart';
import '../config/api_config.dart';
import 'package:flutter/foundation.dart';

class BumdesRepository {
  final ApiService _apiService = ApiService();

  // Get all bumdes
  Future<List<BumdesModel>> getAllBumdes() async {
    try {
      final response = await _apiService.get(ApiConfig.bumdes);
      
      if (response is List) {
        return response.map((json) => BumdesModel.fromJson(Map<String, dynamic>.from(json))).toList();
      }
      
      throw Exception('Invalid response format');
    } catch (e) {
      throw Exception('Failed to fetch bumdes: $e');
    }
  }

  // Get bumdes by ID
  Future<BumdesModel> getBumdesById(String id) async {
    try {
      final response = await _apiService.get('${ApiConfig.bumdes}/$id');
      
      // Handle response format with success wrapper
      if (response is Map && response['success'] == true && response['data'] != null) {
        return BumdesModel.fromJson(Map<String, dynamic>.from(response['data']));
      } else if (response is Map && response['idBumDES'] != null) {
        // Direct bumdes object
        return BumdesModel.fromJson(Map<String, dynamic>.from(response));
      }
      
      throw Exception('Invalid response format');
    } catch (e) {
      throw Exception('Failed to fetch bumdes: $e');
    }
  }

  // Create new bumdes (Register)
  Future<BumdesModel> createBumdes(BumdesModel bumdes) async {
    try {
      final response = await _apiService.post(
        ApiConfig.bumdes,
        body: bumdes.toCreateJson(),
      );
      
      if (response['success'] == true && response['data'] != null) {
        return BumdesModel.fromJson(Map<String, dynamic>.from(response['data']));
      }
      
      throw Exception(response['message'] ?? 'Failed to create bumdes');
    } catch (e) {
      throw Exception('Failed to create bumdes: $e');
    }
  }

  // Update bumdes
  Future<BumdesModel> updateBumdes(String id, BumdesModel bumdes) async {
    try {
      final response = await _apiService.put(
        '${ApiConfig.bumdes}/$id',
        body: bumdes.toCreateJson(),
      );
      
      if (response['success'] == true && response['data'] != null) {
        return BumdesModel.fromJson(Map<String, dynamic>.from(response['data']));
      }
      
      throw Exception(response['message'] ?? 'Failed to update bumdes');
    } catch (e) {
      throw Exception('Failed to update bumdes: $e');
    }
  }

  // Delete bumdes
  Future<void> deleteBumdes(String id) async {
    try {
      await _apiService.delete('${ApiConfig.bumdes}/$id');
    } catch (e) {
      throw Exception('Failed to delete bumdes: $e');
    }
  }

  // Login bumdes
  Future<BumdesModel?> loginBumdes(String email, String password) async {
    try {
      final response = await _apiService.post(
        '${ApiConfig.bumdes}/login',
        body: {
          'Email_BumDES': email,
          'Password_BumDES': password,
        },
      );
      
      if (response['success'] == true && response['data'] != null) {
        return BumdesModel.fromJson(Map<String, dynamic>.from(response['data']));
      }
      
      return null;
    } catch (e) {
      // If it's a 401 or 404, return null so the viewmodel can handle it
      if (e.toString().contains('401') || e.toString().contains('404')) {
        return null;
      }
      // For other errors, rethrow or return null depending on desired behavior
      // Returning null will result in "Email or password wrong" message
      return null;
    }
  }

  /// Get profile statistics from backend
  Future<Map<String, dynamic>> getProfileStats() async {
    try {
      debugPrint('📊 Fetching profile stats from backend...');
      
      // Get cart count (pre-orders)
      final cartResponse = await _apiService.get(ApiConfig.cart);
      final cartCount = cartResponse is List ? cartResponse.length : 0;

      // Get pangan count (total stock items)
      final panganResponse = await _apiService.get(ApiConfig.pangans);
      final panganCount = panganResponse is List ? panganResponse.length : 0;

      // Get payment count
      final paymentResponse = await _apiService.get(ApiConfig.payments);
      final paymentCount = paymentResponse is List ? paymentResponse.length : 0;

      // Calculate total stock (sum of all pangan items)
      int totalStock = 0;
      if (panganResponse is List) {
        // Placeholder calculation - each item adds 100 to stock
        totalStock = panganResponse.length * 100; // Adjust based on actual stock field
      }

      // Calculate monthly income from payments
      double monthlyIncome = 0;
      if (paymentResponse is List) {
        for (var payment in paymentResponse) {
          monthlyIncome += double.tryParse(payment['Total_Pembayaran']?.toString() ?? '0') ?? 0;
        }
      }

      debugPrint('✅ Profile stats loaded: Cart=$cartCount, Pangan=$panganCount, Payments=$paymentCount');

      return {
        'preOrderCount': cartCount,
        'buyNowCount': paymentCount,
        'pendingDeliveryCount': paymentCount,
        'totalStock': totalStock,
        'panganCount': panganCount,
        'monthlyIncome': monthlyIncome,
      };
    } catch (e) {
      debugPrint('❌ Error fetching profile stats: $e');
      return {
        'preOrderCount': 0,
        'buyNowCount': 0,
        'pendingDeliveryCount': 0,
        'totalStock': 0,
        'panganCount': 0,
        'monthlyIncome': 0.0,
      };
    }
  }

  /// Get recent activities from backend
  Future<List<Map<String, dynamic>>> getRecentActivities() async {
    try {
      final response = await _apiService.get(ApiConfig.payments);
      
      if (response is List) {
        return response.take(5).map((payment) {
          final cart = payment['cart'] ?? {};
          final pangan = cart['pangan'] ?? {};
          final productName = pangan['namaPangan'] ?? 'Produk';
          final totalHarga = double.tryParse(payment['Total_Harga']?.toString() ?? '0') ?? 0;
          final dateStr = payment['created_at'];
          
          // Format time
          String timeAgo = 'Baru saja';
          if (dateStr != null) {
            final date = DateTime.parse(dateStr);
            final diff = DateTime.now().difference(date);
            if (diff.inDays > 0) {
              timeAgo = '${diff.inDays} hari lalu';
            } else if (diff.inHours > 0) {
              timeAgo = '${diff.inHours} jam lalu';
            } else if (diff.inMinutes > 0) {
              timeAgo = '${diff.inMinutes} menit lalu';
            }
          }

          // Format currency
          String valueStr = '';
          if (totalHarga >= 1000000) {
            valueStr = '+Rp ${(totalHarga / 1000000).toStringAsFixed(1)}jt';
          } else {
            valueStr = '+Rp ${(totalHarga / 1000).toStringAsFixed(0)}rb';
          }

          return {
            'type': 'penjualan',
            'title': 'Penjualan $productName',
            'time': timeAgo,
            'value': valueStr,
          };
        }).toList();
      }
      return [];
    } catch (e) {
      debugPrint('Error fetching recent activities: $e');
      return [];
    }
  }
}
