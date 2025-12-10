import 'package:flutter/foundation.dart';

class DashboardViewModel extends ChangeNotifier {
  List<Map<String, String>> _products = [];
  bool _isLoading = false;
  String _searchQuery = '';

  List<Map<String, String>> get products => _products;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;

  DashboardViewModel() {
    loadProducts();
  }

  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();

    // Simulasi loading dari API
    await Future.delayed(const Duration(milliseconds: 500));

    // Data dummy produk harga termurah - nanti diganti dengan API call
    // Harga disesuaikan dengan HPP (Harga Pembelian Pemerintah) 2024-2025
    _products = [
      {
        'name': 'Gabah Kering Giling (GKG)',
        'category': 'Padi',
        'price': 'Rp 5.800/kg',
        'stock': 'Stok: 500kg',
        'rating': '4.8',
        'image': 'assets/images/padi 1.jpg',
        'isPreOrder': 'false',
      },
      {
        'name': 'Padi Varietas IR64',
        'category': 'Padi',
        'price': 'Rp 11.500/kg',
        'stock': 'Stok: 800kg',
        'rating': '4.9',
        'image': 'assets/images/padi 2.jpg',
        'isPreOrder': 'true',
      },
      {
        'name': 'Jagung Pipilan Kering',
        'category': 'jagung',
        'price': 'Rp 4.200/kg',
        'stock': 'Stok: 300kg',
        'rating': '4.6',
        'image': 'assets/images/jagung 1.jpg',
        'isPreOrder': 'true',
      },
      {
        'name': 'Cabai Merah Keriting',
        'category': 'cabai',
        'price': 'Rp 32.000/kg',
        'stock': 'Stok: 150kg',
        'rating': '4.7',
        'image': 'assets/images/cabe 1.jpg',
        'isPreOrder': 'false',
      },
      {
        'name': 'Cabai Rawit Hijau',
        'category': 'cabai',
        'price': 'Rp 45.000/kg',
        'stock': 'Stok: 100kg',
        'rating': '4.5',
        'image': 'assets/images/cabe 2.jpg',
        'isPreOrder': 'true',
      },
    ];

    _isLoading = false;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  List<Map<String, String>> get filteredProducts {
    if (_searchQuery.isEmpty) {
      return _products;
    }
    return _products.where((product) {
      return product['name']!
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
    }).toList();
  }
}
