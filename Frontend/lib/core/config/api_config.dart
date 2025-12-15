class ApiConfig {
  // Base URL for API
  // For Android emulator: use 10.0.2.2 to access host machine's localhost
  // For iOS simulator: use localhost or 127.0.0.1
  // For physical device: use your computer's IP address
  static const String baseUrl = 'http://10.0.2.2:8000/api'; // Android emulator (host loopback)
  // static const String baseUrl = 'http://10.30.204.119:8000/api'; // Physical device (IPv4 from ipconfig)
  
  // Alternative URLs for different platforms
  static const String baseUrlIOS = 'http://localhost:8000/api';
  static const String baseUrlPhysicalDevice = 'http://10.30.204.119:8000/api'; // Updated with your IP
  
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
}
