import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class NextSplashView extends StatelessWidget {
  const NextSplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background image or gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    // AppColors.primaryLight.withOpacity(0.1),
                    AppColors.background,
                    AppColors.background,
                    AppColors.primaryLight.withOpacity(0.3),
                  ],
                ),
              ),
            ),
          ),
          
          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // // App Logo/Icon
                // Container(
                //   width: 120,
                //   height: 120,
                //   decoration: BoxDecoration(
                //     color: AppColors.primary,
                //     borderRadius: BorderRadius.circular(20),
                //   ),
                //   child: const Icon(
                //     Icons.agriculture,
                //     size: 60,
                //     color: Colors.white,
                //   ),
                // ),
                
                // const SizedBox(height: 24),
                
                // App Name
                Text(
                  'AgroSell',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Tagline
                Text(
                  'AgroSell merupakan platform digital\npenjualan hasil panen pertanian',
                  
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          
          // Bottom button
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textLight,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Lanjutkan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}