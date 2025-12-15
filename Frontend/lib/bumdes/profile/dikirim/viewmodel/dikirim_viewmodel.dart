import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/services/preorder_repository.dart';
import '../../../../core/services/auth_service.dart';

class DeliveryOrder {
  final String id;
  final String orderNumber;
  final String buyerName;
  final String productName;
  final double quantity;
  final String unit;
  final double totalPrice;
  final String paymentStatus;
  final String deliveryStatus;
  final String deliveryAddress;
  final String buyerPhone;
  final String deliveryDate;
  final String estimatedArrival;
  final String? driverName;
  final String? driverPhone;
  final String? notes;

  DeliveryOrder({
    required this.id,
    required this.orderNumber,
    required this.buyerName,
    required this.productName,
    required this.quantity,
    required this.unit,
    required this.totalPrice,
    required this.paymentStatus,
    required this.deliveryStatus,
    required this.deliveryAddress,
    required this.buyerPhone,
    required this.deliveryDate,
    required this.estimatedArrival,
    this.driverName,
    this.driverPhone,
    this.notes,
  });
}

class DikirimViewModel extends ChangeNotifier {
  String _selectedStatus = 'SEMUA';
  List<DeliveryOrder> _deliveryOrders = [];
  bool _isLoading = false;

  DikirimViewModel() {
    // Load initial data
    _loadDeliveryOrders();
  }

  void _loadDeliveryOrders() async {
    _isLoading = true;
    notifyListeners();

    try {
      final authService = AuthService();
      final userId = await authService.getUserId();

      if (userId == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }

      final preorderRepository = PreOrderRepository();
      final preOrders = await preorderRepository.getAllPreOrders(idBumDES: userId);

      // Transform PreOrders to DeliveryOrders
      _deliveryOrders = preOrders.map((po) {
        // Extract product details from first item if available
        String productName = '';
        int quantity = 0;
        String unit = '';

        if (po['items'] != null && (po['items'] as List).isNotEmpty) {
          final firstItem = po['items'][0];
          productName = firstItem['idPangan'] ?? '';
          quantity = int.tryParse(firstItem['quantity']?.toString() ?? '0') ?? 0;
          unit = 'Kg'; // Default unit
        }

        return DeliveryOrder(
          id: po['idPreOrder']?.toString() ?? '',
          orderNumber: 'PO-${po['idPreOrder']}',
          buyerName: po['idMitra'] ?? 'Mitra',
          productName: productName.isNotEmpty ? productName : 'Produk',
          quantity: quantity.toDouble(),
          unit: unit,
          totalPrice: double.tryParse(po['total_amount']?.toString() ?? '0') ?? 0.0,
          paymentStatus: _mapPaymentStatus(po['payment_status']),
          deliveryStatus: _mapDeliveryStatus(po['status']),
          deliveryAddress: 'Alamat dari Mitra',
          buyerPhone: '0812-3456-7890',
          deliveryDate: po['delivery_date']?.toString() ?? '',
          estimatedArrival: po['delivery_date']?.toString() ?? '',
          driverName: '',
          driverPhone: '',
          notes: po['notes'] ?? '',
        );
      }).toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error loading delivery orders: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  String _mapPaymentStatus(String? status) {
    if (status == null) return 'PENDING';
    switch (status.toUpperCase()) {
      case 'COMPLETED':
        return 'LUNAS';
      case 'PENDING':
        return 'BELUM LUNAS';
      case 'PARTIAL':
        return 'DP 50%';
      default:
        return status;
    }
  }

  String _mapDeliveryStatus(String? status) {
    if (status == null) return 'MENUNGGU PENGIRIMAN';
    switch (status.toUpperCase()) {
      case 'PENDING':
        return 'MENUNGGU PENGIRIMAN';
      case 'CONFIRMED':
        return 'MENUNGGU PENGIRIMAN';
      case 'SHIPPED':
        return 'SEDANG DIKIRIM';
      case 'DELIVERED':
        return 'SUDAH SAMPAI';
      case 'CANCELLED':
        return 'BATAL';
      default:
        return status;
    }
  }

  List<DeliveryOrder> get deliveryOrders => _deliveryOrders;
  String get selectedStatus => _selectedStatus;
  bool get isLoading => _isLoading;

  List<String> get statusFilters => ['SEMUA', 'SEDANG DIKIRIM', 'SUDAH SAMPAI', 'MENUNGGU', 'TERKENDALA'];

  void updateStatusFilter(String status) {
    _selectedStatus = status;
    notifyListeners();
  }

  List<DeliveryOrder> get filteredOrders {
    if (_selectedStatus == 'SEMUA') {
      return _deliveryOrders;
    }
    return _deliveryOrders.where((order) => order.deliveryStatus.toUpperCase() == _selectedStatus).toList();
  }

  void updateDeliveryStatus(String orderId, String newStatus) {
    final index = _deliveryOrders.indexWhere((order) => order.id == orderId);
    if (index != -1) {
      _deliveryOrders[index] = DeliveryOrder(
        id: _deliveryOrders[index].id,
        orderNumber: _deliveryOrders[index].orderNumber,
        buyerName: _deliveryOrders[index].buyerName,
        productName: _deliveryOrders[index].productName,
        quantity: _deliveryOrders[index].quantity,
        unit: _deliveryOrders[index].unit,
        totalPrice: _deliveryOrders[index].totalPrice,
        paymentStatus: _deliveryOrders[index].paymentStatus,
        deliveryStatus: newStatus,
        deliveryAddress: _deliveryOrders[index].deliveryAddress,
        buyerPhone: _deliveryOrders[index].buyerPhone,
        deliveryDate: _deliveryOrders[index].deliveryDate,
        estimatedArrival: _deliveryOrders[index].estimatedArrival,
        driverName: _deliveryOrders[index].driverName,
        driverPhone: _deliveryOrders[index].driverPhone,
        notes: _deliveryOrders[index].notes,
      );
      notifyListeners();
    }
  }

  // Statistics
  int get totalOrders => _deliveryOrders.length;
  int get totalDelivered => _deliveryOrders.where((order) => order.deliveryStatus == 'SUDAH SAMPAI').length;
  int get totalInProgress => _deliveryOrders.where((order) => order.deliveryStatus == 'SEDANG DIKIRIM').length;
  double get totalRevenue => _deliveryOrders.fold(0, (sum, order) => sum + order.totalPrice);

  // Helper untuk dialog kontak
  void showContactInfo(BuildContext context, DeliveryOrder order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Informasi Kontak'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Pembeli
              _buildContactSection(
                title: 'Pembeli',
                name: order.buyerName,
                phone: order.buyerPhone,
                address: order.deliveryAddress,
              ),
              
              // Kurir
              if (order.driverName != null) ...[
                const Divider(),
                _buildContactSection(
                  title: 'Kurir',
                  name: order.driverName!,
                  phone: order.driverPhone ?? '-',
                  address: null,
                ),
              ],
              
              // Informasi Pengiriman
              if (order.notes != null) ...[
                const Divider(),
                _buildInfoRow('Catatan:', order.notes!),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              // Aksi telepon
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

  Widget _buildContactSection({
    required String title,
    required String name,
    required String phone,
    required String? address,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        _buildInfoRow('Nama:', name),
        _buildInfoRow('Telepon:', phone),
        if (address != null) _buildInfoRow('Alamat:', address),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
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

  // Helper untuk warna status
  Color getDeliveryStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'SEDANG DIKIRIM':
        return AppColors.primary;
      case 'SUDAH SAMPAI':
        return AppColors.success;
      case 'MENUNGGU PENGIRIMAN':
        return AppColors.warning;
      case 'TERKENDALA':
        return AppColors.error;
      default:
        return AppColors.disabled;
    }
  }

  Color getPaymentStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'LUNAS':
        return AppColors.success;
      case 'DP 50%':
        return AppColors.warning;
      case 'BELUM LUNAS':
        return AppColors.error;
      default:
        return AppColors.disabled;
    }
  }

  IconData getDeliveryStatusIcon(String status) {
    switch (status.toUpperCase()) {
      case 'SEDANG DIKIRIM':
        return Icons.local_shipping;
      case 'SUDAH SAMPAI':
        return Icons.check_circle;
      case 'MENUNGGU PENGIRIMAN':
        return Icons.access_time;
      case 'TERKENDALA':
        return Icons.warning;
      default:
        return Icons.inventory;
    }
  }
}