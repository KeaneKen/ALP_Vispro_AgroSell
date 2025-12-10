import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../viewmodel/dikirim_viewmodel.dart';

class DikirimView extends StatefulWidget {
  const DikirimView({super.key});

  @override
  State<DikirimView> createState() => _DikirimViewState();
}

class _DikirimViewState extends State<DikirimView> {
  final DikirimViewModel _viewModel = DikirimViewModel();
  int? _expandedIndex;

  @override
  void initState() {
    super.initState();
    _viewModel.addListener(_onViewModelChange);
  }

  void _onViewModelChange() {
    setState(() {});
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Pengiriman'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textLight,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Filter Chips
          // Container(
          //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          //   color: AppColors.surface,
          //   child: SizedBox(
          //     height: 40,
          //     child: ListView.builder(
          //       scrollDirection: Axis.horizontal,
          //       itemCount: _viewModel.statusFilters.length,
          //       itemBuilder: (context, index) {
          //         final status = _viewModel.statusFilters[index];
          //         final isSelected = _viewModel.selectedStatus == status;
                  
          //         return Container(
          //           margin: const EdgeInsets.only(right: 8),
          //           child: ChoiceChip(
          //             label: Text(
          //               status,
          //               style: TextStyle(
          //                 color: isSelected ? AppColors.textLight : AppColors.textPrimary,
          //                 fontSize: 13,
          //                 fontWeight: FontWeight.w500,
          //               ),
          //             ),
          //             selected: isSelected,
          //             onSelected: (_) => _viewModel.updateStatusFilter(status),
          //             selectedColor: _viewModel.getDeliveryStatusColor(status),
          //             backgroundColor: AppColors.background,
          //             side: BorderSide(
          //               color: isSelected 
          //                   ? _viewModel.getDeliveryStatusColor(status)
          //                   : AppColors.border,
          //               width: 1,
          //             ),
          //             shape: RoundedRectangleBorder(
          //               borderRadius: BorderRadius.circular(20),
          //             ),
          //           ),
          //         );
          //       },
          //     ),
          //   ),
          // ),
          
          // Statistics Cards
          // Container(
          //   padding: const EdgeInsets.all(16),
          //   color: AppColors.background,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceAround,
          //     children: [
          //       _buildStatCard(
          //         icon: Icons.local_shipping,
          //         title: 'Total Dikirim',
          //         value: '${_viewModel.totalDelivered}',
          //         subtitle: '/${_viewModel.totalOrders}',
          //         color: AppColors.primary,
          //       ),
          //       _buildStatCard(
          //         icon: Icons.timer,
          //         title: 'Dalam Perjalanan',
          //         value: '${_viewModel.totalInProgress}',
          //         color: AppColors.secondary,
          //       ),
          //       _buildStatCard(
          //         icon: Icons.attach_money,
          //         title: 'Total',
          //         value: 'Rp ${_viewModel.totalRevenue.toStringAsFixed(0)}',
          //         color: AppColors.success,
          //       ),
          //     ],
          //   ),
          // ),
          
          // Delivery Orders List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _viewModel.filteredOrders.length,
              itemBuilder: (context, index) {
                final order = _viewModel.filteredOrders[index];
                final isExpanded = _expandedIndex == index;
                
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 2,
                  color: AppColors.surface,
                  child: ExpansionTile(
                    initiallyExpanded: isExpanded,
                    onExpansionChanged: (expanded) {
                      setState(() {
                        _expandedIndex = expanded ? index : null;
                      });
                    },
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: _viewModel.getDeliveryStatusColor(order.deliveryStatus).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _viewModel.getDeliveryStatusColor(order.deliveryStatus),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        _viewModel.getDeliveryStatusIcon(order.deliveryStatus),
                        color: _viewModel.getDeliveryStatusColor(order.deliveryStatus),
                      ),
                    ),
                    title: Text(
                      order.buyerName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.inventory,
                              size: 14,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              order.orderNumber,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 14,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                order.deliveryAddress,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _viewModel.getDeliveryStatusColor(order.deliveryStatus),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        order.deliveryStatus,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Order Information
                            Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Informasi Pesanan',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  _buildInfoRow('Nomor Pesanan:', order.orderNumber),
                                  _buildInfoRow('Tanggal Kirim:', order.deliveryDate),
                                  _buildInfoRow('Estimasi Sampai:', order.estimatedArrival),
                                ],
                              ),
                            ),
                            
                            // Product Details
                            Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        order.productName,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: AppColors.primaryLight.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(4),
                                          border: Border.all(color: AppColors.primaryLight),
                                        ),
                                        child: Text(
                                          '${order.quantity} ${order.unit}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            
                            // Address Details
                            Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        size: 18,
                                        color: AppColors.primary,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Alamat Pengiriman',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    order.deliveryAddress,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: AppColors.textSecondary,
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            // Status Information
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: _viewModel.getPaymentStatusColor(order.paymentStatus).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: _viewModel.getPaymentStatusColor(order.paymentStatus),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Status Bayar',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          order.paymentStatus,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: _viewModel.getPaymentStatusColor(order.paymentStatus),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: _viewModel.getDeliveryStatusColor(order.deliveryStatus).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: _viewModel.getDeliveryStatusColor(order.deliveryStatus),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Status Kirim',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          order.deliveryStatus,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: _viewModel.getDeliveryStatusColor(order.deliveryStatus),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            
                            // Total Price
                            Container(
                              margin: const EdgeInsets.only(bottom: 16, top: 12),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.primaryLight),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total Harga',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  Text(
                                    'Rp ${order.totalPrice.toStringAsFixed(0)}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryDark,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            // Action Buttons
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () {
                                      _viewModel.showContactInfo(context, order);
                                    },
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: AppColors.primary,
                                      side: BorderSide(color: AppColors.primary),
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                    ),
                                    icon: const Icon(Icons.phone, size: 18),
                                    label: const Text('Hubungi'),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      _handleUpdateStatus(order);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                    ),
                                    icon: const Icon(Icons.update, size: 18),
                                    label: const Text('Update Status'),
                                  ),
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 8),
                            
                            if (order.deliveryStatus == 'SEDANG DIKIRIM')
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    _handleMarkAsDelivered(order);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.success,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                  ),
                                  icon: const Icon(Icons.check_circle, size: 18),
                                  label: const Text('Tandai Sudah Sampai'),
                                ),
                              ),
                            
                            if (order.deliveryStatus == 'TERKENDALA')
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    _handleResolveIssue(order);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.warning,
                                    foregroundColor: AppColors.textPrimary,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                  ),
                                  icon: const Icon(Icons.build, size: 18),
                                  label: const Text('Selesaikan Kendala'),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildStatCard({
  //   required IconData icon,
  //   required String title,
  //   required String value,
  //   Color color = AppColors.primary,
  //   String? subtitle,
  // }) {
  //   return Container(
  //     padding: const EdgeInsets.all(12),
  //     decoration: BoxDecoration(
  //       color: AppColors.surface,
  //       borderRadius: BorderRadius.circular(8),
  //       border: Border.all(color: AppColors.border),
  //     ),
  //     child: Column(
  //       children: [
  //         Icon(icon, color: color, size: 24),
  //         const SizedBox(height: 8),
  //         Row(
  //           mainAxisSize: MainAxisSize.min,
  //           crossAxisAlignment: CrossAxisAlignment.baseline,
  //           textBaseline: TextBaseline.alphabetic,
  //           children: [
  //             Text(
  //               value,
  //               style: TextStyle(
  //                 fontSize: 18,
  //                 fontWeight: FontWeight.bold,
  //                 color: color,
  //               ),
  //             ),
  //             if (subtitle != null)
  //               Text(
  //                 subtitle,
  //                 style: const TextStyle(
  //                   fontSize: 12,
  //                   color: AppColors.textSecondary,
  //                 ),
  //               ),
  //           ],
  //         ),
  //         const SizedBox(height: 4),
  //         Text(
  //           title,
  //           style: const TextStyle(
  //             fontSize: 11,
  //             color: AppColors.textSecondary,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
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

  void _handleUpdateStatus(DeliveryOrder order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Status Pengiriman'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildStatusOption('SEDANG DIKIRIM', 'Kirim sekarang', Icons.local_shipping),
            _buildStatusOption('SUDAH SAMPAI', 'Pesanan diterima', Icons.check_circle),
            _buildStatusOption('TERKENDALA', 'Ada masalah', Icons.warning),
            _buildStatusOption('MENUNGGU PENGIRIMAN', 'Jadwalkan ulang', Icons.access_time),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusOption(String status, String description, IconData icon) {
    return ListTile(
      leading: Icon(
        icon,
        color: _viewModel.getDeliveryStatusColor(status),
      ),
      title: Text(
        status,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        description,
        style: const TextStyle(
          fontSize: 12,
          color: AppColors.textSecondary,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        _viewModel.updateDeliveryStatus(status, status);
        _showSnackbar(
          'Status ${status.toLowerCase()} diperbarui',
          _viewModel.getDeliveryStatusColor(status),
        );
      },
    );
  }

  void _handleMarkAsDelivered(DeliveryOrder order) {
    _viewModel.updateDeliveryStatus(order.id, 'SUDAH SAMPAI');
    _showSnackbar(
      'Pesanan ${order.buyerName} ditandai sudah sampai',
      AppColors.success,
    );
  }

  void _handleResolveIssue(DeliveryOrder order) {
    _viewModel.updateDeliveryStatus(order.id, 'SEDANG DIKIRIM');
    _showSnackbar(
      'Kendala ${order.buyerName} diselesaikan',
      AppColors.primary,
    );
  }

  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}