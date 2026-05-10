import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:tirta_desa/core/values/colors.dart';
import 'package:tirta_desa/app/routes/app_pages.dart';

class ReportsView extends StatelessWidget {
  const ReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Laporan Pengaduan", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildHeroCTA(),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Riwayat Laporan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(LucideIcons.filter, size: 16),
                  label: const Text("Filter"),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildReportCard(
              id: "#TK-88291",
              title: "Pipa Bocor",
              status: "Diproses",
              statusColor: Colors.orange,
              desc: "Ada kebocoran pipa di depan rumah nomor 42, air meluap hingga ke jalan raya.",
              date: "24 Okt 2023",
            ),
            _buildReportCard(
              id: "#TK-88305",
              title: "Air Keruh",
              status: "Pending",
              statusColor: Colors.red,
              desc: "Air yang keluar dari keran berwarna kecoklatan dan berbau tanah.",
              date: "Sekarang",
            ),
            _buildReportCard(
              id: "#TK-87912",
              title: "Meteran Rusak",
              status: "Selesai",
              statusColor: Colors.green,
              desc: "Angka di meteran tidak bergerak meskipun air digunakan secara normal.",
              date: "20 Okt 2023",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroCTA() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: AppColors.primaryContainer.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        children: [
          const Text(
            "Ada Masalah dengan Air Anda?",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            "Laporkan kebocoran, air keruh, atau gangguan lainnya. Kami siap membantu.",
            style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Get.toNamed(Routes.NEW_REPORT),
            icon: const Icon(LucideIcons.plusCircle, size: 18),
            label: const Text("Buat Laporan Baru"),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondaryContainer,
              foregroundColor: AppColors.onSecondaryContainer,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard({
    required String id,
    required String title,
    required String status,
    required Color statusColor,
    required String desc,
    required String date,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outline.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(id, style: const TextStyle(color: AppColors.outline, fontSize: 12)),
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryContainer)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                child: Text(status, style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(desc, style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 13), maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(LucideIcons.calendar, size: 14, color: AppColors.outline),
                  const SizedBox(width: 8),
                  Text(date, style: const TextStyle(color: AppColors.outline, fontSize: 12)),
                ],
              ),
              const Icon(LucideIcons.chevronRight, size: 18, color: AppColors.outline),
            ],
          ),
        ],
      ),
    );
  }
}
