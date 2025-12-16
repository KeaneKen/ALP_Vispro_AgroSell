import 'package:flutter/foundation.dart';
import '../config/api_config.dart';
import 'api_service.dart';

class MetricsRepository {
  final ApiService _apiService = ApiService();

  /// Get dashboard metrics
  Future<Map<String, dynamic>?> getDashboardMetrics() async {
    try {
      final response = await _apiService.get(ApiConfig.metricsDashboard);

      if (response['success'] == true && response['data'] != null) {
        return Map<String, dynamic>.from(response['data']);
      }
      return null;
    } catch (e) {
      debugPrint('❌ Error fetching dashboard metrics: $e');
      return null;
    }
  }
}
