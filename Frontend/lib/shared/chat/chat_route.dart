import 'package:flutter/material.dart';
import 'view/chat_view_v2.dart';

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
        builder: (_) => ChatViewV2(
          contactName: contactName,
          mitraId: mitraId,
          bumdesId: bumdesId,
          currentUserType: currentUserType,
        ),
      ),
    );
  }
}
