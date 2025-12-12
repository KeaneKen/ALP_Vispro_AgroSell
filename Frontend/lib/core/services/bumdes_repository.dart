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
      final allBumdes = await getAllBumdes();
      
      for (var bumdes in allBumdes) {
        if (bumdes.emailBumdes == email && bumdes.passwordBumdes == password) {
          return bumdes;
        }
      }
      
      return null;
    } catch (e) {
      throw Exception('Failed to login: $e');
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
}
