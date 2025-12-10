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

  void _loadNotifications() {
    _isLoading = true;
    notifyListeners();

    // Dummy notifications dengan berbagai tipe
    _notifications = [
      NotificationItem(
        id: '1',
        title: 'Pesanan Berhasil',
        message: 'Pesanan Padi IR64 Anda telah dikonfirmasi oleh BUMDes',
        timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
        type: NotificationType.order,
        isRead: false,
        actionData: {'route': 'cart'},
      ),

      NotificationItem(
        id: '2',
        title: 'Produk Best Seller!',
        message: 'Padi Varietas IR64 menjadi produk terlaris minggu ini',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        type: NotificationType.promo,
        isRead: false,
        actionData: {
          'route': 'product_detail',
          'product': {
            'name': 'Padi Varietas IR64',
            'category': 'Padi',
            'price': 'Rp 11.500/kg',
            'stock': 'Stok: 800kg',
            'rating': '4.9',
            'image': 'assets/images/padi 2.jpg',
            'isPreOrder': 'true',
          },
        },
      ),
      NotificationItem(
        id: '3',
        title: 'Pesan Baru dari BUMDes',
        message: 'BUMDes Makmur Jaya: Baik, saya akan kirim detailnya segera',
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        type: NotificationType.chat,
        isRead: false,
        actionData: {
          'route': 'chat',
          'contactName': 'BUMDes Makmur Jaya',
          'contactId': 'bumdes_001',
        },
      ),
      NotificationItem(
        id: '4',
        title: 'Pembayaran Berhasil',
        message: 'Pembayaran pesanan sebesar Rp 250.000 telah diterima',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        type: NotificationType.payment,
        isRead: true,
        actionData: {'route': 'cart'},
      ),
      NotificationItem(
        id: '5',
        title: 'Update Sistem',
        message: 'Aplikasi telah diperbarui dengan fitur chat dan notifikasi',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        type: NotificationType.system,
        isRead: true,
      ),
    ];

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
