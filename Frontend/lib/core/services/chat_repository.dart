import '../models/chat_model.dart';
import '../services/api_service.dart';
import '../config/api_config.dart';

class ChatRepository {
  final ApiService _apiService = ApiService();

  // Get all chat messages
  Future<List<ChatModel>> getAllMessages() async {
    try {
      final response = await _apiService.get(ApiConfig.chat);
      
      if (response is List) {
        return response.map((json) => ChatModel.fromJson(Map<String, dynamic>.from(json))).toList();
      }
      
      throw Exception('Invalid response format');
    } catch (e) {
      throw Exception('Failed to fetch messages: $e');
    }
  }

  // Get conversation between Mitra and BumDes
  Future<List<ChatModel>> getConversation(String mitraId, String bumdesId) async {
    try {
      final response = await _apiService.get(
        ApiConfig.chatConversation,
        queryParams: {
          'idMitra': mitraId,
          'idBumDes': bumdesId,
        },
      );
      
      if (response['success'] == true && response['data'] is List) {
        return (response['data'] as List)
            .map((json) => ChatModel.fromJson(Map<String, dynamic>.from(json)))
            .toList();
      }
      
      throw Exception('Invalid response format');
    } catch (e) {
      throw Exception('Failed to fetch conversation: $e');
    }
  }

  // Send a message
  Future<ChatModel> sendMessage(ChatModel message) async {
    try {
      final response = await _apiService.post(
        ApiConfig.chat,
        body: message.toJson(),
      );
      
      if (response['success'] == true && response['data'] != null) {
        return ChatModel.fromJson(Map<String, dynamic>.from(response['data']));
      }
      
      throw Exception(response['message'] ?? 'Failed to send message');
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  // Mark message as read
  Future<void> markAsRead(String chatId) async {
    try {
      await _apiService.post('/chat/$chatId/mark-read');
    } catch (e) {
      throw Exception('Failed to mark message as read: $e');
    }
  }

  // Get unread messages count
  Future<int> getUnreadCount() async {
    try {
      final messages = await getAllMessages();
      return messages.where((msg) => msg.status != 'read').length;
    } catch (e) {
      throw Exception('Failed to get unread count: $e');
    }
  }
}
