import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class PerluDikirimView extends StatelessWidget {
  const PerluDikirimView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perlu Dikirim'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textLight,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(
        child: Text('Halaman Perlu Dikirim'),
      ),
    );
  }
}