import 'package:flutter/material.dart';
import 'view/chat_view.dart';

class ChatRoute {
  static void navigate(
    BuildContext context, {
    required String contactName,
    required String mitraId,
    required String bumdesId,
    required String currentUserType,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatView(
          contactName: contactName,
          mitraId: mitraId,
          bumdesId: bumdesId,
          currentUserType: currentUserType,
        ),
      ),
    );
  }
}
