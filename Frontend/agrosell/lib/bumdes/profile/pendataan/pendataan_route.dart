import 'package:flutter/material.dart';
import 'view/pendataan_view.dart';

class PendataanRoute extends StatefulWidget {
  const PendataanRoute({super.key});

  @override
  State<PendataanRoute> createState() => _PendataanRouteState();
}

class _PendataanRouteState extends State<PendataanRoute> {
  @override
  Widget build(BuildContext context) {
    return const PendataanView();
  }
}

class PendataanRouteGenerator {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      '/pendataan': (context) => const PendataanView(),
    };
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/pendataan':
        return MaterialPageRoute(builder: (_) => const PendataanView());
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