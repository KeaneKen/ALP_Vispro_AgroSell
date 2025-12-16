import 'package:flutter/material.dart';
import 'mitra_order_history_view.dart';

class MitraOrderHistoryRoute {
  static void navigate(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MitraOrderHistoryView(),
      ),
    );
  }
}
