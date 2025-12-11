import 'package:flutter/material.dart';
import 'view/chat_view.dart';

class ChatRoute {
  static navigate(BuildContext context, String contactName, String contactId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatView(
          contactName: contactName,
          contactId: contactId,
        ),
      ),
    );
  }
}
