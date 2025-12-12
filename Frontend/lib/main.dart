import 'package:flutter/material.dart';
import 'core/theme/app_colors.dart';
import 'core/widgets/app_navbar.dart';
import 'core/services/auth_service.dart';
import 'shared/dashboard/view/dashboard_view.dart';
import 'shared/catalog/view/catalog_view.dart';
import 'shared/notification/view/notification_view.dart';
import 'bumdes/profile/view/bumdes_profile_view.dart';
import 'mitra/profile/view/mitra_profile_view.dart';
import 'splash/splash_route.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.secondary,
        ),
        scaffoldBackgroundColor: AppColors.background,
        useMaterial3: true,
      ),
      initialRoute: '/login', // Replace 'home' with this
      routes: SplashRoute.getRoutes(), // Add this line
      onGenerateRoute: SplashRoute.generateRoute, // Add this line
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final AuthService _authService = AuthService();
  String? _userType;
  List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _initializeScreens();
  }

  Future<void> _initializeScreens() async {
    // Get the user type from auth service
    _userType = await _authService.getUserType();
    
    // Set screens based on user type
    setState(() {
      _screens = [
        const DashboardView(),
        const CatalogView(),
        const NotificationView(),
        // Show the appropriate profile based on user type
        _userType == 'bumdes' 
            ? const BumdesProfileView()
            : const MitraProfileView(),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show loading indicator while determining user type
    if (_screens.isEmpty) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          _screens[_currentIndex],
          // Debug indicator showing current user type
          if (_userType != null)
            Positioned(
              top: 50,
              right: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _userType == 'mitra' ? Colors.green : Colors.blue,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  _userType!.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
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
}

class PlaceholderScreen extends StatelessWidget {
  final String title;
  final IconData icon;

  const PlaceholderScreen({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(color: AppColors.textLight)),
        backgroundColor: AppColors.primary,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 80, color: AppColors.primary),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
