import 'package:flutter/material.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/mitra_repository.dart';
import '../../../core/services/bumdes_repository.dart';
import '../../../core/services/chat_repository.dart';

class ChatContact {
  final String id;
  final String name;
  final String lastMessage;
  final DateTime timestamp;
  final String avatar;
  final int unreadCount;
  final bool isOnline;
  final String userType; // 'mitra' or 'bumdes'

  ChatContact({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.timestamp,
    required this.avatar,
    this.unreadCount = 0,
    this.isOnline = false,
    required this.userType,
  });
}

class ChatListViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final MitraRepository _mitraRepository = MitraRepository();
  final BumdesRepository _bumdesRepository = BumdesRepository();
  final ChatRepository _chatRepository = ChatRepository();

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
      // Get current user info
      final currentUserType = await _authService.getUserType();
      final currentUserId = await _authService.getUserId();
      
      debugPrint('🔍 Loading chat list for $currentUserType (ID: $currentUserId)');

      List<ChatContact> contacts = [];

      if (currentUserType == 'mitra') {
        // If user is mitra, fetch all bumdes as potential contacts
        final bumdesList = await _bumdesRepository.getAllBumdes();
        
        for (var bumdes in bumdesList) {
          // Get last message for this conversation
          String lastMessage = 'Tap untuk memulai percakapan';
          DateTime lastMessageTime = DateTime.now();
          int unreadCount = 0;
          
          try {
            final messages = await _chatRepository.getConversation(
              currentUserId ?? '',
              bumdes.idBumdes,
            );
            
            if (messages.isNotEmpty) {
              // Sort messages by timestamp
              messages.sort((a, b) => b.sentAt.compareTo(a.sentAt));
              final latestMessage = messages.first;
              
              lastMessage = latestMessage.message;
              lastMessageTime = latestMessage.sentAt;
              
              // Count unread messages
              unreadCount = messages.where((msg) => 
                !msg.isRead && msg.senderType == 'bumdes'
              ).length;
            }
          } catch (e) {
            debugPrint('⚠️ No conversation yet with ${bumdes.namaBumdes}');
          }
          
          contacts.add(ChatContact(
            id: bumdes.idBumdes,
            name: bumdes.namaBumdes,
            lastMessage: lastMessage,
            timestamp: lastMessageTime,
            avatar: bumdes.namaBumdes.isNotEmpty ? bumdes.namaBumdes[0].toUpperCase() : 'B',
            unreadCount: unreadCount,
            isOnline: true, // Can be enhanced with real online status
            userType: 'bumdes',
          ));
        }
      } else if (currentUserType == 'bumdes') {
        // If user is bumdes, fetch all mitra as potential contacts
        final mitraList = await _mitraRepository.getAllMitra();
        
        for (var mitra in mitraList) {
          // Get last message for this conversation
          String lastMessage = 'Tap untuk memulai percakapan';
          DateTime lastMessageTime = DateTime.now();
          int unreadCount = 0;
          
          try {
            final messages = await _chatRepository.getConversation(
              mitra.idMitra,
              currentUserId ?? '',
            );
            
            if (messages.isNotEmpty) {
              // Sort messages by timestamp
              messages.sort((a, b) => b.sentAt.compareTo(a.sentAt));
              final latestMessage = messages.first;
              
              lastMessage = latestMessage.message;
              lastMessageTime = latestMessage.sentAt;
              
              // Count unread messages
              unreadCount = messages.where((msg) => 
                !msg.isRead && msg.senderType == 'mitra'
              ).length;
            }
          } catch (e) {
            debugPrint('⚠️ No conversation yet with ${mitra.namaMitra}');
          }
          
          contacts.add(ChatContact(
            id: mitra.idMitra,
            name: mitra.namaMitra,
            lastMessage: lastMessage,
            timestamp: lastMessageTime,
            avatar: mitra.namaMitra.isNotEmpty ? mitra.namaMitra[0].toUpperCase() : 'M',
            unreadCount: unreadCount,
            isOnline: true, // Can be enhanced with real online status
            userType: 'mitra',
          ));
        }
      }

      // Sort contacts by timestamp (most recent first)
      contacts.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      
      // Filter to only show contacts with existing conversations if needed
      // For now, show all potential contacts
      _chatList = contacts;
      
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
  
  Future<void> refreshChatList() async {
    await _loadChatList();
  }
}
