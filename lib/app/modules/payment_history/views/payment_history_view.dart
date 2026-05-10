import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:tirta_desa/core/values/colors.dart';
import 'package:tirta_desa/app/routes/app_pages.dart';

class PaymentHistoryView extends StatelessWidget {
  const PaymentHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Riwayat Pembayaran", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildYearSummary(),
            const SizedBox(height: 16),
            _buildLastStatus(),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Daftar Transaksi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                IconButton(onPressed: () {}, icon: const Icon(LucideIcons.filter, size: 18)),
              ],
            ),
            const SizedBox(height: 16),
            _buildTransactionCard(
              month: "Oktober 2023",
              date: "05 Okt 2023",
              amount: "Rp 75.000",
              id: "#TRX-992102",
              meter: "1240 m³",
            ),
            _buildTransactionCard(
              month: "September 2023",
              date: "03 Sep 2023",
              amount: "Rp 68.500",
              id: "#TRX-883912",
              meter: "1212 m³",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildYearSummary() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("TOTAL PEMBAYARAN TAHUN INI", style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text("Rp 845.000", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            children: const [
              Icon(LucideIcons.checkCircle, color: Colors.white70, size: 14),
              SizedBox(width: 8),
              Text("12 Tagihan Terbayar", style: TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLastStatus() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outline.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                child: const Icon(LucideIcons.check, color: Colors.green, size: 20),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Lunas", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text("Oktober 2023", style: TextStyle(color: AppColors.outline, fontSize: 12)),
                ],
              ),
              const Spacer(),
              TextButton(
                onPressed: () => Get.toNamed(Routes.PAYMENT_DETAIL),
                child: const Text("Lihat Rincian"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionCard({
    required String month,
    required String date,
    required String amount,
    required String id,
    required String meter,
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(month, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryContainer)),
              const Text("Lunas", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Tanggal Bayar", style: TextStyle(color: AppColors.outline, fontSize: 10)),
                  Text(date, style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text("Jumlah", style: TextStyle(color: AppColors.outline, fontSize: 10)),
                  Text(amount, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryContainer, fontSize: 16)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("ID: $id", style: const TextStyle(color: AppColors.outline, fontSize: 10)),
              Text("Meter: $meter", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}
