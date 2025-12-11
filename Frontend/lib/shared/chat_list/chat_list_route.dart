import 'package:flutter/material.dart';
import 'view/chat_list_view.dart';

class ChatListRoute {
  static void navigate(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ChatListView(),
      ),
    );
  }
}
