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

  // Map category to asset image
  String _getCategoryImage(String category, String? idFotoPangan) {
    // First, try to match specific product images from assets
    if (idFotoPangan != null && idFotoPangan.isNotEmpty) {
      final lower = idFotoPangan.toLowerCase();

      // If the database stores the actual asset filename (e.g. 'cabe 1.jpg'), use it directly
      if (lower.startsWith('cabe') || lower.startsWith('padi') || lower.startsWith('jagung') || lower.contains('cabe') || lower.contains('padi') || lower.contains('jagung')) {
        return 'assets/images/$idFotoPangan';
      }

      // Map legacy database image names to actual asset files
      final imageMap = {
        'cabai_merah.jpg': 'assets/images/cabe 1.jpg',
        'cabai_rawit.jpg': 'assets/images/cabe 2.jpg',
        'cabai.jpg': 'assets/images/cabe 3.jpg',
         'jagung.jpg': 'assets/images/padi 1.jpg',
         'jagung_pipil.jpg': 'assets/images/padi 2.jpg',
         'jagung_manis.png': 'assets/images/padi 3.jpg',
        'beras.jpg': 'assets/images/padi 1.jpg',
        'gabah.jpg': 'assets/images/padi 2.jpg',
        'padi.jpg': 'assets/images/padi 3.jpg',
      };
      
      if (imageMap.containsKey(idFotoPangan)) {
        return imageMap[idFotoPangan]!;
      }
    }
    
    // Fallback to category-based images
    switch (category.toLowerCase()) {
      case 'padi':
        return 'assets/images/padi 1.jpg';
      case 'jagung':
         return 'assets/images/padi 1.jpg';
      case 'cabai':
        return 'assets/images/cabe 1.jpg';
      case 'sayuran':
         return 'assets/images/padi 1.jpg'; // Use available image as placeholder
      case 'buah':
         return 'assets/images/padi 1.jpg'; // Use available image as placeholder
      default:
         return 'assets/images/padi 1.jpg'; // Default fallback
    }
  }

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
        // Get appropriate image based on product
        final imagePath = _getCategoryImage(pangan.category, pangan.idFotoPangan);
        
        // Determine stock status based on some logic (can be enhanced)
        String stockStatus = 'Tersedia';
        bool isPreOrder = false;
        
        // You can add logic here to determine stock/PO status from database
        if (pangan.hargaPangan > 30000) {
          isPreOrder = true;
          stockStatus = 'Pre-Order';
        }
        
        return {
          'id': pangan.idPangan,
          'name': pangan.namaPangan,
          'category': pangan.category,
          'description': pangan.deskripsiPangan,
          'price': '${formatter.format(pangan.hargaPangan)}/kg',
          'rawPrice': pangan.hargaPangan.toString(),
          'stock': stockStatus,
          'rating': '4.5',
          'image': imagePath,
          'isPreOrder': isPreOrder.toString(),
          'idFotoPangan': pangan.idFotoPangan,
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
                          product['category']!.toLowerCase() == _selectedFilter.toLowerCase() ||
                          (_selectedFilter == 'PO' && product['isPreOrder'] == 'true');
      
      // Filter by search query
      bool matchesSearch = _searchQuery.isEmpty ||
                          product['name']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                          product['description']!.toLowerCase().contains(_searchQuery.toLowerCase());
      
      return matchesFilter && matchesSearch;
    }).toList();
    
    notifyListeners();
  }
}
