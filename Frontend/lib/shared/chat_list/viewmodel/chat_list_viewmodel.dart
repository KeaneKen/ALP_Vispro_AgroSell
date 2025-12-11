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

  Future<void> _loadChatList() async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Fetch chat list from backend API
      // await _chatRepository.getChatList();
      await Future.delayed(const Duration(milliseconds: 500));
      _chatList = [];
      
      debugPrint('💬 Chat list loaded: ${_chatList.length} contacts');
    } catch (e) {
      debugPrint('❌ Error loading chat list: $e');
      _chatList = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  void deleteChat(String id) {
    _chatList.removeWhere((chat) => chat.id == id);
    notifyListeners();
  }
}
