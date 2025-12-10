import 'package:agrosell/mitra/po/view/detail_po_view.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../viewmodel/mitra_profile_viewmodel.dart';
import '../../payment/view/payment_view.dart';
import '../../process/view/process_status_view.dart';
import '../../po/view/detail_po_view.dart'; // Pastikan import ini ada
import '../../po/view/form_po_view.dart'; // Import FormPO widget jika belum
import '../../delivery/view/delivery_status_view.dart'; // Import DeliveryStatusView

// Label status pembayaran dinamis sesuai kategori
String _getPaymentLabel(String? category) {
  final name = (category ?? '').toLowerCase();
  if (name.contains('jagung') || name.contains('corn')) {
    return 'Status Pembayaran Jagung';
  }
  if (name.contains('cabai') ||
      name.contains('chili') ||
      name.contains('cabe')) {
    return 'Status Pembayaran Cabai';
  }
  if (name.contains('padi') || name.contains('rice')) {
    return 'Status Pembayaran Padi';
  }
  return 'Status Pembayaran';
}

class MitraProfileView extends StatefulWidget {
  const MitraProfileView({super.key});

  @override
  State<MitraProfileView> createState() => _MitraProfileViewState();
}

class _MitraProfileViewState extends State<MitraProfileView> {
  final MitraProfileViewModel _viewModel = MitraProfileViewModel();

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

  Widget _buildHeaderTitle() {
    return Container(
      padding: const EdgeInsets.only(left: 20, top: 40, bottom: 5),
      alignment: Alignment.bottomLeft,
      child: Text(
        'Profile',
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

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
          // Gambar/Avatar
          Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage('assets/images/dummy_avatar.png'),
                fit: BoxFit.cover,
              ),
              color: AppColors.primaryLight,
            ),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _viewModel.mitraName,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                _viewModel.mitraType,
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
            ],
          ),
          const Spacer(),
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
                    currentStatus: order.currentStatus,
                    categoryName: order.name,
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
                image: const DecorationImage(
                  image: AssetImage('assets/images/dummy_product_icon.png'),
                  fit: BoxFit.cover,
                ),
                border: Border.all(color: AppColors.border),
              ),
              child: const Icon(
                Icons.eco,
                color: AppColors.textLight,
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
  final OrderStatus currentStatus;
  final String? categoryName;
  const _DeliveryStatusTimeline({
    required this.currentStatus,
    this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    final Color activeColor = AppColors.primary;
    final Color inactiveColor = AppColors.divider;

    // Status checks
    final bool isPaymentDone =
        currentStatus.index > OrderStatus.paymentStatus.index;
    final bool isInProcessActive =
        currentStatus.index >= OrderStatus.inProcess.index;
    final bool isShippedActive =
        currentStatus.index >= OrderStatus.shipped.index;
    final bool isPaymentActive =
        currentStatus.index >= OrderStatus.paymentStatus.index;
    final bool isDelivered = currentStatus.index > OrderStatus.shipped.index;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Sudah Bayar / Status Pembayaran
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PaymentView(categoryName: categoryName),
              ),
            );
          },
          child: _StatusStep(
            label: isPaymentDone
                ? 'Sudah Bayar'
                : _getPaymentLabel(categoryName),
            iconWidget: isPaymentDone
                ? Icon(Icons.check_circle, size: 20, color: activeColor)
                : Icon(
                    Icons.payments_outlined,
                    size: 20,
                    color: isPaymentActive ? activeColor : inactiveColor,
                  ),
            isActive: isPaymentActive,
            activeColor: activeColor,
            inactiveColor: inactiveColor,
          ),
        ),
        // Garis 1 -> 2
        Expanded(
          child: Align(
            alignment: Alignment.center,
            child: Container(
              height: 2,
              margin: const EdgeInsets.only(top: 18),
              color: isInProcessActive ? activeColor : inactiveColor,
            ),
          ),
        ),
        // 2. Sedang Diproses
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProcessStatusView(categoryName: categoryName),
              ),
            );
          },
          child: _StatusStep(
            label: 'Sedang Diproses',
            iconWidget: currentStatus == OrderStatus.inProcess
                ? Icon(Icons.all_inbox_outlined, size: 20, color: activeColor)
                : (currentStatus.index > OrderStatus.inProcess.index
                      ? Icon(Icons.check_circle, size: 20, color: activeColor)
                      : Icon(
                          Icons.all_inbox_outlined,
                          size: 20,
                          color: inactiveColor,
                        )),
            isActive: isInProcessActive,
            activeColor: activeColor,
            inactiveColor: inactiveColor,
          ),
        ),
        // Garis 2 -> 3
        Expanded(
          child: Align(
            alignment: Alignment.center,
            child: Container(
              height: 2,
              margin: const EdgeInsets.only(top: 18),
              color: isShippedActive ? activeColor : inactiveColor,
            ),
          ),
        ),
        // 3. Dikirim / Sedang Dikirim
        GestureDetector(
          onTap: () {
            // Navigasi ke halaman DeliveryStatusView ketika diklik
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DeliveryStatusView(categoryName: categoryName),
              ),
            );
          },
          child: _StatusStep(
            label: isDelivered
                ? 'Tiba'
                : (currentStatus == OrderStatus.shipped
                      ? 'Sedang Dikirim'
                      : 'Dikirim'),
            iconWidget: isDelivered
                ? Icon(Icons.check_circle, size: 20, color: activeColor)
                : (currentStatus == OrderStatus.shipped
                      ? Icon(
                          Icons.local_shipping_outlined,
                          size: 20,
                          color: activeColor,
                        )
                      : Icon(
                          Icons.local_shipping_outlined,
                          size: 20,
                          color: isShippedActive ? activeColor : inactiveColor,
                        )),
            isActive: isShippedActive,
            activeColor: activeColor,
            inactiveColor: inactiveColor,
          ),
        ),
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