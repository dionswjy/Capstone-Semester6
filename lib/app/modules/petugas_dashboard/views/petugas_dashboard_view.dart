import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
            Get.offAllNamed(
              Routes.PETUGAS_DASHBOARD,
            );
          } else if (index == 1) {
            Get.offAllNamed(
              Routes.PETUGAS_PELANGGAN,
            );
          } else if (index == 2) {
            Get.offAllNamed(
              Routes.PETUGAS_PENGADUAN,
            );
          } else if (index == 3) {
            Get.offAllNamed(
              Routes.PETUGAS_PROFILE,
            );
          }
        },

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Beranda",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.speed_outlined),
            label: "Meteran",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            label: "Laporan",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profil",
          ),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const Text(
                "TirtaDesa",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff0D47A1),
                ),
              ),

              const SizedBox(height: 36),

              const Text(
                "Halo, Agus\nSusanto",
                style: TextStyle(
                  fontSize: 42,
                  height: 1.1,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff0D47A1),
                ),
              ),

              const SizedBox(height: 12),

              Text(
                "Dashboard Petugas Lapangan • Desa Sumber Jaya",
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.grey.shade700,
                ),
              ),

              const SizedBox(height: 32),

              // CARD TOTAL
              _dashboardCard(
                title: "TOTAL PELANGGAN",
                value: "1.248",
                icon: Icons.groups_2_outlined,
                badge: "+12 bln ini",
                backgroundColor: Colors.white,
                valueColor: Colors.black,
                badgeColor: const Color(0xffE8EDFF),
                badgeTextColor: const Color(0xff0D47A1),
              ),

              const SizedBox(height: 18),

              // CARD PENGADUAN
              _dashboardCard(
                title: "PENGADUAN MASUK",
                value: "5",
                icon: Icons.warning_amber_rounded,
                badge: "Urgent",
                backgroundColor: const Color(0xffFDECEC),
                valueColor: Colors.red,
                badgeColor: Colors.white,
                badgeTextColor: Colors.red,
              ),

              const SizedBox(height: 38),

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [

                  const Text(
                    "Rute Tugas Hari Ini",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Row(
                    children: const [
                      Text(
                        "Detail Rute",
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

              // MAP
              Container(
                height: 210,
                width: double.infinity,

                decoration: BoxDecoration(
                  color: const Color(0xffDADDE2),
                  borderRadius: BorderRadius.circular(22),
                ),

                child: Stack(
                  children: [

                    const Center(
                      child: Icon(
                        Icons.map,
                        size: 90,
                        color: Color(0xff0D47A1),
                      ),
                    ),

                    Positioned(
                      right: 16,
                      top: 50,
                      child: Column(
                        children: [

                          _mapButton(Icons.add),

                          const SizedBox(height: 8),

                          _mapButton(Icons.remove),
                        ],
                      ),
                    ),

                    Positioned(
                      left: 16,
                      bottom: 16,
                      child: Container(
                        padding: const EdgeInsets.all(10),

                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(14),
                        ),

                        child: const Icon(
                          Icons.my_location,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),
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
          color: Colors.black.withOpacity(0.05),
        ),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [

              Container(
                padding: const EdgeInsets.all(12),

                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(14),
                ),

                child: Icon(
                  icon,
                  color: const Color(0xff0D47A1),
                ),
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

  Widget _mapButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),

      child: Icon(icon),
    );
  }
}