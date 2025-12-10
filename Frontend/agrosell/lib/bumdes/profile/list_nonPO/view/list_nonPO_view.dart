// features/profile/beli_sekarang/view/beli_sekarang_view.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class BeliSekarangView extends StatelessWidget {
  const BeliSekarangView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beli Sekarang'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textLight,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(
        child: Text('Halaman Beli Sekarang'),
      ),
    );
  }
}