import 'package:agrosell/bumdes/profile/list_nonPO/view/list_nonPO_view.dart';
import 'package:flutter/material.dart';
import '../viewmodel/bumdes_profile_viewmodel.dart';
import '../../../core/theme/app_colors.dart';
import '../list_po/view/list_po_view.dart';
import '../dikirim/view/dikirim_view.dart';
import '../grafik/view/grafik_view.dart';
import '../pendataan/view/pendataan_view.dart';


class BumdesProfileView extends StatefulWidget {
  const BumdesProfileView({super.key});

  @override
  State<BumdesProfileView> createState() => _BumdesProfileViewState();
}

class _BumdesProfileViewState extends State<BumdesProfileView> {
  final BumdesProfileViewModel _viewModel = BumdesProfileViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.addListener(_onViewModelChange);
    _viewModel.loadProfileData();
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
      backgroundColor: AppColors.background,
      body: _viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).padding.top + 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Profile',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    )
                    
                  ],
                ),
              ),

                // Profile Info
                SliverToBoxAdapter(
                  child: _buildProfileHeader(),
                ),
                
                // Stats Cards
                SliverToBoxAdapter(
                  child: _buildStatsCards(),
                ),
                
                // Grafik Section
                SliverToBoxAdapter(
                  child: _buildGrafikSection(),
                ),
                
                // Pendataan Section
                SliverToBoxAdapter(
                  child: _buildPendataanSection(),
                ),
                
                // Spacer
                const SliverToBoxAdapter(
                  child: SizedBox(height: 100),
                ),
              ],
            ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Profile Image/Avatar
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(35),
            ),
            child: const Icon(
              Icons.business,
              size: 40,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bumdes',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Bumdes',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'Status: Aktif',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              
            },
            icon: Icon(
              Icons.edit,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              count: _viewModel.preOrderCount,
              label: 'Pre-Order',
              icon: Icons.list_alt,
              color: AppColors.primary,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ListPoView()),
              ),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: _buildStatCard(
              count: _viewModel.buyNowCount,
              label: 'Beli Sekarang',
              icon: Icons.shopping_cart,
              color: AppColors.primary,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BeliSekarangView()),
              ),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: _buildStatCard(
              count: _viewModel.pendingDeliveryCount,
              label: 'Perlu Dikirim',
              icon: Icons.local_shipping,
              color: AppColors.primary,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PerluDikirimView()),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required int count,
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 8),
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGrafikSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Grafik Harga Komoditas',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => const GrafikView()),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Detail',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(width: 4),

                      Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ),
              ),
            ],

          ),
          const SizedBox(height: 16),
          
          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLegendItem('Jagung', AppColors.primary),
              _buildLegendItem('Padi', AppColors.secondary),
              _buildLegendItem('Cabai', AppColors.error),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Mini Chart
          Container(
            height: 200,
            padding: const EdgeInsets.all(8),
            child: CustomPaint(
              size: const Size(double.infinity, 200),
              painter: _MiniGrafikPainter(
                jagungData: _viewModel.jagungData,
                padiData: _viewModel.padiData,
                cabaiData: _viewModel.cabaiData,
              ),
            ),
          ),
          
          // Month Labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _viewModel.months.map((month) {
              return Text(
                month,
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildPendataanSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pendataan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => const PendataanView()),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Selengkapnya',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Quick Stats
          Row(
            children: [
              Expanded(
                child: _buildDataItem(
                  icon: Icons.inventory,
                  label: 'Stok Tersedia',
                  value: '${_viewModel.totalStock} kg',
                  color: AppColors.success,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDataItem(
                  icon: Icons.attach_money,
                  label: 'Pendapatan Bulan Ini',
                  value: 'Rp ${_viewModel.monthlyIncome}',
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDataItem(
                  icon: Icons.trending_up,
                  label: 'Pertumbuhan',
                  value: '+${_viewModel.growthPercentage}%',
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Recent Activity
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Aktivitas Terakhir',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              ..._viewModel.recentActivities.map((activity) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: _getActivityColor(activity['type']).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Icon(
                          _getActivityIcon(activity['type']),
                          size: 18,
                          color: _getActivityColor(activity['type']),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              activity['title'],
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              activity['time'],
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        activity['value'],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: _getActivityColor(activity['type']),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDataItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getActivityColor(String type) {
    switch (type) {
      case 'penjualan':
        return AppColors.success;
      case 'pembelian':
        return AppColors.primary;
      case 'panen':
        return AppColors.secondary;
      default:
        return AppColors.textSecondary;
    }
  }

  IconData _getActivityIcon(String type) {
    switch (type) {
      case 'penjualan':
        return Icons.sell;
      case 'pembelian':
        return Icons.shopping_cart;
      case 'panen':
        return Icons.agriculture;
      default:
        return Icons.notifications;
    }
  }
}

class _MiniGrafikPainter extends CustomPainter {
  final List<double> jagungData;
  final List<double> padiData;
  final List<double> cabaiData;

  _MiniGrafikPainter({
    required this.jagungData,
    required this.padiData,
    required this.cabaiData,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (jagungData.isEmpty) return;

    final maxValue = [
      ...jagungData,
      ...padiData,
      ...cabaiData,
    ].reduce((a, b) => a > b ? a : b);

    final yScale = size.height * 0.7 / maxValue;
    final xStep = size.width / (jagungData.length - 1);

    // Draw grid lines
    final gridPaint = Paint()
      ..color = AppColors.border
      ..strokeWidth = 0.5;

    for (int i = 0; i <= 5; i++) {
      final y = size.height - (i * size.height / 5);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Draw lines for each commodity
    _drawLine(canvas, jagungData, AppColors.primary, xStep, yScale, size);
    _drawLine(canvas, padiData, AppColors.secondary, xStep, yScale, size);
    _drawLine(canvas, cabaiData, AppColors.error, xStep, yScale, size);
  }

  void _drawLine(Canvas canvas, List<double> data, Color color, double xStep, double yScale, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    
    for (int i = 0; i < data.length; i++) {
      final x = i * xStep;
      final y = size.height - (data[i] * yScale) - 10;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}