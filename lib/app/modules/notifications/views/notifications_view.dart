import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:tirta_desa/core/values/colors.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Notifikasi", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(LucideIcons.checkCheck)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text("HARI INI",
              style: TextStyle(color: AppColors.outline, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
          const SizedBox(height: 16),
          _buildItem(
            icon: LucideIcons.alertTriangle,
            color: Colors.red,
            title: "Gangguan Layanan",
            time: "10:45 AM",
            body: "Pemeliharaan terjadwal di Wilayah 4. Mohon menampung air.",
            unread: true,
          ),
          _buildItem(
            icon: LucideIcons.receipt,
            color: AppColors.primaryContainer,
            title: "Tagihan Tersedia",
            time: "8:20 AM",
            body: "Tagihan air Anda untuk Oktober 2023 sudah tersedia.",
            unread: true,
          ),
          const SizedBox(height: 24),
          const Text("KEMARIN",
              style: TextStyle(color: AppColors.outline, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
          const SizedBox(height: 16),
          _buildItem(
            icon: LucideIcons.droplet,
            color: Colors.blue,
            title: "Pencapaian Pemakaian",
            time: "Oct 24, 4:15 PM",
            body: "Luar biasa! Pemakaian air Anda minggu ini 15% lebih rendah.",
            unread: false,
          ),
        ],
      ),
    );
  }

  Widget _buildItem({
    required IconData icon,
    required Color color,
    required String title,
    required String time,
    required String body,
    required bool unread,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outline.withOpacity(0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(time, style: const TextStyle(color: AppColors.outline, fontSize: 10)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(body, style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 13)),
              ],
            ),
          ),
          if (unread) ...[
            const SizedBox(width: 8),
            Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle)),
          ],
        ],
      ),
    );
  }
}
