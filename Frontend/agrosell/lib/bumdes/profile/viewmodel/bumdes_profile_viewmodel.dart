import 'package:flutter/material.dart';

class BumdesProfileViewModel with ChangeNotifier {
  bool _isLoading = true;
  int _preOrderCount = 5;
  int _buyNowCount = 3;
  int _pendingDeliveryCount = 0;
  int _totalStock = 1250;
  String _monthlyIncome = '12.500.000';
  String _growthPercentage = '15.2';
  
  List<double> _jagungData = [4000, 4500, 5000, 5500, 6000, 6500];
  List<double> _padiData = [3000, 3200, 3500, 3800, 4000, 4200];
  List<double> _cabaiData = [2000, 2500, 3000, 3500, 4000, 4500];
  List<String> _months = ['Juni', 'Juli', 'Agustus', 'September', 'Oktober', 'November'];
  
  List<Map<String, dynamic>> _recentActivities = [];

  bool get isLoading => _isLoading;
  int get preOrderCount => _preOrderCount;
  int get buyNowCount => _buyNowCount;
  int get pendingDeliveryCount => _pendingDeliveryCount;
  int get totalStock => _totalStock;
  String get monthlyIncome => _monthlyIncome;
  String get growthPercentage => _growthPercentage;
  List<double> get jagungData => _jagungData;
  List<double> get padiData => _padiData;
  List<double> get cabaiData => _cabaiData;
  List<String> get months => _months;
  List<Map<String, dynamic>> get recentActivities => _recentActivities;

  BumdesProfileViewModel() {
    _initializeDummyData();
  }

  void _initializeDummyData() {
    _recentActivities = [
      {
        'type': 'penjualan',
        'title': 'Penjualan Padi ke Catering',
        'time': '2 jam yang lalu',
        'value': 'Rp 6.000.000',
      },
      {
        'type': 'pembelian',
        'title': 'Pembelian Pupuk Organik',
        'time': '5 jam yang lalu',
        'value': 'Rp 3.500.000',
      },
      {
        'type': 'panen',
        'title': 'Panen Jagung Super',
        'time': '1 hari yang lalu',
        'value': '500 kg',
      },
      {
        'type': 'penjualan',
        'title': 'Penjualan Cabai ke Pasar',
        'time': '2 hari yang lalu',
        'value': 'Rp 4.200.000',
      },
    ];
  }

  Future<void> loadProfileData() async {
    _isLoading = true;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    _isLoading = false;
    notifyListeners();
  }

  void refreshData() {
    loadProfileData();
  }
}