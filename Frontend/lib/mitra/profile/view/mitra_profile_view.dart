import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../viewmodel/mitra_profile_viewmodel.dart';
import '../../po/view/detail_po_view.dart';
import '../../po/view/form_po_view.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class MitraProfileView extends StatefulWidget {
  const MitraProfileView({super.key});

  @override
  State<MitraProfileView> createState() => _MitraProfileViewState();
}

class _MitraProfileViewState extends State<MitraProfileView> {
  final MitraProfileViewModel _viewModel = MitraProfileViewModel();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _viewModel.addListener(_onViewModelChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.fetchProfileData();
    });
  }

  void _onViewModelChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      // Show dialog to choose between camera and gallery
      final source = await showDialog<ImageSource>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Pilih Sumber Gambar'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Kamera'),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galeri'),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
            ],
          ),
        ),
      );

      if (source != null) {
        final XFile? image = await _picker.pickImage(
          source: source,
          maxWidth: 800,
          maxHeight: 800,
        );

        if (image != null) {
          // Upload the image
          await _viewModel.uploadProfilePicture(File(image.path));
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memilih gambar: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _viewModel.isLoading
          ? Center(child: CircularProgressIndicator(color: AppColors.primary))
          : CustomScrollView(
              slivers: [
                // Tulisan 'Profile' di kiri atas
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      top: 32,
                      bottom: 0,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Profile',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
                // Bagian Profile Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 15,
                    ),
                    child: _buildProfileHeaderCard(),
                  ),
                ),

                // Section: Pesanan Saya
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 10,
                      bottom: 5,
                    ),
                    child: Text(
                      'Pesanan Saya',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 8.0,
                      ),
                      child: _buildOrderItem(_viewModel.orders[index]),
                    );
                  }, childCount: _viewModel.orders.length),
                ),

                // Section: List & Detail Pre-Order
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 15,
                      bottom: 5,
                    ),
                    child: Row(
                      children: [
                        Text(
                          'List & Detail Pre-Order',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(
                            Icons.add_circle,
                            color: AppColors.primary,
                          ),
                          tooltip: 'Tambah Pre-Order',
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                insetPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 24,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    final double width = MediaQuery.of(
                                      context,
                                    ).size.width;
                                    return SizedBox(
                                      width: width > 500 ? 420 : width * 0.95,
                                      child: SingleChildScrollView(
                                        padding: const EdgeInsets.all(16.0),
                                        child: FormPOView(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 8.0,
                      ),
                      child: _buildPreOrderItem(_viewModel.preOrders[index]),
                    );
                  }, childCount: _viewModel.preOrders.length),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 30)),
              ],
            ),
      // Bottom status bar dihilangkan sesuai permintaan
    );
  }

  // --- WIDGET HELPER ---

  // BottomNavigationBar dihapus

  Widget _buildProfileHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        children: [
          // Gambar/Avatar with edit capability
          GestureDetector(
            onTap: _pickImage,
            child: Stack(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: _viewModel.profilePicture != null && _viewModel.profilePicture!.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(_viewModel.profilePicture!),
                            fit: BoxFit.cover,
                          )
                        : const DecorationImage(
                            image: AssetImage('assets/images/dummy_avatar.jpg'),
                            fit: BoxFit.cover,
                          ),
                    color: AppColors.primaryLight,
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      size: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _viewModel.mitraName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  _viewModel.mitraType,
                  style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () async {
              final nameController = TextEditingController(
                text: _viewModel.mitraName,
              );
              String selectedStatus = _viewModel.mitraType;

              // Dialog Edit Nama + Status
              final result = await showDialog<bool>(
                context: context,
                builder: (_) {
                  return AlertDialog(
                    title: const Text("Edit Profil Mitra"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Input Nama
                        TextField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            labelText: "Nama Mitra",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 15),

                        // Dropdown Edit Status
                        DropdownButtonFormField<String>(
                          value: selectedStatus,
                          decoration: const InputDecoration(
                            labelText: "Status Mitra",
                            border: OutlineInputBorder(),
                          ),
                          items: const [
                            DropdownMenuItem(
                                value: "Restoran", child: Text("Restoran")),
                            DropdownMenuItem(
                                value: "Produsen", child: Text("Produsen")),
                            DropdownMenuItem(
                                value: "Lainnya", child: Text("Lainnya")),
                          ],
                          onChanged: (val) {
                            selectedStatus = val!;
                          },
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text("Batal"),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text("Simpan"),
                      ),
                    ],
                  );
                },
              );

              // Jika user klik Simpan
              if (result == true) {
                _viewModel.updateMitraName(nameController.text.trim());
                _viewModel.updateMitraType(selectedStatus);
              }
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.divider),
              ),
              child: Icon(Icons.edit, color: AppColors.primary, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItem(OrderItem order) {
    final bool isPreOrder = order.type == 'Pre-Order';
    final bool isExpanded = _viewModel.isExpanded(order.id);

    return GestureDetector(
      onTap: () => _viewModel.toggleOrderExpand(order.id),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border.withOpacity(0.5)),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Pesanan (Selalu Terlihat)
            Row(
              children: [
                Text(
                  order.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: isPreOrder
                        ? AppColors.secondaryLight
                        : AppColors.primaryLight.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    isPreOrder ? 'Pre-Order' : 'Non Pre-Order',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isPreOrder
                          ? AppColors.accent
                          : AppColors.primaryDark,
                    ),
                  ),
                ),
                const Spacer(),
                // Icon panah yang berputar
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: AppColors.textPrimary,
                ),
              ],
            ),

            // Konten Detail (Hanya Muncul saat isExpanded true)
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 300),
              crossFadeState: isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              firstChild:
                  const SizedBox.shrink(), // Widget kosong saat tertutup
              secondChild: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  Divider(height: 1, color: AppColors.divider),
                  const SizedBox(height: 15),
                  // Timeline Status Pengiriman (tetap tampil di item: Jagung, Cabai, Padi)
                  _DeliveryStatusTimeline(
                    orderId: order.id,
                    currentStatus: order.currentStatus,
                    categoryName: order.name,
                    viewModel: _viewModel,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreOrderItem(PreOrderItem preOrder) {
    return GestureDetector(
      onTap: () {
        // Navigasi ke halaman Detail PO dari item Pre-Order
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailPOView(poId: preOrder.id.toString()),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border.withOpacity(0.5)),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 5,
            ),
          ],
        ),
        child: Row(
          children: [
            // Gambar produk kecil
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryLight,
                border: Border.all(color: AppColors.border),
              ),
              child: const Icon(
                Icons.eco,
                color: AppColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  preOrder.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  preOrder.harvestTime,
                  style: TextStyle(fontSize: 14, color: AppColors.secondary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DeliveryStatusTimeline extends StatelessWidget {
  final String orderId;
  final OrderStatus currentStatus;
  final String? categoryName;
  final MitraProfileViewModel viewModel;
  
  const _DeliveryStatusTimeline({
    required this.orderId,
    required this.currentStatus,
    required this.viewModel,
    this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    final Color activeColor = AppColors.primary;
    final Color inactiveColor = AppColors.divider;

    // Status checks - updated for new statuses
    final bool isProcessingActive = currentStatus.index >= OrderStatus.processing.index;
    final bool isGivenToCourierActive = currentStatus.index >= OrderStatus.givenToCourier.index;
    final bool isOnTheWayActive = currentStatus.index >= OrderStatus.onTheWay.index;
    final bool isArrivedActive = currentStatus.index >= OrderStatus.arrived.index;
    final bool isCompleted = currentStatus == OrderStatus.completed;

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Sedang Diproses (Processing)
            _StatusStep(
              label: 'Sedang\\nDiproses',
              iconWidget: currentStatus == OrderStatus.processing
                  ? Icon(Icons.hourglass_empty, size: 20, color: activeColor)
                  : (currentStatus.index > OrderStatus.processing.index
                        ? Icon(Icons.check_circle, size: 20, color: activeColor)
                        : Icon(Icons.hourglass_empty, size: 20, color: inactiveColor)),
              isActive: isProcessingActive,
              activeColor: activeColor,
              inactiveColor: inactiveColor,
            ),
            // Line 1 -> 2
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  height: 2,
                  margin: const EdgeInsets.only(top: 18),
                  color: isGivenToCourierActive ? activeColor : inactiveColor,
                ),
              ),
            ),
            // 2. Diserahkan ke Kurir (Given to Courier)
            _StatusStep(
              label: 'Diserahkan\\nke Kurir',
              iconWidget: currentStatus == OrderStatus.givenToCourier
                  ? Icon(Icons.local_shipping, size: 20, color: activeColor)
                  : (currentStatus.index > OrderStatus.givenToCourier.index
                        ? Icon(Icons.check_circle, size: 20, color: activeColor)
                        : Icon(Icons.local_shipping, size: 20, color: inactiveColor)),
              isActive: isGivenToCourierActive,
              activeColor: activeColor,
              inactiveColor: inactiveColor,
            ),
            // Line 2 -> 3
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  height: 2,
                  margin: const EdgeInsets.only(top: 18),
                  color: isOnTheWayActive ? activeColor : inactiveColor,
                ),
              ),
            ),
            // 3. Dalam Perjalanan (On The Way)
            _StatusStep(
              label: 'Dalam\\nPerjalanan',
              iconWidget: currentStatus == OrderStatus.onTheWay
                  ? Icon(Icons.directions_bike, size: 20, color: activeColor)
                  : (currentStatus.index > OrderStatus.onTheWay.index
                        ? Icon(Icons.check_circle, size: 20, color: activeColor)
                        : Icon(Icons.directions_bike, size: 20, color: inactiveColor)),
              isActive: isOnTheWayActive,
              activeColor: activeColor,
              inactiveColor: inactiveColor,
            ),
            // Line 3 -> 4
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  height: 2,
                  margin: const EdgeInsets.only(top: 18),
                  color: isArrivedActive ? activeColor : inactiveColor,
                ),
              ),
            ),
            // 4. Sampai Tujuan (Arrived)
            _StatusStep(
              label: 'Sampai\\nTujuan',
              iconWidget: currentStatus == OrderStatus.arrived || isCompleted
                  ? Icon(Icons.location_on, size: 20, color: activeColor)
                  : Icon(Icons.location_on, size: 20, color: inactiveColor),
              isActive: isArrivedActive,
              activeColor: activeColor,
              inactiveColor: inactiveColor,
            ),
          ],
        ),
        // Pesanan Selesai button - only show when status is 'arrived'
        if (currentStatus == OrderStatus.arrived) ...[
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                // Show confirmation dialog
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Konfirmasi Penerimaan'),
                    content: Text('Apakah Anda yakin produk "$categoryName" sudah diterima dengan baik?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Belum'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                        ),
                        child: const Text('Ya, Sudah Diterima'),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  try {
                    await viewModel.confirmOrderCompletion(orderId);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Pesanan telah dikonfirmasi sebagai selesai'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Gagal konfirmasi: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                }
              },
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('Pesanan Selesai'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
        // Show completed badge
        if (isCompleted) ...[
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle, color: Colors.green.shade700, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Pesanan Selesai',
                  style: TextStyle(
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _StatusStep extends StatelessWidget {
  final String label;
  final Widget iconWidget;
  final bool isActive;
  final Color activeColor;
  final Color inactiveColor;

  const _StatusStep({
    required this.label,
    required this.iconWidget,
    required this.isActive,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    final Color color = isActive ? activeColor : inactiveColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Ikon Status
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border.all(color: color, width: 2),
            borderRadius: BorderRadius.circular(15),
          ),
          child: iconWidget,
        ),
        const SizedBox(height: 5),
        // Teks Status
        Container(
          constraints: const BoxConstraints(maxWidth: 80),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}