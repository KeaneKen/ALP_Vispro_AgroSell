import 'package:flutter/material.dart';
import 'view/bumdes_profile_view.dart';
import 'list_po/view/list_po_view.dart';

// Import halaman baru jika sudah dibuat
// import '../beli_sekarang/view/beli_sekarang_view.dart';
// import '../perlu_dikirim/view/perlu_dikirim_view.dart';

class BumdesProfileRoute extends StatefulWidget {
  const BumdesProfileRoute({super.key});

  @override
  State<BumdesProfileRoute> createState() => _BumdesProfileRouteState();
}

class _BumdesProfileRouteState extends State<BumdesProfileRoute> {
  @override
  Widget build(BuildContext context) {
    return const BumdesProfileView();
  }
}

class BumdesRouteGenerator {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      '/bumdes-profile': (context) => const BumdesProfileView(),
      '/list-po': (context) => const ListPoView(),
      
    };
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/bumdes-profile':
        return MaterialPageRoute(builder: (_) => const BumdesProfileView());
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