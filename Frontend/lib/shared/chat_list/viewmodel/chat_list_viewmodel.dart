import 'package:flutter/material.dart';

class ChatContact {
  final String id;
  final String name;
  final String lastMessage;
  final DateTime timestamp;
  final String avatar;
  final int unreadCount;
  final bool isOnline;

  ChatContact({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.timestamp,
    required this.avatar,
    this.unreadCount = 0,
    this.isOnline = false,
  });
}

class ChatListViewModel extends ChangeNotifier {
  List<ChatContact> _chatList = [];
  bool _isLoading = false;

  List<ChatContact> get chatList => _chatList;
  bool get isLoading => _isLoading;

  ChatListViewModel() {
    _loadChatList();
  }

  void _loadChatList() {
    _isLoading = true;
    notifyListeners();

    // Dummy data - list orang yang di chat (hanya BUMDes)
    _chatList = [
      ChatContact(
        id: 'bumdes_001',
        name: 'BUMDes Makmur Jaya',
        lastMessage: 'Baik, saya akan kirim detailnya segera',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        avatar: 'B',
        unreadCount: 2,
        isOnline: true,
      ),
    ];

    _isLoading = false;
    notifyListeners();
  }

  void deleteChat(String id) {
    _chatList.removeWhere((chat) => chat.id == id);
    notifyListeners();
  }
}
