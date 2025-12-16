class ApiConfig {
  // Base URL for API

  // Android emulator (AVD)
  static const String baseUrl = 'http://10.30.204.119:8000/api';

  // iOS simulator
  static const String baseUrlIOS = 'http://localhost:8000/api';

  // Physical device (same Wi-Fi)
  static const String baseUrlPhysicalDevice = 'http://192.168.1.15:8000/api';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // API Endpoints
  static const String mitras = '/mitra';
  static const String bumdes = '/bumdes';
  static const String pangans = '/pangan';
  static const String cart = '/cart';
  static const String payment = '/payment';
  static const String payments = '/payment';
  static const String riwayat = '/riwayat';
  static const String chat = '/chat';
  static const String chatConversation = '/chat/conversation';
  static const String preorders = '/preorders';
  static const String notifications = '/notifications';
  static const String metricsDashboard = '/metrics/dashboard';
}
