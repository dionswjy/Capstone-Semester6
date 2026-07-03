import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../../../routes/app_pages.dart';
import '../controllers/petugas_dashboard_controller.dart';

class PetugasDashboardView extends GetView<PetugasDashboardController> {
  const PetugasDashboardView({super.key});

  // Titik tengah peta – sesuaikan dengan lokasi desa
  static const LatLng _desaCenter = LatLng(-7.250445, 112.768845);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xff00DDEB),
        unselectedItemColor: Colors.grey,

        onTap: (index) {
          if (index == 0) {
            Get.offAllNamed(Routes.PETUGAS_DASHBOARD);
          } else if (index == 1) {
            Get.offAllNamed(Routes.PETUGAS_PELANGGAN);
          } else if (index == 2) {
            Get.offAllNamed(Routes.PETUGAS_PROFILE);
          }
        },

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.speed_outlined),
            label: 'Meteran',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profil',
          ),
        ],
      ),

      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => controller.fetchDashboardData(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(24),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header brand
                const Text(
                  'TirtaDesa',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff0D47A1),
                  ),
                ),

                const SizedBox(height: 36),

                // Salam petugas (data dari storage)
                Obx(() => Text(
                      'Halo,\n${controller.userName.value}',
                      style: const TextStyle(
                        fontSize: 42,
                        height: 1.1,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff0D47A1),
                      ),
                    )),

                const SizedBox(height: 12),

                const Text(
                  'Dashboard Petugas Lapangan • Desa Sumber Jaya',
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 32),

                // Loading / Error state
                Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: CircularProgressIndicator(
                          color: Color(0xff0D47A1),
                        ),
                      ),
                    );
                  }

                  if (controller.hasError.value) {
                    return _errorCard();
                  }

                  return Column(
                    children: [
                      // CARD TOTAL PELANGGAN
                      Obx(() => _dashboardCard(
                            title: 'TOTAL PELANGGAN',
                            value: controller.totalPelanggan.value.toString(),
                            icon: Icons.groups_2_outlined,
                            badge: '${controller.totalMeter.value} Meteran',
                            backgroundColor: Colors.white,
                            valueColor: Colors.black,
                            badgeColor: const Color(0xffE8EDFF),
                            badgeTextColor: const Color(0xff0D47A1),
                          )),

                      const SizedBox(height: 18),

                      // CARD PENGADUAN MASUK
                      Obx(() => _dashboardCard(
                            title: 'PENGADUAN MASUK',
                            value: controller.komplainBaru.value.toString(),
                            icon: Icons.warning_amber_rounded,
                            badge: controller.komplainBaru.value > 0
                                ? 'Urgent'
                                : 'Aman',
                            backgroundColor:
                                controller.komplainBaru.value > 0
                                    ? const Color(0xffFDECEC)
                                    : const Color(0xffECFDF5),
                            valueColor: controller.komplainBaru.value > 0
                                ? Colors.red
                                : Colors.green,
                            badgeColor: Colors.white,
                            badgeTextColor: controller.komplainBaru.value > 0
                                ? Colors.red
                                : Colors.green,
                          )),

                      const SizedBox(height: 18),

                      // CARD TAGIHAN BELUM LUNAS
                      Obx(() => _dashboardCard(
                            title: 'TAGIHAN BELUM LUNAS',
                            value:
                                controller.tagihanBelumLunas.value.toString(),
                            icon: Icons.receipt_long_outlined,
                            badge: 'Perlu Tindak',
                            backgroundColor: const Color(0xffFFFBEB),
                            valueColor: const Color(0xffB45309),
                            badgeColor: Colors.white,
                            badgeTextColor: const Color(0xffB45309),
                          )),
                    ],
                  );
                }),

                const SizedBox(height: 38),

                // Judul peta
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Rute Tugas Hari Ini',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: const [
                        Text(
                          'Detail Rute',
                          style: TextStyle(
                            color: Color(0xff0D47A1),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.chevron_right,
                          color: Color(0xff0D47A1),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // MAP (flutter_map + OpenStreetMap)
                _buildMap(),

                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMap() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: SizedBox(
        height: 260,
        child: FlutterMap(
          options: MapOptions(
            initialCenter: _desaCenter,
            initialZoom: 14.0,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.all,
            ),
          ),
          children: [
            // Layer peta OpenStreetMap – gratis, tanpa API key
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.tirta_desa',
              maxZoom: 19,
            ),

            // Marker lokasi desa / titik tugas
            MarkerLayer(
              markers: [
                Marker(
                  point: _desaCenter,
                  width: 48,
                  height: 48,
                  child: const Icon(
                    Icons.location_pin,
                    color: Color(0xff0D47A1),
                    size: 48,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _errorCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xffFDECEC),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(Icons.wifi_off_rounded, color: Colors.red, size: 40),
          const SizedBox(height: 8),
          const Text(
            'Gagal memuat data',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.red, fontSize: 16),
          ),
          const SizedBox(height: 4),
          const Text(
            'Pastikan koneksi internet aktif\ndan server berjalan.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.refresh),
            label: const Text('Coba Lagi'),
            onPressed: () => controller.fetchDashboardData(),
          ),
        ],
      ),
    );
  }

  Widget _dashboardCard({
    required String title,
    required String value,
    required IconData icon,
    required String badge,
    required Color backgroundColor,
    required Color valueColor,
    required Color badgeColor,
    required Color badgeTextColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.05),
        ),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: const Color(0xff0D47A1)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  badge,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: badgeTextColor,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),

          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              letterSpacing: 0.5,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            value,
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}