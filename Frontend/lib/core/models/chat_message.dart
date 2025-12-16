/// Type-safe chat message model for UI display
class ChatMessageUI {
  final String id;
  final String text;
  final bool isSentByMe;
  final DateTime timestamp;
  final bool isRead;
  final MessageStatus status;

  const ChatMessageUI({
    required this.id,
    required this.text,
    required this.isSentByMe,
    required this.timestamp,
    this.isRead = false,
    this.status = MessageStatus.sent,
  });

  /// Create from API response map with null safety
  factory ChatMessageUI.fromMap(Map<String, dynamic> map, String currentUserType) {
    return ChatMessageUI(
      id: map['idChat']?.toString() ?? '',
      text: map['message']?.toString() ?? '',
      isSentByMe: map['sender_type']?.toString() == currentUserType,
      timestamp: _parseDateTime(map['sent_at']),
      isRead: map['read_at'] != null,
      status: MessageStatus.fromString(map['status']?.toString()),
    );
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is DateTime) return value;
    try {
      return DateTime.parse(value.toString());
    } catch (_) {
      return DateTime.now();
    }
  }

  ChatMessageUI copyWith({
    String? id,
    String? text,
    bool? isSentByMe,
    DateTime? timestamp,
    bool? isRead,
    MessageStatus? status,
  }) {
    return ChatMessageUI(
      id: id ?? this.id,
      text: text ?? this.text,
      isSentByMe: isSentByMe ?? this.isSentByMe,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      status: status ?? this.status,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChatMessageUI && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Message delivery status
enum MessageStatus {
  sending,
  sent,
  delivered,
  read,
  failed;

  static MessageStatus fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'sending':
        return MessageStatus.sending;
      case 'delivered':
        return MessageStatus.delivered;
      case 'read':
        return MessageStatus.read;
      case 'failed':
        return MessageStatus.failed;
      default:
        return MessageStatus.sent;
    }
  }
}
