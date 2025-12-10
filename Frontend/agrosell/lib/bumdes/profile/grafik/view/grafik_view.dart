import 'package:flutter/material.dart';
import '../viewmodel/grafik_viewmodel.dart';
import '../../../../core/theme/app_colors.dart';

class GrafikView extends StatefulWidget {
  const GrafikView({super.key});

  @override
  State<GrafikView> createState() => _GrafikViewState();
}

class _GrafikViewState extends State<GrafikView> {
  final GrafikViewModel _viewModel = GrafikViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.addListener(_onViewModelChange);
    _viewModel.loadGrafikData();
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
        title: const Text('Grafik Detail'),
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
                    'Halaman Grafik Detail',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Fitur grafik detail akan segera hadir dengan berbagai analisis harga komoditas pertanian.',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Placeholder content
                  _buildPlaceholderCard(),
                ],
              ),
            ),
    );
  }

  Widget _buildPlaceholderCard() {
    return Card(
      elevation: 2,
      color: AppColors.surface,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(
              Icons.analytics,
              size: 64,
              color: AppColors.primaryLight,
            ),
            const SizedBox(height: 16),
            Text(
              'Analisis Grafik Harga',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Fitur ini akan menampilkan:',
              style: TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            ..._viewModel.features.map((feature) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: AppColors.success,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      feature,
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}