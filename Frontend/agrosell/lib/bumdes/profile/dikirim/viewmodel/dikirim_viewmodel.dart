import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

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

  DikirimViewModel() {
    // Load initial data
    _loadDeliveryOrders();
  }

  void _loadDeliveryOrders() {
    _deliveryOrders = [
      DeliveryOrder(
        id: '1',
        orderNumber: 'ORD-001',
        buyerName: 'Catering Tukang Las',
        productName: 'Jagung Super Sigma',
        quantity: 50,
        unit: 'kg',
        totalPrice: 325000,
        paymentStatus: 'LUNAS',
        deliveryStatus: 'SEDANG DIKIRIM',
        deliveryAddress: 'Jl. Industri No. 45, Kecamatan Sambikerep, Surabaya',
        buyerPhone: '081234567890',
        deliveryDate: '15 Nov 2023',
        estimatedArrival: '16 Nov 2023, 14:00',
        driverName: 'Budi Santoso',
        driverPhone: '081298765432',
        notes: 'Barang fragile, harap hati-hati',
      ),
      DeliveryOrder(
        id: '2',
        orderNumber: 'ORD-002',
        buyerName: 'Resto Anak Muda',
        productName: 'Paket Sayuran Organik',
        quantity: 25,
        unit: 'kg',
        totalPrice: 750000,
        paymentStatus: 'LUNAS',
        deliveryStatus: 'SUDAH SAMPAI',
        deliveryAddress: 'Jl. Pemuda No. 12, Kecamatan Wonokromo, Surabaya',
        buyerPhone: '081234567891',
        deliveryDate: '14 Nov 2023',
        estimatedArrival: '14 Nov 2023, 10:30',
        driverName: 'Ahmad Fauzi',
        driverPhone: '081287654321',
        notes: 'Pesanan urgent, prioritas',
      ),
      DeliveryOrder(
        id: '3',
        orderNumber: 'ORD-003',
        buyerName: 'Toko Sembako Sejahtera',
        productName: 'Beras Premium',
        quantity: 100,
        unit: 'kg',
        totalPrice: 1200000,
        paymentStatus: 'DP 50%',
        deliveryStatus: 'MENUNGGU PENGIRIMAN',
        deliveryAddress: 'Jl. Raya Darmo Permai III No. 8, Surabaya',
        buyerPhone: '081234567892',
        deliveryDate: '17 Nov 2023',
        estimatedArrival: '17 Nov 2023, 16:00',
        notes: 'Konfirmasi sebelum dikirim',
      ),
      DeliveryOrder(
        id: '4',
        orderNumber: 'ORD-004',
        buyerName: 'Warung Makan Sederhana',
        productName: 'Cabai Rawit Merah',
        quantity: 10,
        unit: 'kg',
        totalPrice: 320000,
        paymentStatus: 'LUNAS',
        deliveryStatus: 'TERKENDALA',
        deliveryAddress: 'Jl. Kenjeran No. 88, Surabaya',
        buyerPhone: '081234567893',
        deliveryDate: '13 Nov 2023',
        estimatedArrival: '14 Nov 2023, 12:00',
        driverName: 'Surya Wijaya',
        driverPhone: '081276543210',
        notes: 'Alamat susah ditemukan, hubungi pembeli',
      ),
      DeliveryOrder(
        id: '5',
        orderNumber: 'ORD-005',
        buyerName: 'Cafe Kopi Tenang',
        productName: 'Kopi Arabika',
        quantity: 5,
        unit: 'kg',
        totalPrice: 450000,
        paymentStatus: 'LUNAS',
        deliveryStatus: 'SEDANG DIKIRIM',
        deliveryAddress: 'Jl. Rungkut Asri No. 21, Surabaya',
        buyerPhone: '081234567894',
        deliveryDate: '16 Nov 2023',
        estimatedArrival: '16 Nov 2023, 15:30',
        driverName: 'Rudi Hartono',
        driverPhone: '081265432198',
      ),
      DeliveryOrder(
        id: '6',
        orderNumber: 'ORD-005',
        buyerName: 'Cafe Kopi Tenang',
        productName: 'Kopi Arabika',
        quantity: 5,
        unit: 'kg',
        totalPrice: 450000,
        paymentStatus: 'LUNAS',
        deliveryStatus: 'SEDANG DIKIRIM',
        deliveryAddress: 'Jl. Rungkut Asri No. 21, Surabaya',
        buyerPhone: '081234567894',
        deliveryDate: '16 Nov 2023',
        estimatedArrival: '16 Nov 2023, 15:30',
        driverName: 'Rudi Hartono',
        driverPhone: '081265432198',
      ),
      DeliveryOrder(
        id: '7',
        orderNumber: 'ORD-005',
        buyerName: 'Cafe Kopi Tenang',
        productName: 'Kopi Arabika',
        quantity: 5,
        unit: 'kg',
        totalPrice: 450000,
        paymentStatus: 'LUNAS',
        deliveryStatus: 'SEDANG DIKIRIM',
        deliveryAddress: 'Jl. Rungkut Asri No. 21, Surabaya',
        buyerPhone: '081234567894',
        deliveryDate: '16 Nov 2023',
        estimatedArrival: '16 Nov 2023, 15:30',
        driverName: 'Rudi Hartono',
        driverPhone: '081265432198',
      ),
    ];
    notifyListeners();
  }

  List<DeliveryOrder> get deliveryOrders => _deliveryOrders;
  String get selectedStatus => _selectedStatus;

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