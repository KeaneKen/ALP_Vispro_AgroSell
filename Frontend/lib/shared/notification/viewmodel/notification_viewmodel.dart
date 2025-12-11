import 'package:flutter/material.dart';

enum NotificationType {
  order,
  preOrder,
  payment,
  chat,
  promo,
  system,
}

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final NotificationType type;
  final bool isRead;
  final Map<String, dynamic>? actionData;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.type,
    this.isRead = false,
    this.actionData,
  });
}

class NotificationViewModel extends ChangeNotifier {
  List<NotificationItem> _notifications = [];
  bool _isLoading = false;

  List<NotificationItem> get notifications => _notifications;
  bool get isLoading => _isLoading;
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  NotificationViewModel() {
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Fetch notifications from backend API
      // For now, empty list until backend endpoint is ready
      await Future.delayed(const Duration(milliseconds: 500));
      _notifications = [];
    } catch (e) {
      debugPrint('❌ Error loading notifications: $e');
      _notifications = [];
    }
    
    _isLoading = false;
    notifyListeners();
  }



  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1 && !_notifications[index].isRead) {
      _notifications[index] = NotificationItem(
        id: _notifications[index].id,
        title: _notifications[index].title,
        message: _notifications[index].message,
        timestamp: _notifications[index].timestamp,
        type: _notifications[index].type,
        isRead: true,
        actionData: _notifications[index].actionData,
      );
      notifyListeners();
    }
  }

  void markAllAsRead() {
    _notifications = _notifications.map((n) {
      return NotificationItem(
        id: n.id,
        title: n.title,
        message: n.message,
        timestamp: n.timestamp,
        type: n.type,
        isRead: true,
        actionData: n.actionData,
      );
    }).toList();
    notifyListeners();
  }

  void deleteNotification(String id) {
    _notifications.removeWhere((n) => n.id == id);
    notifyListeners();
  }

  IconData getIconForType(NotificationType type) {
    switch (type) {
      case NotificationType.order:
        return Icons.shopping_bag;
      case NotificationType.preOrder:
        return Icons.event_available;
      case NotificationType.payment:
        return Icons.payment;
      case NotificationType.chat:
        return Icons.chat_bubble;
      case NotificationType.promo:
        return Icons.local_offer;
      case NotificationType.system:
        return Icons.info;
    }
  }

  Color getColorForType(NotificationType type) {
    switch (type) {
      case NotificationType.order:
        return Colors.green;
      case NotificationType.preOrder:
        return Colors.orange;
      case NotificationType.payment:
        return Colors.blue;
      case NotificationType.chat:
        return Colors.purple;
      case NotificationType.promo:
        return Colors.red;
      case NotificationType.system:
        return Colors.grey;
    }
  }
}
