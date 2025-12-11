import 'package:flutter/material.dart';

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
  String _mitraName = 'Mitra 1';
  String _mitraType = 'Restoran';
  List<OrderItem> _orders = [];
  List<PreOrderItem> _preOrders = [];
  bool _isLoading = false;

  // State baru untuk melacak pesanan yang diperluas
  final Set<String> _expandedOrderIds = {};

  String get mitraName => _mitraName;
  String get mitraType => _mitraType;
  List<OrderItem> get orders => _orders;
  List<PreOrderItem> get preOrders => _preOrders;
  bool get isLoading => _isLoading;

  // Getter untuk memeriksa status expand
  bool isExpanded(String orderId) => _expandedOrderIds.contains(orderId);

  Future<void> fetchProfileData() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    // Data Sample Pesanan
    _orders = [
      OrderItem(
        id: '1',
        name: 'Jagung',
        type: 'Pre-Order',
        currentStatus: OrderStatus.inProcess,
        imageUrl: 'assets/images/corn.png',
      ),
      OrderItem(
        id: '2',
        name: 'Cabai',
        type: 'Non Pre-Order',
        currentStatus: OrderStatus.shipped,
        imageUrl: 'assets/images/chili.png',
      ),
      OrderItem(
        id: '3',
        name: 'Padi',
        type: 'Pre-Order',
        currentStatus: OrderStatus.paymentStatus,
        imageUrl: 'assets/images/rice.png',
      ),
    ];

    // Data Sample List & Detail Pre-Order
    _preOrders = [
      PreOrderItem(
        id: '1',
        name: 'Padi ',
        harvestTime: 'Panen dalam waktu 2 bulan',
        imageUrl: 'assets/images/rice_field.png',
      ),
      PreOrderItem(
        id: '2',
        name: 'Jagung',
        harvestTime: 'Panen dalam waktu 1 Minggu',
        imageUrl: 'assets/images/corn_field.png',
      ),
    ];

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
}
