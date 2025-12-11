import 'package:flutter/material.dart';
import 'view/mitra_profile_view.dart';

class MitraProfileRoute {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/mitra-profile':
        return MaterialPageRoute(
          builder: (_) => const MitraProfileView(),
          settings: settings,
        );
      default:
        return null;
    }
  }
}