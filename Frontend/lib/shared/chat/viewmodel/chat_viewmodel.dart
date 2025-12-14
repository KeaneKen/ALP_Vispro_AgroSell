import 'package:flutter/material.dart';
import '../../../core/services/chat_repository.dart';
import '../../../core/models/chat_model.dart';
import '../../../core/services/mitra_repository.dart';
import '../../../core/services/bumdes_repository.dart';
import '../../../core/models/mitra_model.dart';
import '../../../core/models/bumdes_model.dart';
import 'dart:async';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'dart:convert';

class ChatMessage {
  final String id;
  final String text;
  final bool isSentByMe;
  final DateTime timestamp;
  final bool isRead;

  ChatMessage({
    required this.id,
    required this.text,
    required this.isSentByMe,
    required this.timestamp,
    this.isRead = false,
  });
}

class ChatViewModel extends ChangeNotifier {
  final ChatRepository _chatRepository = ChatRepository();
  final MitraRepository _mitraRepository = MitraRepository();
  final BumdesRepository _bumdesRepository = BumdesRepository();
  
  List<ChatMessage> _messages = [];
  bool _isLoading = false;
  String? _error;
  final TextEditingController messageController = TextEditingController();
  
  // User information
  final String _mitraId;
  final String _bumdesId;
  final String _currentUserType; // 'mitra' or 'bumdes'
  
  // Cached user data
  MitraModel? _mitraData;
  BumdesModel? _bumdesData;
  
  // WebSocket connection
  PusherChannelsFlutter? _pusher;
  bool _isConnected = false;
  
  // Typing indicator
  bool _isOtherUserTyping = false;
  Timer? _typingTimer;
  Timer? _typingDebounceTimer;

  List<ChatMessage> get messages => _messages;
  bool get isLoading => _isLoading;
  String? get error => _error;
  MitraModel? get mitraData => _mitraData;
  BumdesModel? get bumdesData => _bumdesData;
  bool get isOtherUserTyping => _isOtherUserTyping;

  ChatViewModel({
    required String mitraId,
    required String bumdesId,
    required String currentUserType,
  })  : _mitraId = mitraId,
        _bumdesId = bumdesId,
        _currentUserType = currentUserType {
    _loadMessages();
    _loadUserData();
    _initializePusher();
    _setupTypingListener();
  }

  Future<void> _loadUserData() async {
    try {
      // Load mitra data if ID is provided
      if (_mitraId.isNotEmpty) {
        _mitraData = await _mitraRepository.getMitraById(_mitraId);
        debugPrint('✅ Loaded mitra data: ${_mitraData?.namaMitra}');
      }
      
      // Load bumdes data if ID is provided
      if (_bumdesId.isNotEmpty) {
        _bumdesData = await _bumdesRepository.getBumdesById(_bumdesId);
        debugPrint('✅ Loaded bumdes data: ${_bumdesData?.namaBumdes}');
      }
      
      notifyListeners();
    } catch (e) {
      debugPrint('⚠️ Error loading user data: $e');
      // Don't fail the chat if user data loading fails
    }
  }

  Future<void> _initializePusher() async {
    try {
      _pusher = PusherChannelsFlutter.getInstance();
      
      // Configure Pusher with custom host for local development
      await _pusher!.init(
        apiKey: 'local-key',
        cluster: 'mt1',
        onConnectionStateChange: (currentState, previousState) {
          debugPrint('🔌 Connection state: $currentState');
          _isConnected = currentState == 'CONNECTED';
          notifyListeners();
        },
        onError: (message, code, error) {
          debugPrint('❌ Pusher error: $message, code: $code, error: $error');
        },
        onEvent: (event) {
          debugPrint('📨 Received event: ${event.eventName} on channel: ${event.channelName}');
          _handlePusherEvent(event);
        },
      );

      // Connect to Pusher with custom host for local development
      await _pusher!.connect();
      
      // Subscribe to the chat channel
      final channelName = 'private-chat.${_getChannelId()}';
      await _pusher!.subscribe(
        channelName: channelName,
        onEvent: (event) {
          debugPrint('📨 Channel event: ${event.eventName}');
          if (event.eventName == 'message.sent') {
            _handleNewMessage(event.data);
          }
        },
      );
      
      debugPrint('✅ WebSocket connected to channel: $channelName');
    } catch (e) {
      debugPrint('❌ Error initializing Pusher: $e');
      _error = 'Failed to connect to chat server';
      notifyListeners();
    }
  }
  
  String _getChannelId() {
    // Create a consistent channel ID regardless of user type
    final ids = [_mitraId, _bumdesId];
    ids.sort(); // Sort to ensure consistent channel name
    return '${ids[0]}.${ids[1]}';
  }
  
  void _handlePusherEvent(PusherEvent event) {
    try {
      if (event.eventName == 'message.sent') {
        _handleNewMessage(event.data);
      } else if (event.eventName == 'user.typing') {
        _handleTypingEvent(event.data);
      } else if (event.eventName == 'user.stopped-typing') {
        _handleStoppedTypingEvent();
      }
    } catch (e) {
      debugPrint('❌ Error handling Pusher event: $e');
    }
  }
  
  void _handleNewMessage(dynamic data) {
    try {
      final messageData = data is String ? json.decode(data) : data;
      final message = messageData['message'];
      
      // Check if this message already exists (to avoid duplicates)
      final existingIndex = _messages.indexWhere((m) => m.id == message['idChat']);
      if (existingIndex != -1) {
        return;
      }
      
      // Add the new message
      _messages.add(ChatMessage(
        id: message['idChat'],
        text: message['message'],
        isSentByMe: message['sender_type'] == _currentUserType,
        timestamp: DateTime.parse(message['sent_at']),
        isRead: message['read_at'] != null,
      ));
      
      notifyListeners();
      debugPrint('✅ New message received via WebSocket');
    } catch (e) {
      debugPrint('❌ Error processing new message: $e');
    }
  }

  Future<void> _loadMessages({bool silent = false}) async {
    if (!silent) {
      _isLoading = true;
      _error = null;
      notifyListeners();
    }

    try {
      final chatModels = await _chatRepository.getConversation(_mitraId, _bumdesId);
      
      _messages = chatModels.map((chat) {
        return ChatMessage(
          id: chat.idChat,
          text: chat.message,
          isSentByMe: chat.senderType == _currentUserType,
          timestamp: chat.sentAt,
          isRead: chat.isRead,
        );
      }).toList();

      debugPrint('✅ Loaded ${_messages.length} messages');
    } catch (e) {
      _error = e.toString();
      debugPrint('❌ Error loading messages: $e');
      _messages = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> sendMessage() async {
    if (messageController.text.trim().isEmpty) return;

    final messageText = messageController.text.trim();
    messageController.clear();

    try {
      // Create ChatModel
      final chatModel = ChatModel(
        idChat: '', // Will be generated by backend
        idMitra: _mitraId,
        idBumDes: _bumdesId,
        message: messageText,
        senderType: _currentUserType,
        status: 'sent',
        sentAt: DateTime.now(),
      );

      // Send to backend
      final sentMessage = await _chatRepository.sendMessage(chatModel);

      // Add to local list
      _messages.add(ChatMessage(
        id: sentMessage.idChat,
        text: sentMessage.message,
        isSentByMe: true,
        timestamp: sentMessage.sentAt,
        isRead: false,
      ));

      notifyListeners();
      debugPrint('✅ Message sent successfully');
    } catch (e) {
      debugPrint('❌ Error sending message: $e');
      _error = 'Failed to send message';
      notifyListeners();
    }
  }

  Future<void> refreshMessages() async {
    await _loadMessages();
  }
  
  // Setup typing listener
  void _setupTypingListener() {
    messageController.addListener(_onTextChanged);
  }
  
  void _onTextChanged() {
    if (messageController.text.isNotEmpty) {
      _emitTypingStatus(true);
      
      // Debounce: cancel previous timer
      _typingDebounceTimer?.cancel();
      
      // Set new timer to emit stop typing after 2 seconds of inactivity
      _typingDebounceTimer = Timer(const Duration(seconds: 2), () {
        _emitTypingStatus(false);
      });
    }
  }
  
  void _emitTypingStatus(bool isTyping) {
    try {
      if (_pusher == null || !_isConnected) return;
      
      final channelName = 'private-chat.${_getChannelId()}';
      final eventName = isTyping ? 'client-user-typing' : 'client-user-stopped-typing';
      
      // Trigger client event
      _pusher!.trigger(
        PusherEvent(
          channelName: channelName,
          eventName: eventName,
          data: json.encode({
            'user_type': _currentUserType,
            'user_id': _currentUserType == 'mitra' ? _mitraId : _bumdesId,
          }),
        ),
      );
      
      debugPrint('✅ Typing status emitted: $isTyping');
    } catch (e) {
      debugPrint('❌ Error emitting typing status: $e');
    }
  }
  
  void _handleTypingEvent(dynamic data) {
    try {
      final eventData = data is String ? json.decode(data) : data;
      final userType = eventData['user_type'];
      
      // Only show typing indicator if it's from the other user
      if (userType != _currentUserType) {
        _isOtherUserTyping = true;
        notifyListeners();
        
        // Auto-hide typing indicator after 3 seconds
        _typingTimer?.cancel();
        _typingTimer = Timer(const Duration(seconds: 3), () {
          _isOtherUserTyping = false;
          notifyListeners();
        });
        
        debugPrint('✅ Other user is typing');
      }
    } catch (e) {
      debugPrint('❌ Error handling typing event: $e');
    }
  }
  
  void _handleStoppedTypingEvent() {
    _typingTimer?.cancel();
    _isOtherUserTyping = false;
    notifyListeners();
    debugPrint('\u2705 Other user stopped typing');
  }

  @override
  void dispose() {
    // Cancel timers
    _typingTimer?.cancel();
    _typingDebounceTimer?.cancel();
    
    // Remove text controller listener
    messageController.removeListener(_onTextChanged);
    
    // Disconnect from WebSocket
    if (_pusher != null) {
      final channelName = 'private-chat.${_getChannelId()}';
      _pusher!.unsubscribe(channelName: channelName);
      _pusher!.disconnect();
    }
    messageController.dispose();
    super.dispose();
  }
}
