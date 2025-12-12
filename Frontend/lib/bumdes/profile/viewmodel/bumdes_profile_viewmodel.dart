import 'package:flutter/material.dart';
import '../../../core/services/bumdes_repository.dart';
import '../../../core/services/pangan_repository.dart';
import '../../../core/services/auth_service.dart';
import 'package:intl/intl.dart';

class BumdesProfileViewModel with ChangeNotifier {
  final BumdesRepository _bumdesRepository = BumdesRepository();
  final PanganRepository _panganRepository = PanganRepository();
  final AuthService _authService = AuthService();
  
  bool _isLoading = true;
  String _bumdesName = 'Loading...';
  String _bumdesEmail = '';
  String _bumdesPhone = '';
  int _preOrderCount = 0;
  int _buyNowCount = 0;
  int _pendingDeliveryCount = 0;
  int _totalStock = 0;
  String _monthlyIncome = '0';
  String _growthPercentage = '0';
  String? _error;
  
  // Data harga bulanan - will be populated from database
  List<Map<String, dynamic>> _priceUpdates = [];
  List<Map<String, dynamic>> _recentActivities = [];

  bool get isLoading => _isLoading;
  String get bumdesName => _bumdesName;
  String get bumdesEmail => _bumdesEmail;
  String get bumdesPhone => _bumdesPhone;
  int get preOrderCount => _preOrderCount;
  int get buyNowCount => _buyNowCount;
  int get pendingDeliveryCount => _pendingDeliveryCount;
  int get totalStock => _totalStock;
  String get monthlyIncome => _monthlyIncome;
  String get growthPercentage => _growthPercentage;
  List<Map<String, dynamic>> get priceUpdates => _priceUpdates;
  List<Map<String, dynamic>> get recentActivities => _recentActivities;
  String? get error => _error;

  BumdesProfileViewModel() {
    loadProfileData();
  }

  Future<void> loadProfileData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      debugPrint('🔄 Loading profile data from database...');
      
      // Get current bumdes ID from auth service
      final bumdesId = await _authService.getBumdesId();
      
      if (bumdesId == null) {
        throw Exception('User not logged in');
      }

      // Fetch bumdes data from backend
      final bumdes = await _bumdesRepository.getBumdesById(bumdesId);
      
      // Update profile data
      _bumdesName = bumdes.namaBumdes;
      _bumdesEmail = bumdes.emailBumdes;
      _bumdesPhone = bumdes.noTelpBumdes ?? '';
      
      // Fetch statistics from backend
      final stats = await _bumdesRepository.getProfileStats();
      
      _preOrderCount = stats['preOrderCount'] ?? 0;
      _buyNowCount = stats['buyNowCount'] ?? 0;
      _pendingDeliveryCount = stats['pendingDeliveryCount'] ?? 0;
      _totalStock = stats['totalStock'] ?? 0;
      
      // Format monthly income
      final income = stats['monthlyIncome'] ?? 0.0;
      final formatter = NumberFormat.currency(
        locale: 'id_ID',
        symbol: '',
        decimalDigits: 0,
      );
      _monthlyIncome = formatter.format(income);
      
      // Calculate growth (placeholder)
      _growthPercentage = '15.2';

      // Fetch pangan prices for price updates
      final panganList = await _panganRepository.getAllPangan();
      _priceUpdates = [
        {
          'month': 'Data Terkini',
          'lastUpdate': 'Hari ini',
          'prices': panganList.take(5).map((pangan) {
            return {
              'commodity': pangan.namaPangan,
              'price': pangan.hargaPangan.toInt(),
              'change': '+5.0%',
              'trend': 'up',
            };
          }).toList(),
        },
      ];

      // Initialize recent activities with sample data
      _initializeDummyActivities();

      debugPrint('✅ Profile data loaded: Name=$_bumdesName, PreOrders=$_preOrderCount, Stock=$_totalStock, Income=$_monthlyIncome');
    } catch (e) {
      _error = e.toString();
      debugPrint('❌ Error loading profile data: $e');
      
      // Set default values on error
      _bumdesName = 'Failed to load';
      _bumdesEmail = '';
      _bumdesPhone = '';
      _initializeDummyActivities(); // Fallback to dummy data
    }

    _isLoading = false;
    notifyListeners();
  }

  void _initializeDummyActivities() {
    // Activities will be populated from backend in future update
    _recentActivities = [];
  }

  void refreshData() {
    loadProfileData();
  }
}