import 'package:flutter/material.dart';
import 'view/catalog_view.dart';

class CatalogRoute {
  static navigate(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CatalogView()),
    );
  }
}
