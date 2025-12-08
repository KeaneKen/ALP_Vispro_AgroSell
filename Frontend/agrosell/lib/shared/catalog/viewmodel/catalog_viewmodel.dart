import 'package:flutter/material.dart';

class CatalogViewModel extends ChangeNotifier {
  List<Map<String, String>> _allProducts = [];
  List<Map<String, String>> _filteredProducts = [];
  String _selectedFilter = 'ALL';
  String _searchQuery = '';
  bool _isLoading = false;

  // Getters
  List<Map<String, String>> get filteredProducts => _filteredProducts;
  String get selectedFilter => _selectedFilter;
  bool get isLoading => _isLoading;

  // Initialize products (nanti dari API)
  void loadProducts({String? initialFilter}) {
    _isLoading = true;
    notifyListeners();

    // Simulasi data - katalog lengkap (nanti ganti dengan API call)
    // Harga disesuaikan dengan HPP (Harga Pembelian Pemerintah) 2024-2025
    _allProducts = [
      // Produk Padi
      {
        'name': 'Gabah Kering Giling (GKG)',
        'category': 'Padi',
        'price': 'Rp 5.800/kg',
        'stock': 'Stok: 500kg',
        'rating': '4.8',
        'image': 'assets/images/padi 1.jpg',
      },
      {
        'name': 'Padi Varietas IR64',
        'category': 'Padi',
        'price': 'Rp 11.500/kg',
        'stock': 'Stok: 800kg',
        'rating': '4.9',
        'image': 'assets/images/padi 2.jpg',
      },
      {
        'name': 'Padi Organik Premium',
        'category': 'Padi',
        'price': 'Rp 13.000/kg',
        'stock': 'Stok: 300kg',
        'rating': '4.7',
        'image': 'assets/images/padi 3.jpg',
      },
      // Produk Jagung
      {
        'name': 'Jagung Pipilan Kering',
        'category': 'jagung',
        'price': 'Rp 4.200/kg',
        'stock': 'Stok: 300kg',
        'rating': '4.6',
        'image': 'assets/images/jagung 1.jpg',
      },
      {
        'name': 'Jagung Manis Segar',
        'category': 'jagung',
        'price': 'Rp 8.500/kg',
        'stock': 'Stok: 250kg',
        'rating': '4.7',
        'image': 'assets/images/jagung 2.jpg',
      },
      {
        'name': 'Jagung Hibrida',
        'category': 'jagung',
        'price': 'Rp 5.000/kg',
        'stock': 'Stok: 400kg',
        'rating': '4.5',
        'image': 'assets/images/jagung 3.jpg',
      },
      // Produk Cabai
      {
        'name': 'Cabai Merah Keriting',
        'category': 'cabai',
        'price': 'Rp 32.000/kg',
        'stock': 'Stok: 150kg',
        'rating': '4.7',
        'image': 'assets/images/cabe 1.jpg',
      },
      {
        'name': 'Cabai Rawit Hijau',
        'category': 'cabai',
        'price': 'Rp 45.000/kg',
        'stock': 'Stok: 100kg',
        'rating': '4.5',
        'image': 'assets/images/cabe 2.jpg',
      },
      {
        'name': 'Cabai Merah Besar',
        'category': 'cabai',
        'price': 'Rp 28.000/kg',
        'stock': 'Stok: 200kg',
        'rating': '4.6',
        'image': 'assets/images/cabe 3.jpg',
      },
    ];

    _selectedFilter = initialFilter ?? 'ALL';
    _filteredProducts = _allProducts;
    _isLoading = false;
    _applyFilters();
  }

  // Set filter
  void setFilter(String filter) {
    _selectedFilter = filter;
    _applyFilters();
  }

  // Set search query
  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  // Apply filters and search
  void _applyFilters() {
    _filteredProducts = _allProducts.where((product) {
      // Filter by category
      bool matchesFilter = _selectedFilter == 'ALL' || 
                          product['category'] == _selectedFilter;
      
      // Filter by search query
      bool matchesSearch = _searchQuery.isEmpty ||
                          product['name']!.toLowerCase().contains(_searchQuery.toLowerCase());
      
      return matchesFilter && matchesSearch;
    }).toList();
    
    notifyListeners();
  }
}
