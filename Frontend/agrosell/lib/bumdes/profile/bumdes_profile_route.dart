import 'package:flutter/material.dart';
import 'view/bumdes_profile_view.dart';
import 'grafik/view/grafik_view.dart';
import 'list_po/view/list_po_view.dart';
import 'pendataan/view/pendataan_view.dart';
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
      '/grafik': (context) => const GrafikView(),
      '/list-po': (context) => const ListPoView(),
      '/pendataan': (context) => const PendataanView(),
      // '/beli-sekarang': (context) => const BeliSekarangView(),
      // '/perlu-dikirim': (context) => const PerluDikirimView(),
    };
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/bumdes-profile':
        return MaterialPageRoute(builder: (_) => const BumdesProfileView());
      case '/grafik':
        return MaterialPageRoute(builder: (_) => const GrafikView());
      case '/list-po':
        return MaterialPageRoute(builder: (_) => const ListPoView());
      case '/pendataan':
        return MaterialPageRoute(builder: (_) => const PendataanView());
      // Tambahkan case baru
      // case '/beli-sekarang':
      //   return MaterialPageRoute(builder: (_) => const BeliSekarangView());
      // case '/perlu-dikirim':
      //   return MaterialPageRoute(builder: (_) => const PerluDikirimView());
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