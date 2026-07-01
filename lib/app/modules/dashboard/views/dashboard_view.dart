import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:tirta_desa/core/values/colors.dart';
import 'package:tirta_desa/app/modules/reports/views/reports_view.dart';
import '../controllers/dashboard_controller.dart';
import 'package:tirta_desa/app/routes/app_pages.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() => IndexedStack(
            index: controller.currentIndex.value,
            children: const [
              HomeTab(),
              ReportsView(),
            ],
          )),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Obx(() => BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changeTabIndex,
          selectedItemColor: AppColors.primaryContainer,
          unselectedItemColor: AppColors.onSurfaceVariant,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(LucideIcons.home), label: "Beranda"),
            BottomNavigationBarItem(icon: Icon(LucideIcons.barChart3), label: "Laporan"),
            BottomNavigationBarItem(icon: Icon(LucideIcons.user), label: "Profil"),
          ],
        ));
  }
}

class HomeTab extends GetView<DashboardController> {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white.withValues(alpha: 0.8),
        elevation: 0,
        title: Row(
          children: [
            const Icon(LucideIcons.droplets, color: AppColors.primaryContainer),
            const SizedBox(width: 8),
            Text(
              "TirtaDesa",
              style: Get.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryContainer,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => Get.toNamed(Routes.NOTIFICATIONS),
            icon: const Icon(LucideIcons.bell),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.fetchDashboardData(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () => Text(
                  "Halo, ${controller.userName.value}!",
                  style: Get.textTheme.headlineLarge?.copyWith(
                    color: AppColors.primaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "Selamat pagi. Pantau penggunaan air bersih desa Anda hari ini.",
                style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 16),
              ),
              const SizedBox(height: 32),
              _buildSummaryCards(),
              const SizedBox(height: 24),
              _buildStatisticsChart(),
              const SizedBox(height: 24),
              _buildServicesMenu(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Obx(
      () => Row(
        children: [
          Expanded(
            child: _buildInfoCard(
              icon: LucideIcons.waves,
              iconBg: AppColors.primaryFixed,
              label: "Penggunaan Air",
              value: controller.penggunaanAir.value,
              subtitle: "3% lebih rendah",
              badge: "Bulan Ini",
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildInfoCard(
              icon: LucideIcons.wallet,
              iconBg: AppColors.secondaryFixed,
              label: "Status Pembayaran",
              value: controller.statusPembayaran.value,
              valueColor: controller.statusPembayaran.value == "Lunas"
                  ? Colors.green
                  : AppColors.error,
              subtitle: controller.statusPembayaran.value == "Lunas" 
                  ? "Sudah Terbayar" 
                  : controller.totalTagihanStr.value,
              badge: "Tagihan",
              badgeBg: controller.statusPembayaran.value == "Lunas"
                  ? Colors.green.shade100
                  : AppColors.errorContainer,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required Color iconBg,
    required String label,
    required String value,
    Color? valueColor,
    String? subtitle,
    required String badge,
    Color? badgeBg,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outline.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
                child: Icon(icon, size: 18, color: AppColors.primaryContainer),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeBg ?? AppColors.primaryFixed,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(badge, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(label, style: const TextStyle(color: AppColors.outline, fontSize: 12)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: valueColor)),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 10)),
          ],
        ],
      ),
    );
  }

  String _formatBulan(String rawBulan) {
    try {
      final parts = rawBulan.split('-');
      if (parts.length == 2) {
        final monthInt = int.tryParse(parts[1]);
        if (monthInt != null && monthInt >= 1 && monthInt <= 12) {
          const months = [
            "Jan", "Feb", "Mar", "Apr", "Mei", "Jun",
            "Jul", "Agt", "Sep", "Okt", "Nov", "Des"
          ];
          return months[monthInt - 1];
        }
      }
    } catch (_) {}
    return rawBulan;
  }

  Widget _buildStatisticsChart() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outline.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Statistik Pemakaian", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const Text("Tren penggunaan 6 bulan terakhir", style: TextStyle(color: AppColors.outline, fontSize: 12)),
          const SizedBox(height: 24),
          Obx(() {
            if (controller.isLoading.value) {
              return const SizedBox(
                height: 150,
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final history = controller.usageHistory;
            if (history.isEmpty) {
              return const SizedBox(
                height: 150,
                child: Center(
                  child: Text(
                    "Belum ada data pemakaian",
                    style: TextStyle(color: AppColors.onSurfaceVariant),
                  ),
                ),
              );
            }

            double maxUsage = 0.0;
            for (var item in history) {
              if (item.penggunaan > maxUsage) {
                maxUsage = item.penggunaan;
              }
            }
            if (maxUsage == 0) maxUsage = 10.0;

            return SizedBox(
              height: 160,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: history.map((item) {
                  double percentage = item.penggunaan / maxUsage;
                  double barHeight = percentage * 100;
                  if (item.penggunaan > 0 && barHeight < 10) {
                    barHeight = 10;
                  }

                  return Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          item.penggunaan.toStringAsFixed(1).replaceAll('.0', ''),
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryContainer,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          width: 24,
                          height: barHeight,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF64B5F6),
                                AppColors.primaryContainer,
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(6),
                              topRight: Radius.circular(6),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryContainer.withValues(alpha: 0.15),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _formatBulan(item.bulan),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildServicesMenu() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Menu Layanan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildServiceItem(
                icon: LucideIcons.plusCircle,
                label: "Pemasangan Baru",
                desc: "Daftar meteran baru",
                onTap: () => Get.toNamed(Routes.NEW_INSTALLATION),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildServiceItem(
                icon: LucideIcons.calculator,
                label: "Kalkulator",
                desc: "Estimasi tagihan",
                onTap: () => Get.toNamed(Routes.CALCULATOR),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildServiceItem({required IconData icon, required String label, required String desc, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.outline.withValues(alpha: 0.1)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppColors.secondaryContainer.withValues(alpha: 0.2), shape: BoxShape.circle),
              child: Icon(icon, color: AppColors.onSecondaryContainer),
            ),
            const SizedBox(height: 12),
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 4),
            Text(desc, style: const TextStyle(color: AppColors.outline, fontSize: 10), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}