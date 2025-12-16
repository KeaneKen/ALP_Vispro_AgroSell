import 'package:flutter/foundation.dart';
import '../config/api_config.dart';
import 'api_service.dart';

class PreOrderRepository {
  final ApiService _apiService = ApiService();

  /// Get all pre-orders, optionally filtered
  Future<List<Map<String, dynamic>>> getAllPreOrders({
    String? status,
    String? idMitra,
    String? idBumDES,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (status != null) queryParams['status'] = status;
      if (idMitra != null) queryParams['idMitra'] = idMitra;
      if (idBumDES != null) queryParams['idBumDES'] = idBumDES;

      final endpoint = queryParams.isEmpty
          ? ApiConfig.preorders
          : '${ApiConfig.preorders}?${Uri(queryParameters: queryParams).query}';

      final response = await _apiService.get(endpoint);

      if (response['success'] == true && response['data'] is List) {
        return List<Map<String, dynamic>>.from(response['data']);
      }
      return [];
    } catch (e) {
      debugPrint('❌ Error fetching pre-orders: $e');
      return [];
    }
  }

  /// Get single pre-order detail
  Future<Map<String, dynamic>?> getPreOrderById(String id) async {
    try {
      final response = await _apiService.get('${ApiConfig.preorders}/$id');

      if (response['success'] == true && response['data'] != null) {
        return Map<String, dynamic>.from(response['data']);
      }
      return null;
    } catch (e) {
      debugPrint('❌ Error fetching pre-order detail: $e');
      return null;
    }
  }

  /// Create new pre-order
  Future<String?> createPreOrder(Map<String, dynamic> data) async {
    try {
      final response = await _apiService.post(ApiConfig.preorders, body: data);

      if (response['success'] == true && response['data'] != null) {
        return response['data']['id'];
      }
      return null;
    } catch (e) {
      debugPrint('❌ Error creating pre-order: $e');
      return null;
    }
  }

  /// Update pre-order
  Future<bool> updatePreOrder(String id, Map<String, dynamic> data) async {
    try {
      final response = await _apiService.put('${ApiConfig.preorders}/$id', body: data);
      return response['success'] == true;
    } catch (e) {
      debugPrint('❌ Error updating pre-order: $e');
      return false;
    }
  }

  /// Approve pre-order
  Future<bool> approvePreOrder(String id) async {
    try {
      final response = await _apiService.post('${ApiConfig.preorders}/$id/approve', body: {});
      return response['success'] == true;
    } catch (e) {
      debugPrint('❌ Error approving pre-order: $e');
      return false;
    }
  }
}
