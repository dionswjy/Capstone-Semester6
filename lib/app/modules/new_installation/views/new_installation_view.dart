import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:tirta_desa/core/values/colors.dart';
import '../controllers/new_installation_controller.dart';

class NewInstallationView extends GetView<NewInstallationController> {
  const NewInstallationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Pemasangan Baru", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Lengkapi formulir di bawah ini untuk mengajukan pemasangan meteran air baru.",
                style: TextStyle(color: AppColors.onSurfaceVariant)),
            const SizedBox(height: 24),
            _buildSectionHeader(LucideIcons.user, "Informasi Pribadi"),
            const SizedBox(height: 16),
            _buildPersonalInfoForm(),
            const SizedBox(height: 24),
            _buildSectionHeader(LucideIcons.layoutGrid, "Kategori Bangunan"),
            const SizedBox(height: 16),
            _buildCategorySelector(),
            const SizedBox(height: 24),
            _buildSectionHeader(LucideIcons.mapPin, "Alamat Pemasangan"),
            const SizedBox(height: 16),
            _buildAddressForm(),
            const SizedBox(height: 24),
            _buildSectionHeader(LucideIcons.fileText, "Unggah Dokumen"),
            const SizedBox(height: 16),
            _buildUploadGrid(),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: Obx(() => ElevatedButton.icon(
                onPressed: controller.isLoading.value ? null : controller.submit,
                icon: controller.isLoading.value
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(LucideIcons.send, size: 18),
                label: Text(controller.isLoading.value ? "Mengirim..." : "Ajukan Pemasangan"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryContainer,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryContainer, size: 20),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }

  Widget _buildPersonalInfoForm() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildField("Nama Lengkap Sesuai KTP", controller.nameController, "Contoh: Budi Santoso"),
          const SizedBox(height: 12),
          _buildField("NIK", controller.nikController, "16 digit nomor NIK"),
          const SizedBox(height: 12),
          _buildField("Nomor Telepon/WA", controller.phoneController, "0812xxxx"),
        ],
      ),
    );
  }

  Widget _buildCategorySelector() {
    final types = [
      {'label': 'Rumah', 'icon': LucideIcons.home},
      {'label': 'Niaga', 'icon': LucideIcons.store},
      {'label': 'Sosial', 'icon': LucideIcons.users},
    ];

    return Row(
      children: types.map((t) {
        return Expanded(
          child: Obx(() {
            final isSelected = controller.selectedCategory.value == t['label'];
            return GestureDetector(
              onTap: () => controller.selectCategory(t['label'] as String),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryFixed : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: isSelected ? AppColors.primaryContainer : AppColors.outline.withOpacity(0.1)),
                ),
                child: Column(
                  children: [
                    Icon(t['icon'] as IconData,
                        color: isSelected ? AppColors.primaryContainer : AppColors.onSurfaceVariant),
                    const SizedBox(height: 8),
                    Text(t['label'] as String,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: isSelected ? AppColors.primaryContainer : AppColors.onSurfaceVariant)),
                  ],
                ),
              ),
            );
          }),
        );
      }).toList(),
    );
  }

  Widget _buildAddressForm() {
    return Column(
      children: [
        Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: const DecorationImage(
              image: NetworkImage("https://lh3.googleusercontent.com/aida-public/AB6AXuBKUZ_Dfry5cbipkiiP-CAuUQpydw_q4ChSuY46Rk0vQ98_9oqb43e1b49TOsirVDb227TuHJDCEkPBwPgk9vYxXLkc0XM6LB2ezXJu8bYXjEQXV-vs4K6N3i7xROorBd2sYke1C4Q4-ynDaf87vYV5b-YQrbs2188n6xnlPvORot5iMheZrKuMcsQ81g4rU0jv1-aKo6Ozsl6SdE-0x5_nJO4C_uQ4q0tQawp3lcbR15HgOf51I0Nno-D80UnOj6bOsH3HBngd8bI"),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(LucideIcons.locate, size: 14, color: AppColors.primaryContainer),
                  SizedBox(width: 4),
                  Text("Gunakan Lokasi Saat Ini", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: controller.addressController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: "Masukkan alamat lengkap...",
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }

  Widget _buildUploadGrid() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.outline.withOpacity(0.1)),
            ),
            child: const Column(
              children: [
                Icon(LucideIcons.camera, color: AppColors.outline),
                SizedBox(height: 8),
                Text("Ambil Foto KTP", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                Text("Format JPG, PNG max 2MB", style: TextStyle(color: AppColors.outline, fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(String label, TextEditingController ctrl, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant)),
        const SizedBox(height: 4),
        TextField(
          controller: ctrl,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }
}
