import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../viewmodel/list_nonPO_viewmodel.dart';

class ListNonPOView extends StatefulWidget {
  const ListNonPOView({super.key});

  @override
  State<ListNonPOView> createState() => _ListNonPOViewState();
}

class _ListNonPOViewState extends State<ListNonPOView> {
  final ListNonPOViewModel _viewModel = ListNonPOViewModel();
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
        title: const Text('Daftar Beli Sekarang'),
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
          //             selectedColor: AppColors.primary,
          //             backgroundColor: AppColors.background,
          //             side: BorderSide(
          //               color: isSelected ? AppColors.primary : AppColors.border,
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
          
          // Stats Info
          // Container(
          //   padding: const EdgeInsets.all(16),
          //   color: AppColors.background,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceAround,
          //     children: [
          //       _buildStatCard(
          //         icon: Icons.shopping_cart,
          //         title: 'Total Pesanan',
          //         value: '${_viewModel.totalOrders}',
          //         color: AppColors.primary,
          //       ),
          //       _buildStatCard(
          //         icon: Icons.attach_money,
          //         title: 'Total Pendapatan',
          //         value: 'Rp ${_viewModel.totalRevenue.toStringAsFixed(0)}',
          //         color: AppColors.secondary,
          //       ),
          //     ],
          //   ),
          // ),
          
          // Orders List
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
                        color: _getStatusColor(order.paymentStatus).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _getStatusColor(order.paymentStatus),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        Icons.shopping_bag_rounded,
                        color: AppColors.primary,
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
                        color: _getStatusColor(order.paymentStatus),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        order.paymentStatus,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
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
                            // Delivery Address Details
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
                            
                            // Product Details
                            if (order.items.isNotEmpty)
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
                                    ...order.items.map((it) => Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 6),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  it.productName,
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600,
                                                    color: AppColors.textPrimary,
                                                  ),
                                                ),
                                              ),
                                              if (it.pricePerKg > 0)
                                                Text(
                                                  '${it.quantity} kg',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: AppColors.textSecondary,
                                                  ),
                                                ),
                                              const SizedBox(width: 8),
                                              Text(
                                                'Rp ${it.subtotal.toStringAsFixed(0)}',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.primaryDark,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                            
                            // Total Price
                            Container(
                              margin: const EdgeInsets.only(bottom: 16),
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
                                    'Rp ${order.total.toStringAsFixed(0)}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryDark,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Payment Status
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: _getPaymentColor(order.paymentStatus),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Status Bayar',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    order.paymentStatus,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: 16),
                            
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
                                      _handleProcessOrder(order);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                    ),
                                    // icon: const Icon(Icons.play_arrow, size: 18),
                                    label: const Text('Proses Sekarang'),
                                  ),
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 8),
                            
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  _handleDeliverOrder(order);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                                icon: const Icon(Icons.local_shipping, size: 18),
                                label: const Text('Sudah Siap Antar? Antar Sekarang'),
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
  //   required Color color,
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
  //         Text(
  //           value,
  //           style: TextStyle(
  //             fontSize: 18,
  //             fontWeight: FontWeight.bold,
  //             color: color,
  //           ),
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

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'LUNAS':
        return AppColors.success;
      case 'BELUM LUNAS':
        return AppColors.warning;
      case 'PROSES':
        return AppColors.primary;
      case 'ANTAR':
        return AppColors.secondary;
      default:
        return AppColors.disabled;
    }
  }

  Color _getPaymentColor(String status) {
    return status == 'Lunas' ? AppColors.success : AppColors.warning;
  }

  void _handleProcessOrder(Order order) {
    _viewModel.updateOrderStatus(order.id, 'PROSES');
    _showSnackbar(
      'Pesanan ${order.buyerName} diproses',
      AppColors.primary,
    );
  }

  void _handleDeliverOrder(Order order) {
    _viewModel.updateOrderStatus(order.id, 'ANTAR');
    _showSnackbar(
      'Pesanan ${order.buyerName} sedang diantar',
      AppColors.secondary,
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