import 'package:flutter/material.dart';
import '../viewmodel/product_detail_viewmodel.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/bumdes_repository.dart';
import '../../cart/cart_route.dart';
import '../../chat/chat_route.dart';

class ProductDetailView extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailView({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  final ProductDetailViewModel _viewModel = ProductDetailViewModel();
  final AuthService _authService = AuthService();
  final BumdesRepository _bumdesRepository = BumdesRepository();
  String _userType = 'mitra'; // Default to mitra
  bool _isUserTypeResolved = false;

  @override
  void initState() {
    super.initState();
    debugPrint('🔍 ProductDetailView received product: ${widget.product}');
    debugPrint('🔍 Product keys: ${widget.product.keys.toList()}');
    debugPrint('🔍 Product name: ${widget.product['name']}');
    debugPrint('🔍 Product category: ${widget.product['category']}');
    debugPrint('🔍 Product price: ${widget.product['price']}');
    debugPrint('🔍 Product image: ${widget.product['image']}');
    _viewModel.setProduct(widget.product);
    
    // Get user type to hide cart for BumDes
    _getUserType();
  }

  Future<void> _getUserType() async {
    final userType = await _authService.getUserType();
    setState(() {
      _userType = userType ?? 'mitra';
      _isUserTypeResolved = true;
    });
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: AnimatedBuilder(
        animation: _viewModel,
        builder: (context, child) {
          if (_viewModel.product == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return Stack(
            children: [
              CustomScrollView(
                slivers: [
                  // App Bar with Image
                  SliverAppBar(
                    expandedHeight: 300,
                    pinned: false,
                    backgroundColor: AppColors.primary,
                    automaticallyImplyLeading: false,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Hero(
                        tag: 'product_${_viewModel.product!['name'] ?? 'unknown'}',
                        child: Image.asset(
                          _viewModel.product!['image'] ?? 'assets/images/jagung_manis.png',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: AppColors.primaryLight,
                              child: const Center(
                                child: Icon(Icons.grass, size: 80, color: AppColors.primary),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),

              // Product Details Content
              SliverToBoxAdapter(
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Info Section
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Category Badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryLight,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                _viewModel.product!['category'] ?? 'Lainnya',
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Product Name
                            Text(
                              _viewModel.product!['name'] ?? 'Produk',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),

                            const SizedBox(height: 8),

                            // Price
                            Text(
                              _viewModel.product!['price'] ?? 'Rp 0',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.secondary,
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Description
                            const Text(
                              'Deskripsi Produk',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              _getProductDescription(),
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Divider(color: AppColors.divider, thickness: 8),

                      // Quantity Selector Section - hidden for BumDes or until user type resolved
                      if (_isUserTypeResolved && _userType != 'bumdes')
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Jumlah Pembelian (kg)',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                // Decrement Button
                                IconButton(
                                  onPressed: _viewModel.decrementQuantity,
                                  icon: const Icon(Icons.remove_circle_outline),
                                  color: AppColors.primary,
                                  iconSize: 32,
                                ),

                                // Quantity Display
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: AppColors.border,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '${_viewModel.quantity}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),

                                // Increment Button
                                IconButton(
                                  onPressed: _viewModel.incrementQuantity,
                                  icon: const Icon(Icons.add_circle_outline),
                                  color: AppColors.primary,
                                  iconSize: 32,
                                ),

                                const Spacer(),

                                // Total Price
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Text(
                                      'Total Harga',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    Text(
                                      _viewModel.getTotalPrice(),
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.secondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
                ],
              ),

              // Fixed Back and Cart Buttons
              Positioned(
                top: 40,
                left: 16,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: AppColors.primary),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
              // Cart button - only show for Mitra users, hide for BumDes, and wait until user type resolved
              if (_isUserTypeResolved && _userType != 'bumdes')
                Positioned(
                  top: 40,
                  right: 16,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.shopping_cart_outlined, color: AppColors.primary),
                      onPressed: () => CartRoute.navigate(context),
                    ),
                  ),
                ),
            ],
          );
        },
      ),

      // Bottom Action Bar
      bottomNavigationBar: AnimatedBuilder(
        animation: _viewModel,
        builder: (context, child) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  // Chat Button
                  OutlinedButton.icon(
                    onPressed: () async {
                      final userId = await _authService.getUserId();
                      final userType = await _authService.getUserType();
                      
                      // Get product's bumdes ID (assuming it's stored in product data)
                      final bumdesId = _viewModel.product!['idBumdes'] ?? 'B001';
                      
                      // Fetch actual BumDes name from database
                      String bumdesName = 'BUMDes';
                      try {
                        final bumdes = await _bumdesRepository.getBumdesById(bumdesId);
                        bumdesName = bumdes.namaBumdes;
                      } catch (e) {
                        debugPrint('Failed to fetch BumDes name: $e');
                        bumdesName = 'BUMDes';
                      }
                      
                      // Use logged-in user if available, otherwise default to mitra testing mode
                      ChatRoute.navigate(
                        context,
                        contactName: bumdesName,
                        mitraId: userType == 'mitra' ? (userId ?? 'M001') : 'M001',
                        bumdesId: userType == 'bumdes' ? (userId ?? 'B001') : bumdesId,
                        currentUserType: userType ?? 'mitra',
                      );
                    },
                    icon: const Icon(Icons.chat_bubble_outline),
                    label: const Text('Chat'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),

                  // Add to Cart / Pre-Order Button - Only show for Mitra users and after user type resolved
                  if (_isUserTypeResolved && _userType != 'bumdes') ...[
                    const SizedBox(width: 12),
                    Expanded(
                      child: _viewModel.product!['isPreOrder'] == 'true'
                          ? ElevatedButton.icon(
                              onPressed: _viewModel.isLoading
                                  ? null
                                  : () async {
                                      await _viewModel.addToCart();
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Pre-order berhasil ditambahkan ke keranjang'),
                                            backgroundColor: AppColors.success,
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                      }
                                    },
                              icon: _viewModel.isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white,
                                        ),
                                      ),
                                    )
                                  : const Icon(Icons.event_available),
                              label: Text(
                                _viewModel.isLoading
                                    ? 'Memproses...'
                                    : 'Pre-Order Sekarang',
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.secondary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            )
                          : ElevatedButton.icon(
                              onPressed: _viewModel.isLoading
                                  ? null
                                  : () async {
                                      await _viewModel.addToCart();
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Produk ditambahkan ke keranjang'),
                                            backgroundColor: AppColors.success,
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                      }
                                    },
                              icon: _viewModel.isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white,
                                        ),
                                      ),
                                    )
                                  : const Icon(Icons.shopping_cart),
                              label: Text(
                                _viewModel.isLoading
                                    ? 'Menambahkan...'
                                    : 'Tambah ke Keranjang',
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.secondary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }


  String _getProductDescription() {
    String category = _viewModel.product!['category'].toString().toLowerCase();
    String name = _viewModel.product!['name'].toString().toLowerCase();

    if (category.contains('padi')) {
      if (name.contains('gabah')) {
        return 'Gabah Kering Giling (GKG) berkualitas tinggi dengan kadar air optimal. Hasil panen terbaik dari petani lokal dengan standar Harga Pembelian Pemerintah (HPP). Cocok untuk penggilingan menjadi beras premium.';
      } else if (name.contains('ir64')) {
        return 'Padi varietas IR64 merupakan varietas unggul yang populer dengan produktivitas tinggi. Butiran padi berkualitas dengan tekstur pulen dan aroma khas. Telah memenuhi standar HPP pemerintah.';
      } else {
        return 'Padi berkualitas premium hasil panen terbaik dari petani lokal. Dipanen pada waktu yang tepat untuk menghasilkan beras dengan kualitas optimal sesuai standar HPP.';
      }
    } else if (category.contains('jagung')) {
      return 'Jagung pipilan kering berkualitas tinggi dengan kadar air rendah. Cocok untuk pakan ternak dan industri pangan. Hasil dari petani lokal dengan standar Harga Pembelian Pemerintah (HPP).';
    } else if (category.contains('cabai')) {
      if (name.contains('keriting')) {
        return 'Cabai merah keriting segar dengan tingkat kepedasan sedang. Warna merah cerah menandakan kesegaran dan kematangan sempurna. Dipanen langsung dari kebun petani lokal dengan standar HPP.';
      } else if (name.contains('rawit')) {
        return 'Cabai rawit hijau dengan tingkat kepedasan tinggi. Segar dan berkualitas premium untuk kebutuhan bumbu masakan. Harga sesuai standar HPP dari pemerintah.';
      } else {
        return 'Cabai berkualitas premium hasil panen petani lokal. Tingkat kepedasan optimal untuk berbagai kebutuhan masakan. Memenuhi standar Harga Pembelian Pemerintah (HPP).';
      }
    }

    return 'Produk pertanian berkualitas tinggi dari petani lokal. Dipanen dengan standar kualitas terbaik dan harga sesuai HPP (Harga Pembelian Pemerintah).';
  }
}
