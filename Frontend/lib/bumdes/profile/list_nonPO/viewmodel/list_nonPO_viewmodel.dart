import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class OrderItem {
  final String productName;
  final double pricePerKg;
  final double quantity;

  OrderItem({
    required this.productName,
    required this.pricePerKg,
    required this.quantity,
  });

  double get subtotal => pricePerKg * quantity;
}

class Order {
  final String id;
  final String buyerName;
  final List<OrderItem> items;
  final String paymentStatus;
  final String deliveryAddress;
  final String buyerPhone;
  final DateTime orderDate;
  final String? notes;

  Order({
    required this.id,
    required this.buyerName,
    required this.items,
    required this.paymentStatus,
    required this.deliveryAddress,
    required this.buyerPhone,
    required this.orderDate,
    this.notes,
  });

  double get total => items.fold(0.0, (s, it) => s + it.subtotal);
}

class ListNonPOViewModel extends ChangeNotifier {
  List<Order> _orders = [];
  String _selectedStatus = 'SEMUA';
  bool _isLoading = false;

  ListNonPOViewModel() {
    loadOrders();
  }

  Future<void> loadOrders() async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Fetch orders from backend API
      // await _orderRepository.getAllOrders();
      await Future.delayed(const Duration(milliseconds: 500));
      _orders = [];
      
      debugPrint('📦 Orders loaded: ${_orders.length} items');
    } catch (e) {
      debugPrint('❌ Error loading orders: $e');
      _orders = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  List<Order> get orders => _orders;
  String get selectedStatus => _selectedStatus;
  bool get isLoading => _isLoading;

  List<String> get statusFilters => ['SEMUA', 'LUNAS', 'BELUM LUNAS', 'PROSES', 'ANTAR'];

  void updateStatusFilter(String status) {
    _selectedStatus = status;
    notifyListeners();
  }

  List<Order> get filteredOrders {
    if (_selectedStatus == 'SEMUA') {
      return _orders;
    }
    return _orders.where((order) => order.paymentStatus.toUpperCase() == _selectedStatus).toList();
  }

  void updateOrderStatus(String orderId, String newStatus) {
    final index = _orders.indexWhere((order) => order.id == orderId);
    if (index != -1) {
      _orders[index] = Order(
        id: _orders[index].id,
        buyerName: _orders[index].buyerName,
        items: _orders[index].items,
        paymentStatus: newStatus,
        deliveryAddress: _orders[index].deliveryAddress,
        buyerPhone: _orders[index].buyerPhone,
        orderDate: _orders[index].orderDate,
        notes: _orders[index].notes,
      );
      notifyListeners();
    }
  }

  int get totalOrders => _orders.length;
  double get totalRevenue => _orders.fold(0, (sum, order) => sum + order.total);

  // Untuk dialog kontak
  void showContactInfo(BuildContext context, Order order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Kontak Pembeli'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              order.buyerName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            _buildInfoRow('📱 No. Telepon:', order.buyerPhone),
            const SizedBox(height: 8),
            _buildInfoRow('📍 Alamat:', order.deliveryAddress),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              // Aksi telepon bisa ditambahkan di sini
              Navigator.pop(context);
              _showSnackbar(context, 'Menghubungi ${order.buyerName}...');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
            child: const Text('Telepon', style: TextStyle(color: AppColors.textLight)),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}