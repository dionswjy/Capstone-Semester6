import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../routes/app_pages.dart';
import '../controllers/petugas_profile_controller.dart';

class PetugasProfileView extends GetView<PetugasProfileController> {
  const PetugasProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FB),
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
            icon: Icon(Icons.person_outline),
            label: "Profil",
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Profil Petugas",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff0D47A1),
                  ),
                ),
              ),

              const SizedBox(height: 46),

              // ── PROFILE PHOTO (WITH CLICK-TO-EDIT) ──
              GestureDetector(
                onTap: () => _showPhotoPickerDialog(context),
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 62,
                      backgroundColor: Colors.white,
                      child: Obx(() {
                        final path = controller.profilePhotoPath.value;
                        if (path.isNotEmpty && File(path).existsSync()) {
                          return CircleAvatar(
                            radius: 56,
                            backgroundColor: const Color(0xff0D47A1),
                            backgroundImage: FileImage(File(path)),
                          );
                        } else {
                          final encodedName = Uri.encodeComponent(
                              controller.petugasNama.value);
                          return CircleAvatar(
                            radius: 56,
                            backgroundColor: const Color(0xff0D47A1),
                            child: ClipOval(
                              child: Image.network(
                                'https://ui-avatars.com/api/?name=$encodedName&background=0D47A1&color=FFFFFF&size=256',
                                width: 112,
                                height: 112,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(
                                  Icons.person,
                                  size: 70,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        }
                      }),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xff0D47A1),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              Obx(() => Text(
                    controller.petugasNama.value,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  )),

              const SizedBox(height: 10),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Obx(() => Text(
                      "ID Petugas: TD-STAFF-${controller.petugasId.value.toString().padLeft(3, '0')}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                    )),
              ),

              const SizedBox(height: 34),

              // ── INFORMASI AKUN CARD ────────────────
              Obx(() => _sectionCard(
                    icon: Icons.person_outline,
                    title: "INFORMASI AKUN",
                    children: [
                      _InfoItem(
                        icon: Icons.email_outlined,
                        label: "Email",
                        value: controller.petugasEmail.value,
                      ),
                      _InfoItem(
                        icon: Icons.phone_outlined,
                        label: "Telepon",
                        value: controller.petugasPhone.value,
                      ),
                    ],
                  )),

              const SizedBox(height: 24),

              // ── LOG AKTIVITAS CARD ─────────────────
              GestureDetector(
                onTap: () => Get.toNamed(Routes.PETUGAS_ACTIVITY_LOG),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xffF0F4FF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.history,
                          color: Color(0xff0D47A1),
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Log Aktivitas',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Color(0xff1A1C1E),
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Lihat riwayat aktivitas Anda',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xff6B7280),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        color: Color(0xff0D47A1),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 34),

              // ── TOMBOL KELUAR ──────────────────────
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => controller.logout(),
                  icon: const Icon(
                    Icons.logout,
                    color: Colors.red,
                  ),
                  label: const Text(
                    "Keluar",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffFFD9D9),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 90),
            ],
          ),
        ),
      ),
    );
  }

  void _showPhotoPickerDialog(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(22),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ganti Foto Profil',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 18),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Color(0xff0D47A1)),
              title: const Text('Ambil Foto Kamera'),
              onTap: () {
                Get.back();
                controller.changeProfilePhoto(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Color(0xff0D47A1)),
              title: const Text('Pilih dari Galeri'),
              onTap: () {
                Get.back();
                controller.changeProfilePhoto(ImageSource.gallery);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _sectionCard({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: const Color(0xff0D47A1),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xff0D47A1),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Divider(color: Colors.grey.shade300),
          const SizedBox(height: 6),
          ...children,
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: Colors.black54,
            size: 24,
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}