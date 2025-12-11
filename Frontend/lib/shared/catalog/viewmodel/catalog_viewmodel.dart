import 'package:flutter/material.dart';
import '../../../core/services/pangan_repository.dart';
import '../../../core/models/pangan_model.dart';
import 'package:intl/intl.dart';

class CatalogViewModel extends ChangeNotifier {
  final PanganRepository _panganRepository = PanganRepository();
  
  List<Map<String, String>> _allProducts = [];
  List<Map<String, String>> _filteredProducts = [];
  String _selectedFilter = 'ALL';
  String _searchQuery = '';
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Map<String, String>> get filteredProducts => _filteredProducts;
  String get selectedFilter => _selectedFilter;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Initialize products from database
  Future<void> loadProducts({String? initialFilter}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Fetch from API
      final panganList = await _panganRepository.getAllPangan();
      
      // Convert PanganModel to Map for UI compatibility
      final formatter = NumberFormat.currency(
        locale: 'id_ID',
        symbol: 'Rp ',
        decimalDigits: 0,
      );

      _allProducts = panganList.map((pangan) {
        return {
          'id': pangan.idPangan,
          'name': pangan.namaPangan,
          'category': 'Pangan',
          'price': '${formatter.format(pangan.hargaPangan)}/kg',
          'stock': 'Tersedia',
          'rating': '4.5',
          'image': 'assets/images/default_product.png', // Will use icon if missing
          'isPreOrder': 'false',
        };
      }).toList();

      debugPrint('✅ Loaded ${_allProducts.length} products from database');

      _selectedFilter = initialFilter ?? 'ALL';
      _filteredProducts = _allProducts;
      _applyFilters();
    } catch (e) {
      _error = e.toString();
      debugPrint('❌ Error loading products: $e');
      _allProducts = [];
      _filteredProducts = [];
    }

    _isLoading = false;
    notifyListeners();
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
      // Filter by category or pre-order
      bool matchesFilter = _selectedFilter == 'ALL' || 
                          product['category'] == _selectedFilter ||
                          (_selectedFilter == 'PO' && product['isPreOrder'] == 'true');
      
      // Filter by search query
      bool matchesSearch = _searchQuery.isEmpty ||
                          product['name']!.toLowerCase().contains(_searchQuery.toLowerCase());
      
      return matchesFilter && matchesSearch;
    }).toList();
    
    notifyListeners();
  }
}
