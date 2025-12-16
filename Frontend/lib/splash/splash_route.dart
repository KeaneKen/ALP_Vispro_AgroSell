import 'package:flutter/material.dart';
import 'view/splash_view.dart';
import 'view/login_view.dart';
import 'view/register_view.dart';
import 'view/forgot_password_view.dart';
import 'view/next_splash_view.dart';


class SplashRoute {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      '/splash': (context) => const SplashView(),
      '/next-splash': (context) => const NextSplashView(),
      '/login': (context) => const LoginView(),
      '/register': (context) => const RegisterView(),
      '/forgot-password': (context) => const ForgotPasswordView(),
      
    };
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/splash':
        return MaterialPageRoute(builder: (_) => const SplashView());
      case '/next-splash':
        return MaterialPageRoute(builder: (_) => const NextSplashView());
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginView());
      case '/register':
        return MaterialPageRoute(builder: (_) => const RegisterView());
      case '/forgot-password':
        return MaterialPageRoute(builder: (_) => const ForgotPasswordView());
      
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