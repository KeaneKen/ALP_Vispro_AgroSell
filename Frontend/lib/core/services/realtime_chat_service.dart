import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../config/api_config.dart';

/// Type-safe realtime chat service using WebSocket
class RealtimeChatService {
  WebSocketChannel? _channel;
  StreamController<Map<String, dynamic>>? _messageController;
  Timer? _reconnectTimer;
  Timer? _pingTimer;
  bool _isConnected = false;
  bool _isDisposed = false;
  String? _currentChannelId;
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 5;
  static const Duration _reconnectDelay = Duration(seconds: 3);
  static const Duration _pingInterval = Duration(seconds: 30);

  /// Stream of incoming messages
  Stream<Map<String, dynamic>>? get messageStream => _messageController?.stream;

  /// Connection status
  bool get isConnected => _isConnected;

  /// Connect to chat channel for a specific conversation
  Future<void> connect({
    required String mitraId,
    required String bumdesId,
  }) async {
    if (_isDisposed) return;

    // Create consistent channel ID
    final ids = [mitraId, bumdesId]..sort();
    _currentChannelId = '${ids[0]}_${ids[1]}';

    // Initialize message stream controller
    _messageController?.close();
    _messageController = StreamController<Map<String, dynamic>>.broadcast();

    await _establishConnection();
  }

  Future<void> _establishConnection() async {
    if (_isDisposed || _currentChannelId == null) return;

    try {
      // Get WebSocket URL from config
      final wsUrl = _getWebSocketUrl();
      debugPrint('🔌 Connecting to WebSocket: $wsUrl');

      _channel = WebSocketChannel.connect(Uri.parse(wsUrl));

      // Listen to incoming messages
      _channel!.stream.listen(
        _handleIncomingMessage,
        onError: _handleError,
        onDone: _handleDisconnect,
        cancelOnError: false,
      );

      _isConnected = true;
      _reconnectAttempts = 0;

      // Subscribe to the channel
      _sendSubscription();

      // Start ping timer to keep connection alive
      _startPingTimer();

      debugPrint('✅ WebSocket connected to channel: $_currentChannelId');
    } catch (e) {
      debugPrint('❌ WebSocket connection error: $e');
      _isConnected = false;
      _scheduleReconnect();
    }
  }

  String _getWebSocketUrl() {
    // Extract host from API URL
    final apiUrl = ApiConfig.baseUrl;
    final uri = Uri.parse(apiUrl);
    final host = uri.host;
    final wsProtocol = uri.scheme == 'https' ? 'wss' : 'ws';
    
    // Soketi default port is 6001
    return '$wsProtocol://$host:6001/app/local-key?protocol=7&client=flutter&version=7.0.0&flash=false';
  }

  void _sendSubscription() {
    if (_channel == null || !_isConnected) return;

    final subscribeMessage = json.encode({
      'event': 'pusher:subscribe',
      'data': {
        'channel': 'chat.$_currentChannelId',
      },
    });

    _channel!.sink.add(subscribeMessage);
    debugPrint('📢 Subscribed to channel: chat.$_currentChannelId');
  }

  void _handleIncomingMessage(dynamic data) {
    try {
      final Map<String, dynamic> message = json.decode(data.toString());
      final eventName = message['event']?.toString() ?? '';

      debugPrint('📨 Received WebSocket event: $eventName');

      // Handle different event types
      switch (eventName) {
        case 'pusher:connection_established':
          debugPrint('✅ Pusher connection established');
          _isConnected = true;
          break;
        case 'pusher_internal:subscription_succeeded':
          debugPrint('✅ Channel subscription succeeded');
          break;
        case 'message.sent':
        case 'MessageSent':
        case 'App\\Events\\MessageSent':
          final messageData = message['data'];
          if (messageData != null) {
            final parsedData = messageData is String 
                ? json.decode(messageData) 
                : messageData;
            _messageController?.add(parsedData as Map<String, dynamic>);
          }
          break;
        case 'pusher:pong':
          // Pong received, connection is alive
          break;
        default:
          // Check if it contains chat data
          if (message.containsKey('message') && message.containsKey('idChat')) {
            _messageController?.add(message);
          }
      }
    } catch (e) {
      debugPrint('❌ Error parsing WebSocket message: $e');
    }
  }

  void _handleError(dynamic error) {
    debugPrint('❌ WebSocket error: $error');
    _isConnected = false;
    _scheduleReconnect();
  }

  void _handleDisconnect() {
    debugPrint('🔌 WebSocket disconnected');
    _isConnected = false;
    if (!_isDisposed) {
      _scheduleReconnect();
    }
  }

  void _scheduleReconnect() {
    if (_isDisposed || _reconnectAttempts >= _maxReconnectAttempts) {
      debugPrint('❌ Max reconnect attempts reached');
      return;
    }

    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(_reconnectDelay, () {
      _reconnectAttempts++;
      debugPrint('🔄 Reconnecting... attempt $_reconnectAttempts');
      _establishConnection();
    });
  }

  void _startPingTimer() {
    _pingTimer?.cancel();
    _pingTimer = Timer.periodic(_pingInterval, (_) {
      if (_isConnected && _channel != null) {
        final pingMessage = json.encode({'event': 'pusher:ping', 'data': {}});
        _channel!.sink.add(pingMessage);
      }
    });
  }

  /// Send a message through WebSocket (for typing indicators, etc.)
  void sendEvent(String eventName, Map<String, dynamic> data) {
    if (_channel == null || !_isConnected) return;

    final message = json.encode({
      'event': eventName,
      'channel': 'chat.$_currentChannelId',
      'data': data,
    });

    _channel!.sink.add(message);
  }

  /// Disconnect from WebSocket
  void disconnect() {
    _reconnectTimer?.cancel();
    _pingTimer?.cancel();
    _channel?.sink.close();
    _isConnected = false;
    debugPrint('🔌 WebSocket disconnected manually');
  }

  /// Dispose all resources
  void dispose() {
    _isDisposed = true;
    disconnect();
    _messageController?.close();
    _messageController = null;
  }
}
