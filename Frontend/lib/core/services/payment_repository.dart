import 'package:flutter/foundation.dart';
import '../models/payment_model.dart';
import '../services/api_service.dart';
import '../config/api_config.dart';

class PaymentRepository {
  final ApiService _apiService = ApiService();

  /// Get all payments
  Future<List<PaymentModel>> getAllPayments() async {
    try {
      final response = await _apiService.get(ApiConfig.payment);
      
      if (response['success'] == true && response['data'] != null) {
        final data = response['data'] as List;
        return data.map((json) => PaymentModel.fromJson(json)).toList();
      }
      
      throw Exception('Invalid response format');
    } catch (e) {
      throw Exception('Failed to fetch payments: $e');
    }
  }

  /// Get payment by ID
  Future<PaymentModel> getPaymentById(String id) async {
    try {
      final response = await _apiService.get('${ApiConfig.payment}/$id');
      
      if (response['success'] == true && response['data'] != null) {
        return PaymentModel.fromJson(response['data']);
      }
      
      throw Exception('Payment not found');
    } catch (e) {
      throw Exception('Failed to fetch payment: $e');
    }
  }

  /// Create payment (mock payment processing)
  Future<PaymentModel> createPayment(String idCart, double totalHarga) async {
    try {
      debugPrint('💳 Creating payment - idCart: $idCart, totalHarga: $totalHarga');
      
      final body = {
        'idCart': idCart,
        'Total_Harga': totalHarga,
      };
      
      debugPrint('💳 Request body: $body');
      debugPrint('💳 Calling API: ${ApiConfig.payment}');

      final response = await _apiService.post(
        ApiConfig.payment,
        body: body,
      );
      
      debugPrint('💳 API Response: $response');
      
      if (response['success'] == true && response['data'] != null) {
        debugPrint('✅ Payment created successfully');
        return PaymentModel.fromJson(response['data']);
      }
      
      debugPrint('❌ Failed to create payment: ${response['message']}');
      throw Exception(response['message'] ?? 'Failed to create payment');
    } catch (e) {
      debugPrint('❌ Exception creating payment: $e');
      throw Exception('Failed to create payment: $e');
    }
  }

  /// Delete payment
  Future<void> deletePayment(String idPayment) async {
    try {
      final response = await _apiService.delete('${ApiConfig.payment}/$idPayment');
      
      if (response != null && response['success'] == false) {
        throw Exception(response['message'] ?? 'Failed to delete payment');
      }
    } catch (e) {
      throw Exception('Failed to delete payment: $e');
    }
  }

  /// Get payments by cart ID (if needed)
  Future<List<PaymentModel>> getPaymentsByCartId(String idCart) async {
    try {
      final allPayments = await getAllPayments();
      return allPayments.where((payment) => payment.idCart == idCart).toList();
    } catch (e) {
      throw Exception('Failed to fetch payments by cart: $e');
    }
  }
}
