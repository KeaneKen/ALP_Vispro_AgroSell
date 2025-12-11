import 'package:flutter/material.dart';

class BumdesProfileViewModel with ChangeNotifier {
  bool _isLoading = true;
  int _preOrderCount = 5;
  int _buyNowCount = 3;
  int _pendingDeliveryCount = 7;
  int _totalStock = 1250;
  String _monthlyIncome = '12.500.000';
  String _growthPercentage = '15.2';
  
  // Data harga bulanan dalam format yang lebih sederhana
  List<Map<String, dynamic>> _priceUpdates = [
    {
      'month': 'November 2024',
      'lastUpdate': '2 hari lalu',
      'prices': [
        {'commodity': 'Jagung', 'price': 15500, 'change': '+5.2%', 'trend': 'up'},
        {'commodity': 'Padi', 'price': 12200, 'change': '+3.4%', 'trend': 'up'},
        {'commodity': 'Cabai', 'price': 42000, 'change': '+8.7%', 'trend': 'up'},
      ],
    },
    {
      'month': 'Oktober 2024',
      'lastUpdate': '2 minggu lalu',
      'prices': [
        {'commodity': 'Jagung', 'price': 14700, 'change': '+2.1%', 'trend': 'up'},
        {'commodity': 'Padi', 'price': 11800, 'change': '-1.5%', 'trend': 'down'},
        {'commodity': 'Cabai', 'price': 38600, 'change': '+12.3%', 'trend': 'up'},
      ],
    },
    {
      'month': 'September 2024',
      'lastUpdate': '1 bulan lalu',
      'prices': [
        {'commodity': 'Jagung', 'price': 14400, 'change': '+4.3%', 'trend': 'up'},
        {'commodity': 'Padi', 'price': 12000, 'change': '+3.8%', 'trend': 'up'},
        {'commodity': 'Cabai', 'price': 34300, 'change': '+14.2%', 'trend': 'up'},
      ],
    },
  ];
  
  List<Map<String, dynamic>> _recentActivities = [];

  bool get isLoading => _isLoading;
  int get preOrderCount => _preOrderCount;
  int get buyNowCount => _buyNowCount;
  int get pendingDeliveryCount => _pendingDeliveryCount;
  int get totalStock => _totalStock;
  String get monthlyIncome => _monthlyIncome;
  String get growthPercentage => _growthPercentage;
  List<Map<String, dynamic>> get priceUpdates => _priceUpdates;
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