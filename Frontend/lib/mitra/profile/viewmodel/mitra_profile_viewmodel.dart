import 'package:flutter/material.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/mitra_repository.dart';
import '../../../core/models/mitra_model.dart';
import '../../../core/config/api_config.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

// --- ENUM untuk Status Pengiriman (Timeline) ---
enum OrderStatus {
  paymentStatus, // Status Pembayaran
  inProcess, // Sedang Diproses (Tahap 2)
  shipped, // Dikirim (Tahap 3)
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
  final AuthService _authService = AuthService();
  final MitraRepository _mitraRepository = MitraRepository();
  
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

  MitraProfileViewModel() {
    fetchProfileData();
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
      
      // For now, keep sample data for orders and pre-orders
      // These should be fetched from backend when endpoints are available
      _orders = [
        OrderItem(
          id: '1',
          name: 'Jagung',
          type: 'Pre-Order',
          currentStatus: OrderStatus.inProcess,
          imageUrl: 'assets/images/jagung 1.jpg',
        ),
        OrderItem(
          id: '2',
          name: 'Cabai',
          type: 'Non Pre-Order',
          currentStatus: OrderStatus.shipped,
          imageUrl: 'assets/images/cabe 1.jpg',
        ),
        OrderItem(
          id: '3',
          name: 'Padi',
          type: 'Pre-Order',
          currentStatus: OrderStatus.paymentStatus,
          imageUrl: 'assets/images/padi 1.jpg',
        ),
      ];

      // Data Sample List & Detail Pre-Order
      _preOrders = [
        PreOrderItem(
          id: '1',
          name: 'Padi',
          harvestTime: 'Panen dalam waktu 2 bulan',
          imageUrl: 'assets/images/padi 2.jpg',
        ),
        PreOrderItem(
          id: '2',
          name: 'Jagung',
          harvestTime: 'Panen dalam waktu 1 Minggu',
          imageUrl: 'assets/images/jagung 2.jpg',
        ),
      ];
      
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
