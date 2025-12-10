import 'package:flutter/material.dart';
import 'view/grafik_view.dart';

class GrafikRoute extends StatefulWidget {
  const GrafikRoute({super.key});

  @override
  State<GrafikRoute> createState() => _GrafikRouteState();
}

class _GrafikRouteState extends State<GrafikRoute> {
  @override
  Widget build(BuildContext context) {
    return const GrafikView();
  }
}

class GrafikRouteGenerator {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      '/grafik': (context) => const GrafikView(),
    };
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/grafik':
        return MaterialPageRoute(builder: (_) => const GrafikView());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Route tidak ditemukan: ${settings.name}'),
            ),
          ),
        );
    }
  }
}