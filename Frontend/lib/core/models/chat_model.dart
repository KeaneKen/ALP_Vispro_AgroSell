class ChatModel {
  final String idChat;
  final String idMitra;
  final String idBumDes;
  final String message;
  final String senderType; // 'mitra' or 'bumdes'
  final String status; // 'sent', 'delivered', 'read'
  final DateTime sentAt;
  final DateTime? readAt;

    ChatModel({
    required this.idChat,
    required this.idMitra,
    required this.idBumDes,
    required this.message,
    required this.senderType,
    required this.status,
    required this.sentAt,
    this.readAt,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      idChat: json['idChat'] ?? '',
      idMitra: json['idMitra'] ?? '',
      idBumDes: json['idBumDes'] ?? '',
      message: json['message'] ?? '',
      senderType: json['sender_type'] ?? 'mitra',
      status: json['status'] ?? 'sent',
      sentAt: DateTime.parse(json['sent_at'] ?? DateTime.now().toIso8601String()),
      readAt: json['read_at'] != null ? DateTime.parse(json['read_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idMitra': idMitra,
      'idBumDes': idBumDes,
      'message': message,
      'sender_type': senderType,
    };
  }

  bool get isSentByMitra => senderType == 'mitra';
  bool get isRead => status == 'read';
}