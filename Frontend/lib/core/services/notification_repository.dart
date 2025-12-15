import 'package:flutter/foundation.dart';
import '../config/api_config.dart';
import 'api_service.dart';

class NotificationRepository {
  final ApiService _apiService = ApiService();

  /// Get notifications for a user
  Future<List<Map<String, dynamic>>> getNotifications({
    String? userId,
    String? userType,
    bool? isRead,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (userId != null) queryParams['user_id'] = userId;
      if (userType != null) queryParams['user_type'] = userType;
      if (isRead != null) queryParams['is_read'] = isRead.toString();

      final endpoint = queryParams.isEmpty
          ? ApiConfig.notifications
          : '${ApiConfig.notifications}?${Uri(queryParameters: queryParams).query}';

      final response = await _apiService.get(endpoint);

      if (response['success'] == true && response['data'] is List) {
        return List<Map<String, dynamic>>.from(response['data']);
      }
      return [];
    } catch (e) {
      debugPrint('❌ Error fetching notifications: $e');
      return [];
    }
  }

  /// Mark notification as read
  Future<bool> markAsRead(int id) async {
    try {
      final response = await _apiService.post(
        '${ApiConfig.notifications}/$id/mark-read',
        body: {},
      );
      return response['success'] == true;
    } catch (e) {
      debugPrint('❌ Error marking notification as read: $e');
      return false;
    }
  }
}
