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
      backgroundColor: const Color(0xffF8FAFC),
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
    return Obx(() => Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: controller.currentIndex.value,
            onTap: controller.changeTabIndex,
            selectedItemColor: const Color(0xff0D47A1),
            unselectedItemColor: Colors.grey.shade500,
            backgroundColor: Colors.white,
            elevation: 0,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(LucideIcons.home),
                activeIcon: Icon(LucideIcons.home, color: Color(0xff0D47A1)),
                label: "Beranda",
              ),
              BottomNavigationBarItem(
                icon: Icon(LucideIcons.barChart3),
                activeIcon: Icon(LucideIcons.barChart3, color: Color(0xff0D47A1)),
                label: "Laporan",
              ),
              BottomNavigationBarItem(
                icon: Icon(LucideIcons.user),
                activeIcon: Icon(LucideIcons.user, color: Color(0xff0D47A1)),
                label: "Profil",
              ),
            ],
          ),
        ));
  }
}

class HomeTab extends GetView<DashboardController> {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Row(
          children: [
            Icon(LucideIcons.droplets, color: Color(0xff0D47A1), size: 24),
            SizedBox(width: 8),
            Text(
              "TirtaDesa",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xff0D47A1),
                fontSize: 20,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => Get.toNamed(Routes.NOTIFICATIONS),
            icon: const Icon(LucideIcons.bell, color: Color(0xff1A1C1E)),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.fetchDashboardData(),
        color: const Color(0xff0D47A1),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Banner Card
              _buildWelcomeBanner(),

              const SizedBox(height: 28),

              // Summary Cards
              _buildSummaryCards(),

              const SizedBox(height: 28),

              // Statistics Chart
              _buildStatisticsChart(),

              const SizedBox(height: 28),

              // Menu Layanan
              _buildServicesMenu(),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xff0D47A1), Color(0xff1E88E5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff0D47A1).withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      'No. Meter: ${controller.noMeter.value}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  )),
              const Icon(LucideIcons.droplets, color: Colors.white, size: 24),
            ],
          ),
          const SizedBox(height: 20),
          Obx(() => Text(
                'Halo, ${controller.userName.value}!',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              )),
          const SizedBox(height: 6),
          const Text(
            'Koneksi air aktif • Pantau tagihan Anda secara real-time',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Obx(() {
      final isLunas = controller.statusPembayaran.value == "Lunas";
      return Row(
        children: [
          // Card Penggunaan Air
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.black.withValues(alpha: 0.04)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xff0D47A1).withValues(alpha: 0.08),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(LucideIcons.waves, color: Color(0xff0D47A1), size: 18),
                      ),
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xffE8EDFF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            "Bulan Ini",
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff0D47A1),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    "Penggunaan Air",
                    style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    controller.penggunaanAir.value,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Color(0xff1A1C1E)),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Aktif digunakan",
                    style: TextStyle(color: Colors.grey, fontSize: 10),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Card Status Pembayaran
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: isLunas ? const Color(0xffF0FDF4) : const Color(0xffFFF2F2),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isLunas ? Colors.green.withValues(alpha: 0.15) : Colors.red.withValues(alpha: 0.15),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.01),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isLunas ? Colors.green.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isLunas ? LucideIcons.checkCircle : LucideIcons.wallet,
                          color: isLunas ? Colors.green : Colors.red,
                          size: 18,
                        ),
                      ),
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            isLunas ? "Lunas" : "Belum Lunas",
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: isLunas ? Colors.green : Colors.red,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    "Status Tagihan",
                    style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isLunas ? "Terbayar" : controller.totalTagihanStr.value,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: isLunas ? Colors.green.shade800 : Colors.red,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isLunas ? "Terima kasih" : "Segera lakukan pembayaran",
                    style: TextStyle(color: isLunas ? Colors.green.shade700 : Colors.red.shade700, fontSize: 10),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildStatisticsChart() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.black.withValues(alpha: 0.04)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Statistik Pemakaian",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xff1A1C1E)),
          ),
          const SizedBox(height: 4),
          const Text(
            "Tren penggunaan air 6 bulan terakhir",
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 24),
          Obx(() {
            if (controller.isLoading.value) {
              return const SizedBox(
                height: 160,
                child: Center(
                  child: CircularProgressIndicator(color: Color(0xff0D47A1)),
                ),
              );
            }

            final history = controller.usageHistory;
            if (history.isEmpty) {
              return const SizedBox(
                height: 160,
                child: Center(
                  child: Text(
                    "Belum ada data pemakaian",
                    style: TextStyle(color: Colors.grey),
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
              height: 180,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: history.map((item) {
                  double percentage = item.penggunaan / maxUsage;
                  double barHeight = percentage * 120;
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
                            color: Color(0xff0D47A1),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          width: 16,
                          height: barHeight,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xff42A5F5),
                                Color(0xff0D47A1),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xff0D47A1).withValues(alpha: 0.15),
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
                            color: Colors.grey,
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

  Widget _buildServicesMenu() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Menu Layanan",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xff1A1C1E)),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _buildServiceItem(
              icon: LucideIcons.plusCircle,
              label: "Pemasangan Baru",
              desc: "Daftar sambungan baru",
              onTap: () => Get.toNamed(Routes.NEW_INSTALLATION),
            ),
            const SizedBox(width: 16),
            _buildServiceItem(
              icon: LucideIcons.calculator,
              label: "Kalkulator Air",
              desc: "Simulasi tagihan bulanan",
              onTap: () => Get.toNamed(Routes.CALCULATOR),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildServiceItem({
    required IconData icon,
    required String label,
    required String desc,
    VoidCallback? onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.black.withValues(alpha: 0.04)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xff0D47A1).withValues(alpha: 0.06),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: const Color(0xff0D47A1), size: 22),
              ),
              const SizedBox(height: 12),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xff374151)),
              ),
              const SizedBox(height: 4),
              Text(
                desc,
                style: const TextStyle(color: Colors.grey, fontSize: 9),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}