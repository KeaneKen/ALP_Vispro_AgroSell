import 'package:flutter/material.dart';
import 'dart:async';
import '../../../core/services/chat_repository.dart';
import '../../../core/models/chat_model.dart';
import '../../../core/models/chat_message.dart';
import '../../../core/services/mitra_repository.dart';
import '../../../core/services/bumdes_repository.dart';
import '../../../core/models/mitra_model.dart';
import '../../../core/models/bumdes_model.dart';

/// Type-safe ChatViewModel with polling-based realtime updates
class ChatViewModelV2 extends ChangeNotifier {
  // Repositories
  final ChatRepository _chatRepository = ChatRepository();
  final MitraRepository _mitraRepository = MitraRepository();
  final BumdesRepository _bumdesRepository = BumdesRepository();
  
  // State
  List<ChatMessageUI> _messages = [];
  bool _isLoading = false;
  String? _error;
  bool _isSending = false;
  bool _isOtherUserTyping = false;
  bool _isConnected = true;
  
  // User information
  final String mitraId;
  final String bumdesId;
  final String currentUserType; // 'mitra' or 'bumdes'
  
  // Cached user data
  MitraModel? _mitraData;
  BumdesModel? _bumdesData;
  
  // Controllers
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  
  // Timers
  Timer? _pollingTimer;
  Timer? _typingDebounceTimer;
  
  // Polling configuration
  static const Duration _pollingInterval = Duration(seconds: 2);

  // Getters
  List<ChatMessageUI> get messages => List.unmodifiable(_messages);
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isSending => _isSending;
  bool get isOtherUserTyping => _isOtherUserTyping;
  MitraModel? get mitraData => _mitraData;
  BumdesModel? get bumdesData => _bumdesData;
  bool get isConnected => _isConnected;

  ChatViewModelV2({
    required this.mitraId,
    required this.bumdesId,
    required this.currentUserType,
  }) {
    _initialize();
  }

  Future<void> _initialize() async {
    await _loadInitialData();
    _startPolling();
  }

  Future<void> _loadInitialData() async {
    await Future.wait([
      _loadMessages(),
      _loadUserData(),
    ]);
  }

  Future<void> _loadUserData() async {
    try {
      if (mitraId.isNotEmpty) {
        _mitraData = await _mitraRepository.getMitraById(mitraId);
        debugPrint('✅ Loaded mitra: ${_mitraData?.namaMitra}');
      }
      
      if (bumdesId.isNotEmpty) {
        _bumdesData = await _bumdesRepository.getBumdesById(bumdesId);
        debugPrint('✅ Loaded bumdes: ${_bumdesData?.namaBumdes}');
      }
      
      notifyListeners();
    } catch (e) {
      debugPrint('⚠️ Error loading user data: $e');
    }
  }

  Future<void> _loadMessages({bool silent = false}) async {
    if (!silent) {
      _isLoading = true;
      _error = null;
      notifyListeners();
    }

    try {
      final chatModels = await _chatRepository.getConversation(mitraId, bumdesId);
      
      _messages = chatModels.map((chat) => ChatMessageUI(
        id: chat.idChat,
        text: chat.message,
        isSentByMe: chat.senderType == currentUserType,
        timestamp: chat.sentAt,
        isRead: chat.isRead,
        status: MessageStatus.fromString(chat.status),
      )).toList();

      // Sort by timestamp
      _messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));

      _isConnected = true;
      debugPrint('✅ Loaded ${_messages.length} messages');
    } catch (e) {
      if (!silent) {
        _error = 'Failed to load messages';
      }
      _isConnected = false;
      debugPrint('❌ Error loading messages: $e');
    }

    _isLoading = false;
    notifyListeners();
    
    // Scroll to bottom after loading
    _scrollToBottom();
  }

  void _startPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(_pollingInterval, (_) {
      _pollForNewMessages();
    });
    debugPrint('🔄 Started polling for messages (every ${_pollingInterval.inSeconds}s)');
  }

  Future<void> _pollForNewMessages() async {
    try {
      final chatModels = await _chatRepository.getConversation(mitraId, bumdesId);
      
      bool hasNewMessages = false;
      
      for (final chat in chatModels) {
        // Check if message already exists
        final exists = _messages.any((m) => m.id == chat.idChat);
        if (!exists) {
          _messages.add(ChatMessageUI(
            id: chat.idChat,
            text: chat.message,
            isSentByMe: chat.senderType == currentUserType,
            timestamp: chat.sentAt,
            isRead: chat.isRead,
            status: MessageStatus.fromString(chat.status),
          ));
          hasNewMessages = true;
        }
      }

      if (hasNewMessages) {
        // Sort by timestamp
        _messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
        _isConnected = true;
        notifyListeners();
        _scrollToBottom();
        debugPrint('📨 New messages received via polling');
      }
    } catch (e) {
      _isConnected = false;
      notifyListeners();
      debugPrint('❌ Polling error: $e');
    }
  }

  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty || _isSending) return;

    // Clear input immediately for better UX
    messageController.clear();
    
    // Create optimistic message
    final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
    final optimisticMessage = ChatMessageUI(
      id: tempId,
      text: text,
      isSentByMe: true,
      timestamp: DateTime.now(),
      status: MessageStatus.sending,
    );

    // Add optimistic message
    _messages.add(optimisticMessage);
    notifyListeners();
    _scrollToBottom();

    _isSending = true;

    try {
      // Create ChatModel for API
      final chatModel = ChatModel(
        idChat: '',
        idMitra: mitraId,
        idBumDes: bumdesId,
        message: text,
        senderType: currentUserType,
        status: 'sent',
        sentAt: DateTime.now(),
      );

      // Send to backend
      final sentMessage = await _chatRepository.sendMessage(chatModel);

      // Replace optimistic message with real one
      final index = _messages.indexWhere((m) => m.id == tempId);
      if (index != -1) {
        _messages[index] = ChatMessageUI(
          id: sentMessage.idChat,
          text: sentMessage.message,
          isSentByMe: true,
          timestamp: sentMessage.sentAt,
          status: MessageStatus.sent,
        );
      }

      _isConnected = true;
      debugPrint('✅ Message sent: ${sentMessage.idChat}');
    } catch (e) {
      debugPrint('❌ Error sending message: $e');
      
      // Mark optimistic message as failed
      final index = _messages.indexWhere((m) => m.id == tempId);
      if (index != -1) {
        _messages[index] = optimisticMessage.copyWith(status: MessageStatus.failed);
      }
      
      _error = 'Failed to send message';
    }

    _isSending = false;
    notifyListeners();
  }

  /// Retry sending a failed message
  Future<void> retrySendMessage(String messageId) async {
    final index = _messages.indexWhere((m) => m.id == messageId);
    if (index == -1) return;

    final failedMessage = _messages[index];
    if (failedMessage.status != MessageStatus.failed) return;

    // Update status to sending
    _messages[index] = failedMessage.copyWith(status: MessageStatus.sending);
    notifyListeners();

    try {
      final chatModel = ChatModel(
        idChat: '',
        idMitra: mitraId,
        idBumDes: bumdesId,
        message: failedMessage.text,
        senderType: currentUserType,
        status: 'sent',
        sentAt: DateTime.now(),
      );

      final sentMessage = await _chatRepository.sendMessage(chatModel);

      _messages[index] = ChatMessageUI(
        id: sentMessage.idChat,
        text: sentMessage.message,
        isSentByMe: true,
        timestamp: sentMessage.sentAt,
        status: MessageStatus.sent,
      );

      debugPrint('✅ Message retry successful');
    } catch (e) {
      _messages[index] = failedMessage.copyWith(status: MessageStatus.failed);
      debugPrint('❌ Message retry failed: $e');
    }

    notifyListeners();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> refreshMessages() async {
    await _loadMessages(silent: true);
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    // Cancel timers
    _pollingTimer?.cancel();
    _typingDebounceTimer?.cancel();
    
    // Dispose controllers
    messageController.dispose();
    scrollController.dispose();
    
    super.dispose();
  }
}
