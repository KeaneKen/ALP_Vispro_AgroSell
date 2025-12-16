import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import '../theme/app_colors.dart';

class AppNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AppNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      index: currentIndex,
      height: 70.0,
      items: <Widget>[
        // Home
        Icon(
          Icons.home_rounded,
          size: 30,
          color: currentIndex == 0 ? AppColors.surface : AppColors.accent,
        ),
        // Catalog
        Icon(
          Icons.grid_view_rounded,
          size: 30,
          color: currentIndex == 1 ? AppColors.surface : AppColors.accent,
        ),
        // Notifications
        Icon(
          Icons.notifications_rounded,
          size: 30,
          color: currentIndex == 2 ? AppColors.surface : AppColors.accent,
        ),
        // Profile
        Icon(
          Icons.person_rounded,
          size: 30,
          color: currentIndex == 3 ? AppColors.surface : AppColors.accent,
        ),
      ],
      color: AppColors.primaryLight, // ACC270 - light green navbar
      buttonBackgroundColor: AppColors.secondary, // EA9B03 - orange background saat aktif
      backgroundColor: Colors.transparent,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      onTap: onTap,
    );
  }
}
