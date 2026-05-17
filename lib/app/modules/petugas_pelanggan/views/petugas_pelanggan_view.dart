import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/petugas_pelanggan_controller.dart';

class PetugasPelangganView
    extends GetView<PetugasPelangganController> {
  const PetugasPelangganView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
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
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // LOGO
              Row(
                children: const [

                  Icon(
                    Icons.water_drop_outlined,
                    color: Color(0xff0D47A1),
                  ),

                  SizedBox(width: 8),

                  Text(
                    "TirtaDesa",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff0D47A1),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // SEARCH
              TextField(
                decoration: InputDecoration(
                  hintText:
                      "Cari Nama atau ID Pelanggan...",
                  prefixIcon:
                      const Icon(Icons.search),

                  filled: true,
                  fillColor: Colors.white,

                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // STAT
              Row(
                children: [

                  Expanded(
                    child: _statCard(
                      title: "Total Pelanggan",
                      value: "1,284",
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: _statCard(
                      title: "Wilayah Aktif",
                      value: "12",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // LIST CUSTOMER
              _customerCard(
                name: "Budi Santoso",
                id: "TD-2024-001",
                address:
                    "Jl. Mawar No. 12, RT 04/RW 02, Desa Tirta Jaya",
                category: "Rumah Tangga A",
                status: "AKTIF",
                statusColor: Colors.blue,
              ),

              _customerCard(
                name: "Siti Aminah",
                id: "TD-2024-005",
                address:
                    "Blok B5 No. 02, RT 01/RW 05, Desa Tirta Jaya",
                category: "Sosial / Subsidi",
                status: "SUBSIDI",
                statusColor: Colors.grey,
              ),

              _customerCard(
                name: "Agus Pratama",
                id: "TD-2024-082",
                address:
                    "Gg. Damai No. 04, RT 03/RW 01, Desa Tirta Jaya",
                category: "Rumah Tangga B",
                status: "MENUNGGAK",
                statusColor: Colors.red,
              ),

              _customerCard(
                name: "Diana Putri",
                id: "TD-2024-112",
                address:
                    "Jl. Kenanga No. 88, RT 02/RW 03, Desa Tirta Jaya",
                category: "Niaga Kecil",
                status: "AKTIF",
                statusColor: Colors.blue,
              ),

              _customerCard(
                name: "Hendra Wijaya",
                id: "TD-2024-045",
                address:
                    "Komp. Sejahtera C14, RT 05/RW 02, Desa Tirta Jaya",
                category: "Rumah Tangga A",
                status: "AKTIF",
                statusColor: Colors.blue,
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statCard({
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            title,
            style: TextStyle(
              color: Colors.grey.shade700,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            value,
            style: const TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: Color(0xff0D47A1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _customerCard({
    required String name,
    required String id,
    required String address,
    required String category,
    required String status,
    required Color statusColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),

      child: Column(
        children: [

          Container(
            padding: const EdgeInsets.all(16),

            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.06),

              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(22),
                topRight: Radius.circular(22),
              ),
            ),

            child: Row(
              children: [

                CircleAvatar(
                  backgroundColor:
                      statusColor.withOpacity(0.1),

                  child: Icon(
                    Icons.person_outline,
                    color: statusColor,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [

                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 2),

                      Text(
                        "ID: $id",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),

                  decoration: BoxDecoration(
                    color:
                        statusColor.withOpacity(0.1),
                    borderRadius:
                        BorderRadius.circular(20),
                  ),

                  child: Text(
                    status,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),

            child: Column(
              children: [

                Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    Icon(
                      Icons.location_on_outlined,
                      color: Colors.grey.shade600,
                    ),

                    const SizedBox(width: 8),

                    Expanded(
                      child: Text(
                        address,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Row(
                  children: [

                    Icon(
                      Icons.category_outlined,
                      color: Colors.grey.shade600,
                    ),

                    const SizedBox(width: 8),

                    Text(
                      "Kategori: ",
                      style: TextStyle(
                        color: Colors.grey.shade700,
                      ),
                    ),

                    Text(
                      category,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                Row(
                  children: [

                    Expanded(
                      child: ElevatedButton.icon(
                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xff1565F9),

                          padding:
                              const EdgeInsets.symmetric(
                            vertical: 14,
                          ),

                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                                    14),
                          ),
                        ),

                        onPressed: () {
                          Get.toNamed(
                            Routes.PETUGAS_INPUT_METER,
                          );
                        },

                        icon: const Icon(
                          Icons.edit_note,
                          color: Colors.white,
                        ),

                        label: const Text(
                          "Catat Meter",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    InkWell(
                      onTap: () {
                        Get.toNamed(
                          Routes.PETUGAS_METER_DETAIL,
                        );
                      },

                      child: Container(
                        padding:
                            const EdgeInsets.all(14),

                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius:
                              BorderRadius.circular(
                                  14),
                        ),

                        child: const Icon(
                          Icons.chevron_right,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}