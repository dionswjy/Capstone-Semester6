import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:tirta_desa/core/values/colors.dart';
import '../controllers/new_report_controller.dart';

class NewReportView extends GetView<NewReportController> {
  const NewReportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Buat Laporan Baru", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Pilih Kategori Masalah", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 16),
            _buildCategoryGrid(),
            const SizedBox(height: 24),
            const Text("Lokasi Kejadian", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 16),
            _buildLocationPlaceholder(),
            const SizedBox(height: 24),
            const Text("Deskripsi Masalah", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 16),
            TextField(
              controller: controller.descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Ceritakan detail masalah yang terjadi...",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 24),
            const Text("Unggah Foto Bukti (Opsional)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 16),
            _buildUploadBox(),
            const SizedBox(height: 40),
            Obx(() => SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: controller.isLoading.value ? null : controller.submit,
                icon: controller.isLoading.value
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Icon(LucideIcons.send, size: 18),
                label: Text(controller.isLoading.value ? "Mengirim..." : "Kirim Laporan"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryContainer,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryGrid() {
    final categories = [
      {'label': 'Pipa Bocor', 'icon': LucideIcons.droplets},
      {'label': 'Air Keruh', 'icon': LucideIcons.cloudRain},
      {'label': 'Meteran Rusak', 'icon': LucideIcons.gauge},
      {'label': 'Lainnya', 'icon': LucideIcons.moreHorizontal},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.5,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final cat = categories[index];
        return Obx(() {
          final isSelected = controller.selectedCategory.value == cat['label'];
          return GestureDetector(
            onTap: () => controller.selectCategory(cat['label'] as String),
            child: Container(
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryContainer.withOpacity(0.05) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isSelected ? AppColors.primaryContainer : AppColors.outline.withOpacity(0.1)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(cat['icon'] as IconData, color: isSelected ? AppColors.primaryContainer : AppColors.outline),
                  const SizedBox(height: 8),
                  Text(cat['label'] as String,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isSelected ? AppColors.primaryContainer : AppColors.onSurfaceVariant,
                      )),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  Widget _buildLocationPlaceholder() {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outline.withOpacity(0.1)),
        image: const DecorationImage(
          image: NetworkImage("https://lh3.googleusercontent.com/aida-public/AB6AXuBh5_pmAQYowewFuieUkCdjiY2yKik9wEc9-7YhBOglRKDsqcVZ-BmICfR28pb_9rf22j49I_gFJHwCS5kJ3TWj5TnuqEivBHwyg0WBGC7KhJtPd9O7hTcIK_tStmvaH4AUFy4ngW-lH62Q_pVRub_WB5K81aCqIbhK1yXAwDUCvW61_8bru8jtqhdKpX-vvlRqClZlh-GEIXBxVqPZeNkKTlTNswIZMG7Nw3d1-e0yl6idohRXfjlc6ahWYKu5RMujqSpL3NX8jn4"),
          fit: BoxFit.cover,
          opacity: 0.5,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Icon(LucideIcons.mapPin, color: Colors.red, size: 40),
          Positioned(
            bottom: 12,
            left: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), borderRadius: BorderRadius.circular(10)),
              child: const Row(
                children: [
                  Icon(LucideIcons.navigation, color: AppColors.primaryContainer, size: 16),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text("Jl. Tirta Raya No. 42, RT 03/RW 01",
                        style: TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outline.withOpacity(0.1), style: BorderStyle.none),
      ),
      // Using CustomPaint for dashed border in real app, here using simplified box
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.primaryContainer.withOpacity(0.1), shape: BoxShape.circle),
            child: const Icon(LucideIcons.camera, color: AppColors.primaryContainer),
          ),
          const SizedBox(height: 12),
          const Text("Ketuk untuk ambil foto", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const Text("Maksimum 3 foto (JPG/PNG)", style: TextStyle(color: AppColors.outline, fontSize: 10)),
        ],
      ),
    );
  }
}
