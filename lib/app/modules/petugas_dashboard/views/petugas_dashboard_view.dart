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
                  'Dashboard Petugas Lapangan • Desa Pagerbarang',
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
                    const Flexible(
                      child: Text(
                        'Lokasi Saya Sekarang',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Tombol "Buka Maps"
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
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.open_in_new,
                            color: Color(0xff0D47A1),
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // MAP reaktif GPS
                Obx(() => _buildMap(
                      lat: controller.currentLat.value,
                      lng: controller.currentLng.value,
                      isLocating: controller.isLocating.value,
                      locationError: controller.locationError.value,
                    )),

                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Buka Google Maps di koordinat tertentu
  Future<void> _openInGoogleMaps(double lat, double lng) async {
    final Uri googleMapsUri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
    );
    final Uri geoUri = Uri.parse('geo:$lat,$lng?q=$lat,$lng');

    // Coba buka via geo: scheme (lebih akurat di Android)
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
        // Peta utama – bisa diklik untuk buka Google Maps
        GestureDetector(
          onTap: () => _openInGoogleMaps(lat, lng),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
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
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.tirta_desa',
                    maxZoom: 19,
                  ),
                  // Marker lokasi petugas (GPS)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: currentPoint,
                        width: 56,
                        height: 56,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Lingkaran biru transparan
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

        // Overlay: loading GPS
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

        // Overlay: error GPS
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
                      style:
                          const TextStyle(fontSize: 11, color: Colors.red),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),

        // Tombol refresh lokasi (pojok kanan atas peta)
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

        // Badge "Ketuk untuk buka Maps"
        Positioned(
          bottom: 12,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
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