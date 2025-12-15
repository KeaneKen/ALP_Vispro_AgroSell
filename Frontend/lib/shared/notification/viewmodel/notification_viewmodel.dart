import 'package:flutter/material.dart';
import '../../../core/services/chat_repository.dart';
import '../../../core/services/pangan_repository.dart';
import '../../../core/models/chat_model.dart';
import '../../../core/models/pangan_model.dart';

enum NotificationType {
  order,
  preOrder,
  payment,
  chat,
  promo,
  system,
  pangan, // New product notification
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
  final ChatRepository _chatRepository = ChatRepository();
  final PanganRepository _panganRepository = PanganRepository();
  
  List<NotificationItem> _notifications = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<NotificationItem> get notifications => _notifications;
  bool get isLoading => _isLoading;
  int get unreadCount => _notifications.where((n) => !n.isRead).length;
  String? get errorMessage => _errorMessage;

  NotificationViewModel() {
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final List<NotificationItem> allNotifications = [];

      // Fetch recent chats
      try {
        final chats = await _chatRepository.getAllMessages();
        final chatNotifications = _convertChatsToNotifications(chats);
        allNotifications.addAll(chatNotifications);
      } catch (e) {
        debugPrint('Error fetching chats for notifications: $e');
      }

      // Fetch recent pangans
      try {
        final pangans = await _panganRepository.getAllPangan();
        final panganNotifications = _convertPangansToNotifications(pangans);
        allNotifications.addAll(panganNotifications);
      } catch (e) {
        debugPrint('Error fetching pangans for notifications: $e');
      }

      // Sort by timestamp (newest first)
      allNotifications.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      
      // Limit to 50 most recent notifications
      _notifications = allNotifications.take(50).toList();
    } catch (e) {
      debugPrint('Error loading notifications: $e');
      _errorMessage = 'Gagal memuat notifikasi';
    }
    
    _isLoading = false;
    notifyListeners();
  }

  /// Convert chat messages to notification items
  List<NotificationItem> _convertChatsToNotifications(List<ChatModel> chats) {
    // Group by conversation and get latest message per conversation
    final Map<String, ChatModel> latestMessages = {};
    
    for (final chat in chats) {
      final conversationKey = '${chat.idMitra}_${chat.idBumDes}';
      
      if (!latestMessages.containsKey(conversationKey) ||
          chat.sentAt.isAfter(latestMessages[conversationKey]!.sentAt)) {
        latestMessages[conversationKey] = chat;
      }
    }

    return latestMessages.values.map((chat) {
      final senderLabel = chat.isSentByMitra ? 'Mitra' : 'BumDes';
      return NotificationItem(
        id: 'chat_${chat.idChat}',
        title: 'Pesan dari $senderLabel',
        message: chat.message.length > 50 
            ? '${chat.message.substring(0, 50)}...' 
            : chat.message,
        timestamp: chat.sentAt,
        type: NotificationType.chat,
        isRead: chat.isRead,
        actionData: {
          'idMitra': chat.idMitra,
          'idBumDes': chat.idBumDes,
          'senderType': chat.senderType,
        },
      );
    }).toList();
  }

  /// Convert pangan items to notification items (show recently added products)
  List<NotificationItem> _convertPangansToNotifications(List<PanganModel> pangans) {
    // Filter pangans created in the last 7 days
    final now = DateTime.now();
    final recentPangans = pangans.where((pangan) {
      if (pangan.createdAt == null) return false;
      return now.difference(pangan.createdAt!).inDays <= 7;
    }).toList();

    return recentPangans.map((pangan) {
      return NotificationItem(
        id: 'pangan_${pangan.idPangan}',
        title: 'Produk Baru: ${pangan.namaPangan}',
        message: 'Rp ${pangan.hargaPangan.toStringAsFixed(0)} - ${pangan.category}',
        timestamp: pangan.createdAt ?? DateTime.now(),
        type: NotificationType.pangan,
        isRead: false,
        actionData: {
          'idPangan': pangan.idPangan,
          'namaPangan': pangan.namaPangan,
          'hargaPangan': pangan.hargaPangan,
        },
      );
    }).toList();
  }

  Future<void> refresh() async {
    await _loadNotifications();
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
      case NotificationType.pangan:
        return Icons.eco;
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
      case NotificationType.pangan:
        return Colors.teal;
    }
  }
}
