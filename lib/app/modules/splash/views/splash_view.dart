import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:tirta_desa/core/values/colors.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryContainer.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(
                    LucideIcons.droplets,
                    color: Colors.white,
                    size: 64,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  "TirtaDesa",
                  style: Get.textTheme.displayLarge?.copyWith(
                    color: AppColors.primaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    "Aliran Air Bersih, Membangun Desa Mandiri",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 40,
              child: Column(
                children: [
                  const Text(
                    "Versi 1.0.4",
                    style: TextStyle(color: AppColors.outline, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
