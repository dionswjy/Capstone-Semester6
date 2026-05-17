import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/petugas_pengaduan_controller.dart';

class PetugasPengaduanView
    extends GetView<PetugasPengaduanController> {
  const PetugasPengaduanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
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
            crossAxisAlignment:
                CrossAxisAlignment.start,
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

              const SizedBox(height: 34),

              const Text(
                "Pengaduan Pelanggan",
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                "Kelola dan respon keluhan warga desa hari ini.",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey.shade700,
                ),
              ),

              const SizedBox(height: 28),

              // SEARCH
              TextField(
                decoration: InputDecoration(
                  hintText: "Cari ID pelanggan",
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

              const SizedBox(height: 28),

              // CARD
              _complaintCard(
                name: "Bpk. Ahmad Suherman",
                id: "#TK-88291",
                location: "Dusun Krajan, RT 02/01",
                title: "Pipa Bocor di depan rumah",
                desc:
                    "Air mengalir deras dari pipa bawah tanah sejak jam 6 pagi tadi. Jalanan...",
                status: "URGENT",
                statusColor: Colors.red,
                time: "2 jam yang lalu",
                buttonText: "Respons Sekarang",
                icon: Icons.home_work_outlined,
                iconColor: Colors.blue,
              ),

              _complaintCard(
                name: "Ibu Siti Aminah",
                id: "#TK-88305",
                location: "Dusun Tengah, RT 05/02",
                title: "Air mati total sejak malam",
                desc:
                    "Sudah cek kran utama tetap tidak mengalir. Tetangga sebelah juga...",
                status: "DIPROSES",
                statusColor: Colors.cyan,
                time: "5 jam yang lalu",
                buttonText: "Bpk. Slamet di lokasi",
                icon: Icons.water,
                iconColor: Colors.teal,
              ),

              _complaintCard(
                name: "Bpk. Hartono",
                id: "#TK-88312",
                location: "Dusun Selatan, RT 10/04",
                title: "Meteran air retak",
                desc:
                    "Kaca penutup meteran retak terkena dahan jatuh. Angka masih terbaca.",
                status: "SELESAI",
                statusColor: Colors.grey,
                time: "Diselesaikan kemarin",
                buttonText: "Oleh: Anda",
                icon: Icons.description_outlined,
                iconColor: Colors.grey,
              ),

              _complaintCard(
                name: "Ibu Maria Ulfa",
                id: "#TK-88320",
                location:
                    "Perumahan Desa, Blok C12",
                title: "Air keruh berwarna coklat",
                desc:
                    "Sejak siang tadi air yang keluar sangat keruh dan ada endapan tanahnya.",
                status: "BARU",
                statusColor: Colors.indigo,
                time: "15 menit yang lalu",
                buttonText: "Respons sekarang",
                icon: Icons.water_drop_outlined,
                iconColor: Colors.blue,
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _complaintCard({
    required String name,
    required String id,
    required String location,
    required String title,
    required String desc,
    required String status,
    required Color statusColor,
    required String time,
    required String buttonText,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 22),

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [

          Row(
            children: [

              const CircleAvatar(
                radius: 28,
                backgroundColor: Color(0xffE3F2FD),
                child: Icon(
                  Icons.person,
                  color: Color(0xff0D47A1),
                  size: 26,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    Text(
                      id,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),

                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text(
                      location,
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
                  horizontal: 14,
                  vertical: 8,
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

          const SizedBox(height: 22),

          Row(
            children: [

              Icon(
                icon,
                color: iconColor,
              ),

              const SizedBox(width: 8),

              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: iconColor,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Text(
            '"$desc"',
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
              color: Colors.grey.shade700,
              fontStyle: FontStyle.italic,
            ),
          ),

          const SizedBox(height: 18),

          Divider(
            color: Colors.grey.shade300,
          ),

          const SizedBox(height: 14),

          Row(
            children: [

              Icon(
                Icons.access_time,
                size: 18,
                color: Colors.grey.shade600,
              ),

              const SizedBox(width: 8),

              Expanded(
                child: Text(
                  time,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                ),
              ),

              status == "SELESAI"
                  ? Text(
                      buttonText,
                      style: TextStyle(
                        color:
                            Colors.grey.shade600,
                      ),
                    )
                  : ElevatedButton(
                      onPressed: () {},

                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(
                                0xff0D47A1),

                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius
                                  .circular(12),
                        ),
                      ),

                      child: Text(
                        buttonText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }
}