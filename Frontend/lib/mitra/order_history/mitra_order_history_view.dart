import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/repositories/riwayat_repository.dart';
import '../../../shared/widgets/order_status_timeline.dart';
import '../../../core/services/auth_service.dart';
import 'package:intl/intl.dart';

class MitraOrderHistoryView extends StatefulWidget {
  const MitraOrderHistoryView({super.key});

  @override
  State<MitraOrderHistoryView> createState() => _MitraOrderHistoryViewState();
}

class _MitraOrderHistoryViewState extends State<MitraOrderHistoryView> {
  late RiwayatRepository _riwayatRepository;
  late AuthService _authService;
  List<Map<String, dynamic>> _orders = [];
  bool _isLoading = true;
  String? _error;
  String? _mitraId;

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
      
      final mitraId = await _authService.getUserId();
      if (mitraId == null) {
        setState(() {
          _error = 'User ID not found';
          _isLoading = false;
        });
        return;
      }

      _mitraId = mitraId;

      // Fetch riwayat by mitra ID
      final response = await _riwayatRepository.getRiwayatByMitra(mitraId);
      
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

  Future<void> _confirmDelivery(String orderId) async {
    try {
      await _riwayatRepository.confirmDelivery(orderId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pesanan dikonfirmasi sebagai selesai'),
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
        title: const Text('Riwayat Pesanan'),
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
            Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Tidak ada riwayat pesanan',
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
            // Timeline
            if (orderId != null)
              OrderStatusTimeline(
                status: status,
                isMitra: true,
                onConfirmDelivery: () => _confirmDelivery(orderId),
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
