import 'package:flutter/material.dart';

class ListPoViewModel with ChangeNotifier {
  bool _isLoading = true;
  List<Map<String, dynamic>> _preOrders = [];

  bool get isLoading => _isLoading;
  List<Map<String, dynamic>> get preOrders => _preOrders;

  ListPoViewModel() {
    _initializeDummyData();
  }

  void _initializeDummyData() {
    _preOrders = [
      {
        'id': 'PO-001',
        'customer': 'Catering Tukang Las',
        'harvestDate': '27 Januari 2026',
        'status': 'Siap Panen',
        'paymentStatus': 'Lunas',
        'products': [
          {
            'name': 'Jagung Super Sigma Keane',
            'quantity': '14 kg',
            'plantStatus': '80% tanaman sudah mulai menguning dan mendekati masa panen. Sebagian kecil tanaman mengalami hambatan karena kondisi tanah, namun masih dalam tahap pemantauan.',
          },
          {
            'name': 'Padi Super Sigma Keane',
            'quantity': '20 kg',
            'plantStatus': 'Panen diperkirakan siap dalam beberapa hari lagi, tahap aktivitas sedang berlangsung.',
          },
        ],
      },
      {
        'id': 'PO-002',
        'customer': 'Resto Anak Muda',
        'harvestDate': '25 Januari 2026',
        'status': 'Proses',
        'paymentStatus': 'DP 50%',
        'products': [
          {
            'name': 'Cabai Rawit Merah',
            'quantity': '8 kg',
            'plantStatus': 'Tanaman sedang dalam masa pertumbuhan optimal, perkiraan panen sesuai jadwal.',
          },
        ],
      },
      {
        'id': 'PO-003',
        'customer': 'Catering Tukang Las',
        'harvestDate': '12 Oktober 2026',
        'status': 'Pending',
        'paymentStatus': 'Belum Bayar',
        'products': [
          {
            'name': 'Kedelai Hitam',
            'quantity': '30 kg',
            'plantStatus': 'Persiapan lahan sedang dilakukan, penanaman akan dimulai minggu depan.',
          },
        ],
      },
      {
        'id': 'PO-004',
        'customer': 'Warung Sederhana',
        'harvestDate': '15 Maret 2026',
        'status': 'Siap Panen',
        'paymentStatus': 'Lunas',
        'products': [
          {
            'name': 'Bawang Merah',
            'quantity': '25 kg',
            'plantStatus': 'Tanaman sudah siap panen, kondisi optimal dengan hasil yang maksimal.',
          },
        ],
      },
      {
        'id': 'PO-005',
        'customer': 'Toko Roti Maju',
        'harvestDate': '28 Februari 2026',
        'status': 'Proses',
        'paymentStatus': 'DP 30%',
        'products': [
          {
            'name': 'Gandum Lokal',
            'quantity': '50 kg',
            'plantStatus': 'Pertumbuhan baik, membutuhkan pemupukan tambahan dalam 2 minggu.',
          },
        ],
      },
    ];
  }

  Future<void> loadPreOrders() async {
    _isLoading = true;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    _isLoading = false;
    notifyListeners();
  }

  void refreshData() {
    loadPreOrders();
  }
}