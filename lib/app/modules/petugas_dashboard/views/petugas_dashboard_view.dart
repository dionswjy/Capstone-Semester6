import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../routes/app_pages.dart';
import '../controllers/petugas_dashboard_controller.dart';

class PetugasDashboardView extends GetView<PetugasDashboardController> {
  const PetugasDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC),
      bottomNavigationBar: Container(
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
          currentIndex: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xff0D47A1),
          unselectedItemColor: Colors.grey.shade500,
          backgroundColor: Colors.white,
          elevation: 0,
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
              activeIcon: Icon(Icons.home_rounded),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.speed_outlined),
              activeIcon: Icon(Icons.speed_rounded),
              label: 'Meteran',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person_rounded),
              label: 'Profil',
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => controller.fetchDashboardData(),
          color: const Color(0xff0D47A1),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Banner
                _buildWelcomeBanner(),

                const SizedBox(height: 28),

                // Loading / Error / Content state
                Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Ringkasan Tugas Title
                      const Text(
                        'Ringkasan Tugas',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff1A1C1E),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Primary Stat: Total Pelanggan
                      _buildPrimaryStat(),

                      const SizedBox(height: 14),

                      // Secondary Stats: Pengaduan & Tagihan Belum Lunas
                      _buildSecondaryStats(),
                    ],
                  );
                }),

                const SizedBox(height: 28),

                // Menu Cepat Section
                _buildQuickActions(),

                const SizedBox(height: 28),

                // Peta Section Card
                _buildMapSection(),

                const SizedBox(height: 40),
              ],
            ),
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
          colors: [Color(0xff0D47A1), Color(0xff1976D2)],
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Text(
                  'TirtaDesa Petugas',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const Icon(Icons.water_drop_rounded, color: Colors.white, size: 24),
            ],
          ),
          const SizedBox(height: 20),
          Obx(() => Text(
                'Halo, ${controller.userName.value}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              )),
          const SizedBox(height: 6),
          const Text(
            'Wilayah Kerja: Desa Pagerbarang',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrimaryStat() {
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xff0D47A1).withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.groups_2_rounded, color: Color(0xff0D47A1), size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'TOTAL PELANGGAN',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Obx(() => Text(
                      controller.totalPelanggan.value.toString(),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff1A1C1E),
                      ),
                    )),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xffE8EDFF),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Obx(() => Text(
                  '${controller.totalMeter.value} Meteran',
                  style: const TextStyle(
                    color: Color(0xff0D47A1),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildSecondaryStats() {
    return Row(
      children: [
        // Card Pengaduan
        Expanded(
          child: Obx(() {
            final count = controller.komplainBaru.value;
            final isUrgent = count > 0;
            return Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: isUrgent ? const Color(0xffFFF2F2) : const Color(0xffF0FDF4),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isUrgent ? Colors.red.withValues(alpha: 0.15) : Colors.green.withValues(alpha: 0.15),
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
                          color: isUrgent ? Colors.red.withValues(alpha: 0.1) : Colors.green.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isUrgent ? Icons.warning_amber_rounded : Icons.check_circle_outline_rounded,
                          color: isUrgent ? Colors.red : Colors.green,
                          size: 20,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          isUrgent ? 'Urgent' : 'Aman',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: isUrgent ? Colors.red : Colors.green,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'PENGADUAN',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    count.toString(),
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: isUrgent ? Colors.red : Colors.green,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
        const SizedBox(width: 14),
        // Card Tagihan Belum Lunas
        Expanded(
          child: Obx(() {
            final count = controller.tagihanBelumLunas.value;
            final hasUnpaid = count > 0;
            return Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: hasUnpaid ? const Color(0xffFFFDF0) : Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: hasUnpaid ? const Color(0xffB45309).withValues(alpha: 0.15) : Colors.black.withValues(alpha: 0.04),
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
                          color: hasUnpaid ? const Color(0xffB45309).withValues(alpha: 0.1) : Colors.grey.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.receipt_long_rounded,
                          color: hasUnpaid ? const Color(0xffB45309) : Colors.grey.shade600,
                          size: 20,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          hasUnpaid ? 'Tindak' : 'Lunas',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: hasUnpaid ? const Color(0xffB45309) : Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'BELUM LUNAS',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    count.toString(),
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: hasUnpaid ? const Color(0xffB45309) : Colors.grey.shade800,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Menu Cepat',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xff1A1C1E),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _quickActionItem(
              icon: Icons.speed_rounded,
              label: 'Catat Meter',
              color: const Color(0xff0D47A1),
              onTap: () => Get.offAllNamed(Routes.PETUGAS_PELANGGAN),
            ),
            _quickActionItem(
              icon: Icons.history_rounded,
              label: 'Log Aktivitas',
              color: const Color(0xff6A1B9A),
              onTap: () => Get.toNamed(Routes.PETUGAS_ACTIVITY_LOG),
            ),
            _quickActionItem(
              icon: Icons.person_rounded,
              label: 'Profil Saya',
              color: const Color(0xff007C89),
              onTap: () => Get.offAllNamed(Routes.PETUGAS_PROFILE),
            ),
          ],
        ),
      ],
    );
  }

  Widget _quickActionItem({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
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
                  color: color.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 10),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff374151),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMapSection() {
    return Container(
      width: double.infinity,
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.location_on_rounded, color: Color(0xff0D47A1), size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Lokasi Saya Sekarang',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff1A1C1E),
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => _openInGoogleMaps(
                  controller.currentLat.value,
                  controller.currentLng.value,
                ),
                child: const Row(
                  children: [
                    Text(
                      'Buka Maps',
                      style: TextStyle(
                        color: Color(0xff0D47A1),
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.open_in_new_rounded, color: Color(0xff0D47A1), size: 16),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Obx(() => _buildMap(
                lat: controller.currentLat.value,
                lng: controller.currentLng.value,
                isLocating: controller.isLocating.value,
                locationError: controller.locationError.value,
              )),
        ],
      ),
    );
  }

  Future<void> _openInGoogleMaps(double lat, double lng) async {
    final Uri googleMapsUri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
    );
    final Uri geoUri = Uri.parse('geo:$lat,$lng?q=$lat,$lng');

    if (await canLaunchUrl(geoUri)) {
      await launchUrl(geoUri);
    } else if (await canLaunchUrl(googleMapsUri)) {
      await launchUrl(googleMapsUri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar(
        'Tidak bisa membuka Maps',
        'Pastikan Google Maps terinstall di perangkat',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Widget _buildMap({
    required double lat,
    required double lng,
    required bool isLocating,
    required String locationError,
  }) {
    final currentPoint = LatLng(lat, lng);

    return Stack(
      children: [
        GestureDetector(
          onTap: () => _openInGoogleMaps(lat, lng),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SizedBox(
              height: 260,
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: currentPoint,
                  initialZoom: 15.0,
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.all,
                  ),
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.tirta_desa',
                    maxZoom: 19,
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: currentPoint,
                        width: 56,
                        height: 56,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: const Color(0xff0D47A1).withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const Icon(
                              Icons.my_location,
                              color: Color(0xff0D47A1),
                              size: 32,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        if (isLocating)
          Positioned(
            top: 12,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Color(0xff0D47A1),
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Mencari lokasi...',
                    style: TextStyle(fontSize: 12, color: Color(0xff0D47A1)),
                  ),
                ],
              ),
            ),
          ),
        if (!isLocating && locationError.isNotEmpty)
          Positioned(
            top: 12,
            left: 12,
            right: 60,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xffFDECEC),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.gps_off, color: Colors.red, size: 14),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      locationError,
                      style: const TextStyle(fontSize: 11, color: Colors.red),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        Positioned(
          top: 12,
          right: 12,
          child: GestureDetector(
            onTap: () => controller.fetchCurrentLocation(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Obx(() => controller.isLocating.value
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Color(0xff0D47A1),
                      ),
                    )
                  : const Icon(
                      Icons.gps_fixed,
                      color: Color(0xff0D47A1),
                      size: 20,
                    )),
            ),
          ),
        ),
        Positioned(
          bottom: 12,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.touch_app, color: Colors.white, size: 14),
                  SizedBox(width: 6),
                  Text(
                    'Ketuk peta untuk buka Google Maps',
                    style: TextStyle(color: Colors.white, fontSize: 11),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
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
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 16),
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.refresh),
            label: const Text('Coba Lagi'),
            onPressed: () => controller.fetchDashboardData(),
          ),
        ],
      ),
    );
  }
}