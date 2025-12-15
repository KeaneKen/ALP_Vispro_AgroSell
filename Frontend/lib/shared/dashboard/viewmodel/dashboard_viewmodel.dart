import 'package:flutter/foundation.dart';
import '../../../core/services/pangan_repository.dart';
import '../../../core/models/pangan_model.dart';
import '../../../core/config/api_config.dart';
import 'package:intl/intl.dart';

class DashboardViewModel extends ChangeNotifier {
  final PanganRepository _panganRepository = PanganRepository();
  
  List<Map<String, String>> _products = [];
  List<PanganModel> _panganList = [];
  bool _isLoading = false;
  String _searchQuery = '';
  String? _error;
  String _selectedCategory = 'Semua';
  
  // Categories
  final List<String> categories = ['Semua', 'Padi', 'Jagung', 'Cabai', 'Lainnya'];

  List<Map<String, String>> get products => _products;
  List<PanganModel> get panganList => _panganList;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  String? get error => _error;
  String get selectedCategory => _selectedCategory;

  DashboardViewModel() {
    loadProducts();
  }

  Future<void> loadProducts() async {
    _isLoading = true;
    _error = null;
    // Clear any existing data
    _products = [];
    _panganList = [];
    notifyListeners();

    try {
      // ONLY fetch from database - no fallback
      debugPrint('🔄 Connecting to database API...');
      debugPrint('📡 API URL: ${ApiConfig.baseUrl}${ApiConfig.pangans}');
      
      _panganList = await _panganRepository.getAllPangan();
      
      debugPrint('✅ Successfully connected to database!');
      debugPrint('📦 Fetched ${_panganList.length} products from database');
      
      // If no products in database, show error
      if (_panganList.isEmpty) {
        debugPrint('⚠️ Database is empty - no products found');
        _error = 'Database is empty. Please seed the database.';
        _products = [];
        _isLoading = false;
        notifyListeners();
        return;
      }
      
      // Convert database PanganModel to UI format
      _products = _panganList.map((pangan) {
        final formatter = NumberFormat.currency(
          locale: 'id_ID',
          symbol: 'Rp ',
          decimalDigits: 0,
        );
        
        // Stock status based on price from database
        bool isPreOrder = pangan.hargaPangan > 30000;
        String stockStatus = isPreOrder ? 'Pre-Order' : 'Tersedia';
        
        // Get image directly from database field
        String imagePath = _mapDatabaseImageToAsset(pangan.idFotoPangan, pangan.idPangan);
        
        // debugPrint('📸 Product ${pangan.idPangan}: ${pangan.namaPangan} -> Image: $imagePath');
        
        return {
          'id': pangan.idPangan,
          'name': pangan.namaPangan,
          'category': pangan.category,
          'description': pangan.deskripsiPangan,
          'price': '${formatter.format(pangan.hargaPangan)}/kg',
          'rawPrice': pangan.hargaPangan.toString(),
          'stock': stockStatus,
          'rating': _getRandomRating(),
          'image': imagePath,
          'isPreOrder': isPreOrder ? 'true' : 'false',
          'dbImage': pangan.idFotoPangan, // Store original database value
        };
      }).toList();

      debugPrint('✅ Successfully loaded ${_products.length} products from database');
      
      // Log the first product to verify image paths
      if (_products.isNotEmpty) {
        debugPrint('Sample product data: ${_products.first}');
      }
    } catch (e) {
      _error = 'Cannot connect to database. Please ensure:\n'
          '1. Backend server is running (php artisan serve)\n'
          '2. Database is seeded (php artisan db:seed)\n'
          '3. Check your network connection';
      debugPrint('❌ Database connection failed: $e');
      debugPrint('📍 Attempted URL: ${ApiConfig.baseUrl}${ApiConfig.pangans}');
      debugPrint('💡 To start backend: cd Backend && php artisan serve');
      
      // No fallback - only database data
      _products = [];
      _panganList = [];
    }

    _isLoading = false;
    notifyListeners();
  }
  
  String _mapDatabaseImageToAsset(String dbImageName, String productId) {
    // Direct mapping from database image names to actual asset files
    // Database stores: beras.jpg, jagung.jpg, cabai_merah.jpg, etc.
    // Assets folder has: padi 1.jpg, jagung 1.jpg, cabe 1.jpg, etc.
    
    final imageMapping = {
      // Map database names to actual asset files
      'beras.jpg': 'padi 1.jpg',
      'gabah.jpg': 'padi 2.jpg',
      'padi.jpg': 'padi 3.jpg',
      'jagung.jpg': 'jagung 1.jpg',
      'jagung_pipil.jpg': 'jagung 2.jpg',
      'jagung_manis.jpg': 'jagung 3.jpg',
      'cabai_merah.jpg': 'cabe 1.jpg',
      'cabai_rawit.jpg': 'cabe 2.jpg',
      'cabai.jpg': 'cabe 3.jpg',
      // For products without specific images, use based on ID pattern
      'kedelai.jpg': 'jagung_manis.png',
      'singkong.jpg': 'padi 1.jpg',
      'ubi.jpg': 'padi 2.jpg',
      'kentang.jpg': 'jagung 1.jpg',
      'kacang_hijau.jpg': 'jagung 2.jpg',
      'gandum.jpg': 'padi 3.jpg',
      'sagu.jpg': 'jagung 3.jpg',
    };
    
    // Get the mapped image or use a default based on product ID
    String assetFile = imageMapping[dbImageName] ?? 'jagung_manis.png';
    
    // Special handling for specific product IDs if needed
    if (dbImageName.isEmpty) {
      // If no image in database, assign based on product ID
      switch (productId) {
        case 'P001':
        case 'P010':
          assetFile = 'padi 1.jpg';
          break;
        case 'P002':
        case 'P011':
          assetFile = 'jagung 1.jpg';
          break;
        case 'P012':
        case 'P013':
          assetFile = 'cabe 1.jpg';
          break;
        default:
          assetFile = 'jagung_manis.png';
      }
    }
    
    return 'assets/images/$assetFile';
  }
  
  String _getRandomRating() {
    final ratings = ['4.2', '4.5', '4.7', '4.8', '4.9'];
    return ratings[DateTime.now().microsecond % ratings.length];
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }
  
  void setSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }
  
  Future<void> refreshProducts() async {
    await loadProducts();
  }

  List<Map<String, String>> get filteredProducts {
    List<Map<String, String>> filtered = _products;
    
    // Filter by category
    if (_selectedCategory != 'Semua') {
      filtered = filtered.where((product) {
        return product['category'] == _selectedCategory;
      }).toList();
    }
    
    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((product) {
        final name = product['name']!.toLowerCase();
        final description = (product['description'] ?? '').toLowerCase();
        final query = _searchQuery.toLowerCase();
        return name.contains(query) || description.contains(query);
      }).toList();
    }
    
    // Sort by price for better display
    filtered.sort((a, b) {
      final priceA = double.tryParse(a['rawPrice'] ?? '0') ?? 0;
      final priceB = double.tryParse(b['rawPrice'] ?? '0') ?? 0;
      return priceA.compareTo(priceB);
    });
    
    return filtered;
  }
  
  Map<String, dynamic> get dashboardStats {
    return {
      'totalProducts': _products.length,
      'availableProducts': _products.where((p) => p['stock'] == 'Tersedia').length,
      'preOrderProducts': _products.where((p) => p['isPreOrder'] == 'true').length,
      'categories': categories.where((c) => c != 'Semua').length,
    };
  }
  
  // Remove demo data completely - we only use database data
  // This function is kept for emergency testing only
  void loadDemoDataForTesting() {
    debugPrint('❌ Demo data removed - only database data is used');
    _error = 'Demo data has been removed.\nPlease connect to the database.';
    _products = [];
    _panganList = [];
    _isLoading = false;
    notifyListeners();
  }
  
  // Always returns false since we removed demo data
  bool get isUsingDemoData => false;
}
