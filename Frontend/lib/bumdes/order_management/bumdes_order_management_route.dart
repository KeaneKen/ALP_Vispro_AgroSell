import 'package:flutter/material.dart';
import 'bumdes_order_management_view.dart';

class BumdesOrderManagementRoute {
  static void navigate(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const BumdesOrderManagementView(),
      ),
    );
  }
}
