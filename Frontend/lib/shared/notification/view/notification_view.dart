import 'package:flutter/material.dart';
import '../viewmodel/notification_viewmodel.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/pangan_repository.dart'; // Add this import
import '../../cart/cart_route.dart';
import '../../chat/chat_route.dart';
import '../../product_detail/product_detail_route.dart';
import 'package:intl/intl.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({Key? key}) : super(key: key);

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  late NotificationViewModel _viewModel;
  final AuthService _authService = AuthService();
  final PanganRepository _panganRepository = PanganRepository(); // Add this

  @override
  void initState() {
    super.initState();
    _viewModel = NotificationViewModel();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _handleNotificationTap(NotificationItem notification) async {
    // Mark as read
    _viewModel.markAsRead(notification.id);

    // Navigate based on notification type
    if (notification.actionData != null) {
      switch (notification.type) {
        case NotificationType.chat:
          final userType = await _authService.getUserType();
          final userId = await _authService.getUserId();
          
          ChatRoute.navigate(
            context,
            contactName: notification.actionData!['senderType'] == 'mitra' 
                ? 'Mitra' 
                : 'BumDes',
            mitraId: notification.actionData!['idMitra'] ?? (userType == 'mitra' ? userId ?? 'M001' : 'M001'),
            bumdesId: notification.actionData!['idBumDes'] ?? (userType == 'bumdes' ? userId ?? 'B001' : 'B001'),
            currentUserType: userType ?? 'mitra',
          );
          break;

        case NotificationType.pangan:
          // Fetch full product data before navigating
          await _navigateToProductDetail(notification.actionData!['idPangan']);
          break;

        case NotificationType.system:
          // Check if this is a pangan notification (fallback for old notifications)
          if (notification.actionData!.containsKey('idPangan')) {
            await _navigateToProductDetail(notification.actionData!['idPangan']);
          }
          break;

        default:
          // Handle other notification types if needed
          final route = notification.actionData!['route'];
          if (route == 'cart') {
            final userType = await _authService.getUserType();
            if (userType != 'bumdes') {
              CartRoute.navigate(context);
            }
          }
          break;
      }
    }
  }

  // New method to fetch and navigate to product detail
  Future<void> _navigateToProductDetail(String productId) async {
    try {
      debugPrint('🔍 Navigating to product with ID: $productId');
      
      // Validate product ID
      if (productId.isEmpty) {
        throw Exception('Product ID is empty');
      }
      
      // Show loading indicator
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );

      // Fetch full product data
      debugPrint('🔍 Fetching product data from backend...');
      final pangan = await _panganRepository.getPanganById(productId);
      debugPrint('🔍 Received pangan: ${pangan.namaPangan}, price: ${pangan.hargaPangan}');
      
      // Close loading indicator
      if (!mounted) return;
      Navigator.pop(context);

      // Convert to product format expected by ProductDetailView
      final formatter = NumberFormat.currency(
        locale: 'id_ID',
        symbol: 'Rp ',
        decimalDigits: 0,
      );

      final product = {
        'id': pangan.idPangan,
        'name': pangan.namaPangan,
        'category': pangan.category,
        'description': pangan.deskripsiPangan,
        'price': '${formatter.format(pangan.hargaPangan)}/kg',
        'rawPrice': pangan.hargaPangan.toString(),
        'stock': pangan.hargaPangan > 30000 ? 'Pre-Order' : 'Tersedia',
        'rating': '4.5',
        'image': _getProductImage(pangan.category, pangan.idFotoPangan),
        'isPreOrder': (pangan.hargaPangan > 30000).toString(),
        'dbImage': pangan.idFotoPangan,
      };

      debugPrint('✅ Product data prepared successfully:');
      debugPrint('   Name: ${product['name']}');
      debugPrint('   Price: ${product['price']}');
      debugPrint('   Category: ${product['category']}');
      debugPrint('   Image: ${product['image']}');

      // Navigate to product detail
      if (!mounted) return;
      ProductDetailRoute.navigate(context, product);
    } catch (e) {
      debugPrint('❌ Error in _navigateToProductDetail: $e');
      
      // Close loading indicator if still showing
      if (mounted && Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      // Show error message
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memuat detail produk: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  // Helper method to get product image
  String _getProductImage(String category, String idFotoPangan) {
    final imageMapping = {
      'beras.jpg': 'padi 1.jpg',
      'gabah.jpg': 'padi 2.jpg',
      'padi.jpg': 'padi 3.jpg',
      'jagung.jpg': 'jagung 1.jpg',
      'jagung_pipil.jpg': 'jagung 2.jpg',
      'jagung_manis.jpg': 'jagung 3.jpg',
      'cabai_merah.jpg': 'cabe 1.jpg',
      'cabai_hijau.jpg': 'cabe 2.jpg',
      'cabai_rawit.jpg': 'cabe 3.jpg',
    };

    final assetFile = imageMapping[idFotoPangan] ?? 'jagung_manis.png';
    return 'assets/images/$assetFile';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        automaticallyImplyLeading: false,
        title: const Text(
          'Notifikasi',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => _viewModel.refresh(),
          ),
          IconButton(
            icon: const Icon(Icons.done_all, color: Colors.white),
            onPressed: () {
              _viewModel.markAllAsRead();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Semua notifikasi ditandai sudah dibaca'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: _viewModel,
        builder: (context, child) {
          if (_viewModel.isLoading && _viewModel.notifications.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (_viewModel.errorMessage != null && _viewModel.notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 80,
                    color: Colors.red[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _viewModel.errorMessage!,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _viewModel.refresh(),
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          if (_viewModel.notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_none,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Belum Ada Notifikasi',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Notifikasi akan muncul di sini',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => _viewModel.refresh(),
            color: AppColors.primary,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _viewModel.notifications.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                color: Colors.grey[200],
              ),
              itemBuilder: (context, index) {
                final notification = _viewModel.notifications[index];
                return _buildNotificationItem(notification);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildNotificationItem(NotificationItem notification) {
    final timeString = _getTimeString(notification.timestamp);

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        _viewModel.deleteNotification(notification.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Notifikasi dihapus'),
            duration: Duration(seconds: 2),
          ),
        );
      },
      child: InkWell(
        onTap: () => _handleNotificationTap(notification),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: notification.isRead ? Colors.white : AppColors.primaryLight.withOpacity(0.3),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _viewModel.getColorForType(notification.type).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _viewModel.getIconForType(notification.type),
                  color: _viewModel.getColorForType(notification.type),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: notification.isRead
                                  ? FontWeight.w500
                                  : FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        if (!notification.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.secondary,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.message,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      timeString,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getTimeString(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} menit yang lalu';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inDays == 1) {
      return 'Kemarin';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hari yang lalu';
    } else {
      return DateFormat('dd MMM yyyy').format(timestamp);
    }
  }
}
