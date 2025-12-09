import 'package:flutter/material.dart';
import 'view/product_detail_view.dart';

class ProductDetailRoute {
  static const String routeName = '/product-detail';

  static Route<dynamic> route(RouteSettings settings) {
    final product = settings.arguments as Map<String, dynamic>;

    return MaterialPageRoute(
      builder: (_) => ProductDetailView(product: product),
      settings: settings,
    );
  }

  static void navigate(BuildContext context, Map<String, dynamic> product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductDetailView(product: product),
      ),
    );
  }
}
