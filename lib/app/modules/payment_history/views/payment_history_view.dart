import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:tirta_desa/app/data/models/meter_model.dart';
import 'package:tirta_desa/core/values/colors.dart';
import 'package:tirta_desa/app/routes/app_pages.dart';
import '../controllers/payment_history_controller.dart';

class PaymentHistoryView extends GetView<PaymentHistoryController> {
  const PaymentHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Riwayat Pembayaran",
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Obx(() => controller.isLoading.value
              ? const Padding(
                  padding: EdgeInsets.all(16),
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: AppColors.primaryContainer),
                  ),
                )
              : IconButton(
                  onPressed: controller.loadData,
                  icon: const Icon(LucideIcons.refreshCw, size: 18),
                )),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryContainer),
          );
        }

        if (controller.hasError.value) {
          return _buildError(controller.errorMessage.value);
        }

        return RefreshIndicator(
          onRefresh: controller.loadData,
          color: AppColors.primaryContainer,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Ringkasan tahun ini
                _buildYearSummary(),
                const SizedBox(height: 16),

                // Status tagihan terbaru
                if (controller.tagihanTerbaru != null)
                  _buildLastStatus(controller.tagihanTerbaru!),

                const SizedBox(height: 32),

                // Header daftar transaksi
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Daftar Transaksi",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    Text(
                      "${controller.tagihanList.length} tagihan",
                      style: const TextStyle(
                          color: AppColors.onSurfaceVariant, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Daftar tagihan dari backend
                if (controller.tagihanList.isEmpty)
                  _buildEmpty()
                else
                  ...controller.tagihanList
                      .map((t) => _buildTransactionCard(t)),

                const SizedBox(height: 80),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildYearSummary() {
    return Obx(() => Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.primaryContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("TOTAL PEMBAYARAN TAHUN INI",
                  style: TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(
                controller.formatRupiah(controller.totalTahunIni.value),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(LucideIcons.checkCircle,
                      color: Colors.white70, size: 14),
                  const SizedBox(width: 8),
                  Text(
                    "${controller.jumlahTerbayar.value} Tagihan Terbayar",
                    style:
                        const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  Widget _buildLastStatus(TagihanModel tagihan) {
    final isLunas = tagihan.statusPembayaran.toLowerCase() == 'lunas';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outline.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: (isLunas ? Colors.green : Colors.orange)
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isLunas ? LucideIcons.check : LucideIcons.clock,
              color: isLunas ? Colors.green : Colors.orange,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isLunas ? "Lunas" : "Belum Lunas",
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                controller.formatBulan(tagihan.bulan),
                style: const TextStyle(
                    color: AppColors.outline, fontSize: 12),
              ),
            ],
          ),
          const Spacer(),
          TextButton(
            onPressed: () =>
                Get.toNamed(Routes.PAYMENT_DETAIL, arguments: tagihan),
            child: const Text("Lihat Rincian"),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionCard(TagihanModel tagihan) {
    final isLunas = tagihan.statusPembayaran.toLowerCase() == 'lunas';
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outline.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                controller.formatBulan(tagihan.bulan),
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryContainer),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: (isLunas ? Colors.green : Colors.orange)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isLunas ? "Lunas" : "Belum Lunas",
                  style: TextStyle(
                    color: isLunas ? Colors.green : Colors.orange,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Tanggal Bayar",
                      style: TextStyle(
                          color: AppColors.outline, fontSize: 10)),
                  Text(
                    controller.formatTanggalBayar(tagihan.tanggalBayar),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text("Jumlah",
                      style: TextStyle(
                          color: AppColors.outline, fontSize: 10)),
                  Text(
                    controller.formatRupiah(tagihan.totalTagihan),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryContainer,
                        fontSize: 16),
                  ),
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
              Text(
                "ID: #TRX-${tagihan.id.toString().padLeft(6, '0')}",
                style: const TextStyle(
                    color: AppColors.outline, fontSize: 10),
              ),
              Text(
                "Meter: ${tagihan.penggunaanM3.toStringAsFixed(1)} m³",
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Tombol lihat detail
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () =>
                  Get.toNamed(Routes.PAYMENT_DETAIL, arguments: tagihan),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.primaryContainer),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(vertical: 8),
              ),
              child: const Text("Lihat Rincian",
                  style: TextStyle(color: AppColors.primaryContainer)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: const Column(
        children: [
          Icon(LucideIcons.receipt, size: 48, color: Colors.grey),
          SizedBox(height: 12),
          Text("Belum ada riwayat pembayaran",
              style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(LucideIcons.wifiOff, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: controller.loadData,
              icon: const Icon(LucideIcons.refreshCw, size: 16),
              label: const Text("Coba Lagi"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryContainer,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
