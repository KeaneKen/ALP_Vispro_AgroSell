import 'package:flutter/foundation.dart';
import '../../../core/services/pangan_repository.dart';
import '../../../core/models/pangan_model.dart';
import 'package:intl/intl.dart';

class DashboardViewModel extends ChangeNotifier {
  final PanganRepository _panganRepository = PanganRepository();
  
  List<Map<String, String>> _products = [];
  bool _isLoading = false;
  String _searchQuery = '';
  String? _error;

  List<Map<String, String>> get products => _products;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  String? get error => _error;

  DashboardViewModel() {
    loadProducts();
  }

  Future<void> loadProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Fetch from API
      final panganList = await _panganRepository.getAllPangan();
      
      // Convert PanganModel to Map for UI compatibility
      _products = panganList.map((pangan) {
        final formatter = NumberFormat.currency(
          locale: 'id_ID',
          symbol: 'Rp ',
          decimalDigits: 0,
        );
        
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

      debugPrint('✅ Loaded ${_products.length} products from database');
    } catch (e) {
      _error = e.toString();
      debugPrint('❌ Error loading products: $e');
      _products = []; // Clear products on error
    }

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
