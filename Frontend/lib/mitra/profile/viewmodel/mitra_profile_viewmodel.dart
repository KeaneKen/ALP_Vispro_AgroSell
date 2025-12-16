import 'package:flutter/material.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/mitra_repository.dart';
import '../../../core/services/riwayat_repository.dart';
import '../../../core/services/preorder_repository.dart';
import '../../../core/models/mitra_model.dart';
import '../../../core/models/riwayat_model.dart';
import '../../../core/config/api_config.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

// --- ENUM untuk Status Pengiriman (Timeline) ---
enum OrderStatus {
  processing, // Sedang Diproses (Tahap 1)
  givenToCourier, // Diserahkan ke Kurir (Tahap 2)
  onTheWay, // Dalam Perjalanan (Tahap 3)
  arrived, // Sampai Tujuan (Tahap 4)
  completed, // Pesanan Selesai
}

// --- MODEL DATA PESANAN ---
class OrderItem {
  final String id;
  final String name;
  final String type; // 'Pre-Order' atau 'Non Pre-Order'
  final OrderStatus currentStatus;
  final String imageUrl;

  OrderItem({
    required this.id,
    required this.name,
    required this.type,
    required this.currentStatus,
    required this.imageUrl,
  });
}

// --- MODEL DATA PRE-ORDER ---
class PreOrderItem {
  final String id;
  final String name;
  final String harvestTime;
  final String imageUrl;

  PreOrderItem({
    required this.id,
    required this.name,
    required this.harvestTime,
    required this.imageUrl,
  });
}

// --- VIEWMODEL ---
class MitraProfileViewModel extends ChangeNotifier {
  // Singleton instance so other parts of the app can request a refresh
  static final MitraProfileViewModel _instance = MitraProfileViewModel._internal();
  factory MitraProfileViewModel() => _instance;
  MitraProfileViewModel._internal() {
    fetchProfileData();
  }

  final AuthService _authService = AuthService();
  final MitraRepository _mitraRepository = MitraRepository();
  final RiwayatRepository _riwayatRepository = RiwayatRepository();
  final PreOrderRepository _preOrderRepository = PreOrderRepository();
  
  String _mitraName = 'Loading...';
  String _mitraType = 'Loading...';
  String _mitraEmail = '';
  String _mitraPhone = '';
  String? _profilePicture;
  List<OrderItem> _orders = [];
  List<PreOrderItem> _preOrders = [];
  bool _isLoading = false;
  String? _error;

  // State baru untuk melacak pesanan yang diperluas
  final Set<String> _expandedOrderIds = {};

  String get mitraName => _mitraName;
  String get mitraType => _mitraType;
  String get mitraEmail => _mitraEmail;
  String get mitraPhone => _mitraPhone;
  String? get profilePicture => _profilePicture;
  List<OrderItem> get orders => _orders;
  List<PreOrderItem> get preOrders => _preOrders;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Getter untuk memeriksa status expand
  bool isExpanded(String orderId) => _expandedOrderIds.contains(orderId);

  

  /// Fetch pre-orders from backend and map to `PreOrderItem`
  Future<void> _fetchPreOrders(String mitraId) async {
    try {
      final data = await _preOrderRepository.getAllPreOrders(idMitra: mitraId);
      _preOrders = data.map((item) {
        final id = item['id']?.toString() ?? '';
        final name = item['name'] ?? item['nama'] ?? 'Produk';
        final harvest = item['harvest_time'] ?? item['harvestTime'] ?? item['panen'] ?? '';
        String image = 'assets/images/default.jpg';
        final imgField = item['image'] ?? item['image_url'] ?? item['gambar'];
        if (imgField != null && imgField.toString().isNotEmpty) {
          image = imgField.toString();
        }
        return PreOrderItem(
          id: id,
          name: name,
          harvestTime: harvest,
          imageUrl: image,
        );
      }).toList();
      debugPrint('✅ Loaded ${_preOrders.length} pre-orders for mitra $mitraId');
    } catch (e) {
      debugPrint('⚠️ Failed to load pre-orders: $e');
      _preOrders = [];
    }
  }

  Future<void> fetchProfileData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Get current mitra ID from auth service
      final mitraId = await _authService.getMitraId();
      
      if (mitraId == null) {
        throw Exception('User not logged in');
      }

      // Fetch mitra data from backend
      final mitra = await _mitraRepository.getMitraById(mitraId);
      
      // Update profile data
      _mitraName = mitra.namaMitra;
      _mitraEmail = mitra.emailMitra;
      _mitraPhone = mitra.noTelpMitra ?? '';
      
      // Check if profile picture exists
      if (mitra.profilePicture != null && mitra.profilePicture!.isNotEmpty) {
        final baseUrl = ApiConfig.baseUrl.replaceAll('/api', '');
        _profilePicture = '$baseUrl/storage/profile_pictures/${mitra.profilePicture}';
      }
      
      // Set mitra type based on business logic or add it to the model if needed
      _mitraType = 'Restoran'; // This could be fetched from database if you add a type field
      
      // Fetch real order history from backend
      await _fetchOrderHistory();
      
      // Load pre-orders from backend for this Mitra
      await _fetchPreOrders(mitraId);
      
      debugPrint('✅ Mitra profile loaded: $mitraName');
    } catch (e) {
      _error = e.toString();
      debugPrint('❌ Error loading mitra profile: $e');
      
      // Set default values on error
      _mitraName = 'Failed to load';
      _mitraType = 'Unknown';
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Fetch order history from backend (filtered by current Mitra)
  Future<void> _fetchOrderHistory() async {
    try {
      final mitraId = await _authService.getMitraId();
      if (mitraId == null || mitraId.isEmpty) {
        throw Exception('Mitra ID not available');
      }

      // Use per-mitra endpoint to ensure only this Mitra's orders are shown
      final riwayatList = await _riwayatRepository.getRiwayatByMitra(mitraId);
      
      _orders = riwayatList.map((riwayat) {
        // Map backend status to OrderStatus enum
        OrderStatus status;
        switch (riwayat.status) {
          case 'processing':
            status = OrderStatus.processing;
            break;
          case 'given_to_courier':
            status = OrderStatus.givenToCourier;
            break;
          case 'on_the_way':
            status = OrderStatus.onTheWay;
            break;
          case 'arrived':
            status = OrderStatus.arrived;
            break;
          case 'completed':
            status = OrderStatus.completed;
            break;
          default:
            status = OrderStatus.processing;
        }
        
        // Get product name from payment -> cart -> pangan relationship
        String productName = 'Product';
        String imageUrl = 'assets/images/default.jpg';
        
        if (riwayat.payment?.cart?.pangan != null) {
          productName = riwayat.payment!.cart!.pangan!.namaPangan;
          // You can add image mapping logic here if needed
          if (productName.toLowerCase().contains('jagung')) {
            imageUrl = 'assets/images/padi 1.jpg';
          } else if (productName.toLowerCase().contains('cabai') || productName.toLowerCase().contains('cabe')) {
            imageUrl = 'assets/images/cabe 1.jpg';
          } else if (productName.toLowerCase().contains('padi')) {
            imageUrl = 'assets/images/padi 1.jpg';
          }
        }
        
        return OrderItem(
          id: riwayat.idHistory,
          name: productName,
          type: riwayat.status == 'completed' ? 'Selesai' : 'Dalam Proses',
          currentStatus: status,
          imageUrl: imageUrl,
        );
      }).toList();
      
      debugPrint('✅ Loaded ${_orders.length} orders from backend');
    } catch (e) {
      debugPrint('⚠️ Failed to load order history: $e');
      // Keep empty list on error
      _orders = [];
    }
  }

  // Fungsi baru untuk membuka/menutup detail pesanan
  void toggleOrderExpand(String orderId) {
    if (_expandedOrderIds.contains(orderId)) {
      _expandedOrderIds.remove(orderId);
    } else {
      _expandedOrderIds.add(orderId);
    }
    notifyListeners();
  }

  void updateMitraName(String name) {
    _mitraName = name;
    notifyListeners();
  }

  /// Confirm order completion (Mitra marks as "Pesanan Selesai")
  Future<void> confirmOrderCompletion(String orderId) async {
    try {
      await _riwayatRepository.updateOrderStatus(orderId, 'completed');
      // Reload order history after update
      await _fetchOrderHistory();
      notifyListeners();
      debugPrint('✅ Order $orderId marked as completed');
    } catch (e) {
      debugPrint('❌ Failed to confirm order completion: $e');
      throw Exception('Gagal mengkonfirmasi pesanan: $e');
    }
  }

  void updateMitraType(String type) {
    _mitraType = type;
    notifyListeners();
  }

  Future<void> uploadProfilePicture(File imageFile) async {
    _isLoading = true;
    notifyListeners();

    try {
      final mitraId = await _authService.getMitraId();
      if (mitraId == null) {
        throw Exception('User not logged in');
      }

      // Create multipart request - use ApiConfig for correct URL
      final baseUrl = ApiConfig.baseUrl.replaceAll('/api', '');
      final uri = Uri.parse('$baseUrl/api/mitra/$mitraId/upload-profile-picture');
      final request = http.MultipartRequest('POST', uri);
      
      // Add file to request
      final stream = http.ByteStream(imageFile.openRead());
      final length = await imageFile.length();
      final multipartFile = http.MultipartFile(
        'profile_picture',
        stream,
        length,
        filename: 'profile_$mitraId.jpg',
      );
      request.files.add(multipartFile);
      
      // Send request
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      
      if (response.statusCode == 200) {
        // Parse response to get the image URL
        final data = json.decode(responseBody);
        _profilePicture = data['data']['profile_picture_url'];
        notifyListeners();
      } else {
        throw Exception('Failed to upload profile picture');
      }
    } catch (e) {
      _error = e.toString();
      debugPrint('Error uploading profile picture: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
