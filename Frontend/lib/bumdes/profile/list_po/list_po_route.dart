import 'package:flutter/material.dart';
import 'view/list_po_view.dart';

class ListPoRoute extends StatefulWidget {
  const ListPoRoute({super.key});

  @override
  State<ListPoRoute> createState() => _ListPoRouteState();
}

class _ListPoRouteState extends State<ListPoRoute> {
  @override
  Widget build(BuildContext context) {
    return const ListPoView();
  }
}

class ListPoRouteGenerator {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      '/list-po': (context) => const ListPoView(),
    };
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/list-po':
        return MaterialPageRoute(builder: (_) => const ListPoView());
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