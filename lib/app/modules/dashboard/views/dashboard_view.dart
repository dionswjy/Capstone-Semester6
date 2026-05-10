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

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.8),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Halo, Pak Budi!",
              style: Get.textTheme.headlineLarge?.copyWith(
                color: AppColors.primaryContainer,
                fontWeight: FontWeight.bold,
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
    );
  }

  Widget _buildSummaryCards() {
    return Row(
      children: [
        Expanded(
          child: _buildInfoCard(
            icon: LucideIcons.waves,
            iconBg: AppColors.primaryFixed,
            label: "Penggunaan Air",
            value: "24.5 m³",
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
            value: "Belum Bayar",
            valueColor: AppColors.error,
            badge: "Tagihan Baru",
            badgeBg: AppColors.errorContainer,
          ),
        ),
      ],
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
        border: Border.all(color: AppColors.outline.withOpacity(0.1)),
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

  Widget _buildStatisticsChart() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outline.withOpacity(0.1)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Statistik Pemakaian", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          Text("Tren penggunaan 6 bulan terakhir", style: TextStyle(color: AppColors.outline, fontSize: 12)),
          SizedBox(height: 24),
          SizedBox(
            height: 150,
            child: Center(child: Text("Chart Placeholder")),
          ),
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
          border: Border.all(color: AppColors.outline.withOpacity(0.1)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppColors.secondaryContainer.withOpacity(0.2), shape: BoxShape.circle),
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