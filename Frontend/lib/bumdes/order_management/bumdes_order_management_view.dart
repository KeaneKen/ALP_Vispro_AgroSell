import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/repositories/riwayat_repository.dart';
import '../../../shared/widgets/order_status_timeline.dart';
import '../../../core/services/auth_service.dart';
import 'package:intl/intl.dart';

class BumdesOrderManagementView extends StatefulWidget {
  const BumdesOrderManagementView({super.key});

  @override
  State<BumdesOrderManagementView> createState() => _BumdesOrderManagementViewState();
}

class _BumdesOrderManagementViewState extends State<BumdesOrderManagementView> {
  late RiwayatRepository _riwayatRepository;
  late AuthService _authService;
  List<Map<String, dynamic>> _orders = [];
  bool _isLoading = true;
  String? _error;
  String? _bumdesId;

  @override
  void initState() {
    super.initState();
    _riwayatRepository = RiwayatRepository();
    _authService = AuthService();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    try {
      setState(() => _isLoading = true);
      
      // Fetch all riwayat (in a real app, filter by bumdes)
      final response = await _riwayatRepository.getAllRiwayat();
      
      if (response['success'] ?? false) {
        final List<dynamic> data = response['data'] ?? [];
        setState(() {
          _orders = data.cast<Map<String, dynamic>>();
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = response['message'] ?? 'Failed to load orders';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _updateOrderStatus(String orderId, String newStatus) async {
    try {
      await _riwayatRepository.updateStatus(orderId, newStatus);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Status pesanan diubah ke ${_getStatusLabel(newStatus)}'),
          backgroundColor: AppColors.success,
        ),
      );
      await _loadOrders();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Manajemen Pesanan'),
        elevation: 0,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 80, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(_error!, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadOrders,
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    if (_orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Tidak ada pesanan untuk dikelola',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _orders.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final order = _orders[index];
        return _buildOrderCard(order);
      },
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    final orderId = order['idHistory'] as String?;
    final status = order['status'] as String? ?? 'processing';
    final createdAt = order['created_at'] as String?;
    
    final formattedDate = createdAt != null
        ? DateFormat('dd MMM yyyy HH:mm').format(DateTime.parse(createdAt))
        : 'Unknown date';

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pesanan #${orderId?.substring(0, 3)}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formattedDate,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    _getStatusLabel(status),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: _getStatusColor(status),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            // Timeline with edit capability
            if (orderId != null)
              OrderStatusTimeline(
                status: status,
                isBumdes: true,
                onStatusChange: (newStatus) => _updateOrderStatus(orderId, newStatus),
              ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'processing':
        return Colors.orange;
      case 'given_to_courier':
        return Colors.blue;
      case 'on_the_way':
        return Colors.indigo;
      case 'arrived':
        return Colors.purple;
      case 'completed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _getStatusLabel(String status) {
    const labels = {
      'processing': 'Sedang Diproses',
      'given_to_courier': 'Diberikan ke Kurir',
      'on_the_way': 'Dalam Perjalanan',
      'arrived': 'Sampai Tujuan',
      'completed': 'Selesai',
    };
    return labels[status] ?? status;
  }
}
