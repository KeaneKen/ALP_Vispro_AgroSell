import 'package:flutter/foundation.dart';
import '../models/riwayat_model.dart';
import '../services/api_service.dart';
import '../config/api_config.dart';

class RiwayatRepository {
  final ApiService _apiService = ApiService();

  /// Get all riwayat (order history)
  Future<List<RiwayatModel>> getAllRiwayat() async {
    try {
      final response = await _apiService.get(ApiConfig.riwayat);
      
      if (response['success'] == true && response['data'] != null) {
        final data = response['data'] as List;
        return data.map((json) => RiwayatModel.fromJson(json)).toList();
      }
      
      throw Exception('Invalid response format');
    } catch (e) {
      throw Exception('Failed to fetch riwayat: $e');
    }
  }

  /// Get riwayat by ID
  Future<RiwayatModel> getRiwayatById(String id) async {
    try {
      final response = await _apiService.get('${ApiConfig.riwayat}/$id');
      
      if (response['success'] == true && response['data'] != null) {
        return RiwayatModel.fromJson(response['data']);
      }
      
      throw Exception('Riwayat not found');
    } catch (e) {
      throw Exception('Failed to fetch riwayat: $e');
    }
  }

  /// Create riwayat (add to order history)
  Future<RiwayatModel> createRiwayat(
    String idPayment, {
    String status = 'processing',
    String? deliveryAddress,
    String? phoneNumber,
    String? notes,
  }) async {
    try {
      debugPrint('📜 Creating riwayat - idPayment: $idPayment, status: $status');
      
      final Map<String, dynamic> body = {
        'idPayment': idPayment,
        'status': status,
      };
      
      if (deliveryAddress != null) body['delivery_address'] = deliveryAddress;
      if (phoneNumber != null) body['phone_number'] = phoneNumber;
      if (notes != null) body['notes'] = notes;
      
      debugPrint('📜 Request body: $body');
      debugPrint('📜 Calling API: ${ApiConfig.riwayat}');

      final response = await _apiService.post(
        ApiConfig.riwayat,
        body: body,
      );
      
      debugPrint('📜 API Response: $response');
      
      if (response['success'] == true && response['data'] != null) {
        debugPrint('✅ Riwayat created successfully');
        return RiwayatModel.fromJson(response['data']);
      }
      
      debugPrint('❌ Failed to create riwayat: ${response['message']}');
      throw Exception(response['message'] ?? 'Failed to create riwayat');
    } catch (e) {
      debugPrint('❌ Exception creating riwayat: $e');
      throw Exception('Failed to create riwayat: $e');
    }
  }

  /// Delete riwayat
  Future<void> deleteRiwayat(String idHistory) async {
    try {
      final response = await _apiService.delete('${ApiConfig.riwayat}/$idHistory');
      
      if (response != null && response['success'] == false) {
        throw Exception(response['message'] ?? 'Failed to delete riwayat');
      }
    } catch (e) {
      throw Exception('Failed to delete riwayat: $e');
    }
  }

  /// Get riwayat by payment ID
  Future<List<RiwayatModel>> getRiwayatByPaymentId(String idPayment) async {
    try {
      final allRiwayat = await getAllRiwayat();
      return allRiwayat.where((riwayat) => riwayat.idPayment == idPayment).toList();
    } catch (e) {
      throw Exception('Failed to fetch riwayat by payment: $e');
    }
  }

  /// Get order history sorted by most recent
  Future<List<RiwayatModel>> getOrderHistory() async {
    try {
      final allRiwayat = await getAllRiwayat();
      // Sort by created date, most recent first
      allRiwayat.sort((a, b) {
        if (a.createdAt == null || b.createdAt == null) return 0;
        return b.createdAt!.compareTo(a.createdAt!);
      });
      return allRiwayat;
    } catch (e) {
      throw Exception('Failed to fetch order history: $e');
    }
  }
  /// Update order status (for Bumdes to update, or Mitra to confirm completion)
  Future<RiwayatModel> updateOrderStatus(String idHistory, String newStatus) async {
    try {
      debugPrint('📝 Updating order status - idHistory: $idHistory, status: $newStatus');
      
      final body = {'status': newStatus};
      
      final response = await _apiService.put(
        '${ApiConfig.riwayat}/$idHistory',
        body: body,
      );
      
      debugPrint('📝 API Response: $response');
      
      if (response['success'] == true && response['data'] != null) {
        debugPrint('✅ Order status updated successfully');
        return RiwayatModel.fromJson(response['data']);
      }
      
      throw Exception(response['message'] ?? 'Failed to update order status');
    } catch (e) {
      debugPrint('❌ Exception updating order status: $e');
      throw Exception('Failed to update order status: $e');
    }
  }}
