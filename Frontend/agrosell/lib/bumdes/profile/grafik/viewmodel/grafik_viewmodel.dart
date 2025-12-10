import 'package:flutter/material.dart';

class GrafikViewModel with ChangeNotifier {
  bool _isLoading = true;
  List<String> _features = [
    'Grafik harga harian, mingguan, bulanan',
    'Perbandingan harga antar komoditas',
    'Prediksi harga berdasarkan tren',
    'Analisis pasar dan rekomendasi',
    'Data historis lengkap',
  ];

  bool get isLoading => _isLoading;
  List<String> get features => _features;

  Future<void> loadGrafikData() async {
    _isLoading = true;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    _isLoading = false;
    notifyListeners();
  }

  void refreshData() {
    loadGrafikData();
  }
}