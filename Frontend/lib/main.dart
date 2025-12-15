import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/theme/app_colors.dart';
import 'core/widgets/app_navbar.dart';
import 'splash/view/splash_view.dart';
import 'splash/view/next_splash_view.dart';
import 'splash/view/login_view.dart';
import 'splash/view/register_view.dart';
import 'splash/view/forgot_password_view.dart';
import 'shared/dashboard/view/dashboard_view.dart';
import 'shared/catalog/view/catalog_view.dart';
import 'shared/notification/view/notification_view.dart';
import 'mitra/profile/view/mitra_profile_view.dart';
import 'bumdes/profile/view/bumdes_profile_view.dart';
import 'core/services/auth_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const AgroSellApp());
}

class AgroSellApp extends StatelessWidget {
  const AgroSellApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgroSell',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.surface,
          background: AppColors.background,
        ),
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        useMaterial3: true,
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashView(),
        '/next-splash': (context) => const NextSplashView(),
        '/login': (context) => const LoginView(),
        '/register': (context) => const RegisterView(),
        '/forgot-password': (context) => const ForgotPasswordView(),
        '/main': (context) => const MainScaffold(),
      },
    );
  }
}

/// Main scaffold with bottom navigation bar
class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;
  final AuthService _authService = AuthService();
  String? _userType;

  @override
  void initState() {
    super.initState();
    _loadUserType();
  }

  Future<void> _loadUserType() async {
    final userType = await _authService.getUserType();
    setState(() {
      _userType = userType;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          const DashboardView(),
          const CatalogView(),
          const NotificationView(),
          _buildProfileView(),
        ],
      ),
      bottomNavigationBar: AppNavbar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildProfileView() {
    // Show appropriate profile view based on user type
    if (_userType == 'bumdes') {
      return const BumdesProfileView();
    } else {
      // Default to Mitra profile
      return const MitraProfileView();
    }
  }
}
