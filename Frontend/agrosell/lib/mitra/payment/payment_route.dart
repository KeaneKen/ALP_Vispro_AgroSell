import 'package:flutter/material.dart';
import 'view/payment_view.dart';

class PaymentRoute {
  static const String name = '/payment';

  static Route<dynamic> route() {
    return MaterialPageRoute(
      builder: (_) => const PaymentView(),
    );
  }
}