import 'package:dio/dio.dart';
import '../core/config/api_config.dart';

class RiwayatRepository {
  final Dio _dio = Dio();

  // Get all riwayat
  Future<Map<String, dynamic>> getAllRiwayat() async {
    try {
      final response = await _dio.get(
        '${ApiConfig.baseUrl}/riwayat',
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
        ),
      );
      return response.data;
    } catch (e) {
      throw Exception('Failed to fetch riwayat: $e');
    }
  }

  // Get riwayat by ID
  Future<Map<String, dynamic>> getRiwayatById(String id) async {
    try {
      final response = await _dio.get(
        '${ApiConfig.baseUrl}/riwayat/$id',
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
        ),
      );
      return response.data;
    } catch (e) {
      throw Exception('Failed to fetch riwayat: $e');
    }
  }

  // Get riwayat by mitra ID
  Future<Map<String, dynamic>> getRiwayatByMitra(String mitraId) async {
    try {
      final response = await _dio.get(
        '${ApiConfig.baseUrl}/riwayat/mitra/$mitraId',
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
        ),
      );
      return response.data;
    } catch (e) {
      throw Exception('Failed to fetch riwayat for mitra: $e');
    }
  }

  // Update order status (BumDES action)
  Future<Map<String, dynamic>> updateStatus(
    String id,
    String newStatus, {
    String? notes,
  }) async {
    try {
      final response = await _dio.put(
        '${ApiConfig.baseUrl}/riwayat/$id',
        data: {
          'status': newStatus,
          if (notes != null) 'notes': notes,
        },
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );
      return response.data;
    } catch (e) {
      throw Exception('Failed to update order status: $e');
    }
  }

  // Mitra confirms delivery (Pesanan Selesai)
  Future<Map<String, dynamic>> confirmDelivery(String id) async {
    try {
      final response = await _dio.post(
        '${ApiConfig.baseUrl}/riwayat/$id/confirm-delivery',
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
        ),
      );
      return response.data;
    } catch (e) {
      throw Exception('Failed to confirm delivery: $e');
    }
  }

  // Get status labels
  Future<Map<String, dynamic>> getStatusLabels() async {
    try {
      final response = await _dio.get(
        '${ApiConfig.baseUrl}/riwayat/status-labels/all',
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
        ),
      );
      return response.data;
    } catch (e) {
      throw Exception('Failed to fetch status labels: $e');
    }
  }

  // Create new riwayat (order history entry)
  Future<Map<String, dynamic>> createRiwayat({
    required String idPayment,
    String status = 'processing',
    String? deliveryAddress,
    String? phoneNumber,
    String? notes,
  }) async {
    try {
      final response = await _dio.post(
        '${ApiConfig.baseUrl}/riwayat',
        data: {
          'idPayment': idPayment,
          'status': status,
          if (deliveryAddress != null) 'delivery_address': deliveryAddress,
          if (phoneNumber != null) 'phone_number': phoneNumber,
          if (notes != null) 'notes': notes,
        },
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );
      return response.data;
    } catch (e) {
      throw Exception('Failed to create order history: $e');
    }
  }
}
