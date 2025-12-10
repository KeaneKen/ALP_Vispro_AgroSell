import 'package:flutter/material.dart';
import '../viewmodel/pendataan_viewmodel.dart';
import '../../../../core/theme/app_colors.dart';

class PendataanView extends StatefulWidget {
  const PendataanView({super.key});

  @override
  State<PendataanView> createState() => _PendataanViewState();
}

class _PendataanViewState extends State<PendataanView> {
  final PendataanViewModel _viewModel = PendataanViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.addListener(_onViewModelChange);
    _viewModel.loadData();
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
        title: const Text('Pendataan'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textLight,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sistem Pendataan Pertanian',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Kelola semua data pertanian Anda dalam satu tempat.',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Features Grid
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      _buildFeatureCard(
                        icon: Icons.inventory,
                        title: 'Stok & Inventaris',
                        color: AppColors.primary,
                      ),
                      _buildFeatureCard(
                        icon: Icons.attach_money,
                        title: 'Keuangan',
                        color: AppColors.success,
                      ),
                      _buildFeatureCard(
                        icon: Icons.agriculture,
                        title: 'Produksi',
                        color: AppColors.secondary,
                      ),
                      _buildFeatureCard(
                        icon: Icons.shopping_cart,
                        title: 'Penjualan',
                        color: AppColors.warning,
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      color: AppColors.surface,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Icon(
                icon,
                size: 32,
                color: color,
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}