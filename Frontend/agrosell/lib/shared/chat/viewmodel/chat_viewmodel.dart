import 'package:flutter/material.dart';

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
  List<ChatMessage> _messages = [];
  bool _isLoading = false;
  final TextEditingController messageController = TextEditingController();

  List<ChatMessage> get messages => _messages;
  bool get isLoading => _isLoading;

  ChatViewModel(String contactId) {
    _loadMessages(contactId);
  }

  void _loadMessages(String contactId) {
    _isLoading = true;
    notifyListeners();

    // Dummy messages based on contact
    _messages = [
      ChatMessage(
        id: '1',
        text: 'Halo, saya ingin menanyakan tentang padi IR64',
        isSentByMe: true,
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: true,
      ),
      ChatMessage(
        id: '2',
        text: 'Halo! Tentu, ada yang bisa saya bantu?',
        isSentByMe: false,
        timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: -5)),
        isRead: true,
      ),
      ChatMessage(
        id: '3',
        text: 'Stok untuk padi IR64 saat ini berapa ya?',
        isSentByMe: true,
        timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 50)),
        isRead: true,
      ),
      ChatMessage(
        id: '4',
        text: 'Stok tersedia 800kg. Harga Rp 11.500/kg sesuai HPP',
        isSentByMe: false,
        timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
        isRead: true,
      ),
      ChatMessage(
        id: '5',
        text: 'Apakah bisa pre-order untuk panen minggu depan?',
        isSentByMe: true,
        timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
        isRead: true,
      ),
      ChatMessage(
        id: '6',
        text: 'Bisa pak, minimal order 100kg untuk pre-order',
        isSentByMe: false,
        timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 25)),
        isRead: true,
      ),
      ChatMessage(
        id: '7',
        text: 'Baik, saya akan order 200kg. Bagaimana cara pembayarannya?',
        isSentByMe: true,
        timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 20)),
        isRead: true,
      ),
      ChatMessage(
        id: '8',
        text: 'Pembayaran bisa transfer atau COD. Saya akan kirim detailnya segera',
        isSentByMe: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        isRead: false,
      ),
    ];

    _isLoading = false;
    notifyListeners();
  }

  void sendMessage() {
    if (messageController.text.trim().isEmpty) return;

    final newMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: messageController.text.trim(),
      isSentByMe: true,
      timestamp: DateTime.now(),
      isRead: false,
    );

    _messages.add(newMessage);
    messageController.clear();
    notifyListeners();

    // Simulate reply after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      _simulateReply();
    });
  }

  void _simulateReply() {
    final replies = [
      'Baik, terima kasih!',
      'Siap, akan saya proses',
      'Oke, noted',
      'Terima kasih atas pesanannya',
      'Baik, saya akan cek dulu',
    ];

    final reply = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: replies[_messages.length % replies.length],
      isSentByMe: false,
      timestamp: DateTime.now(),
      isRead: false,
    );

    _messages.add(reply);
    notifyListeners();
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }
}
