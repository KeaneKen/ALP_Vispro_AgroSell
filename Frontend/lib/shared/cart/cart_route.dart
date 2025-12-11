import 'package:flutter/material.dart';
import 'view/cart_view.dart';

class CartRoute {
  static const String routeName = '/cart';

  static Route<dynamic> route(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => const CartView(),
      settings: settings,
    );
  }

  static void navigate(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CartView(),
      ),
    );
  }
}
