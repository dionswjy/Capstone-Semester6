import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:tirta_desa/core/values/colors.dart';
import '../controllers/payment_detail_controller.dart';

class PaymentDetailView extends GetView<PaymentDetailController> {
  const PaymentDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Rincian Pembayaran",
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildStatusCard(),
            const SizedBox(height: 24),
            _buildInfoBento(),
            const SizedBox(height: 24),
            _buildCostBreakdown(),
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomActions(),
    );
  }

  Widget _buildStatusCard() {
    final isLunas = controller.isLunas;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryContainer.withValues(alpha: 0.05),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: (isLunas ? Colors.green : Colors.orange)
                  .withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isLunas ? LucideIcons.checkCircle : LucideIcons.clock,
              color: isLunas ? Colors.green : Colors.orange,
              size: 48,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            isLunas ? "Pembayaran Berhasil" : "Tagihan Belum Lunas",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Text(
            isLunas
                ? "Terima kasih atas kontribusi Anda"
                : "Segera lakukan pembayaran",
            style: const TextStyle(color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: 24),
          Text(
            controller.formatRupiah(controller.tagihan.totalTagihan),
            style: TextStyle(
              color: isLunas ? Colors.green : Colors.orange,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              controller.trxId,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBento() {
    final tagihan = controller.tagihan;
    return Row(
      children: [
        Expanded(
          child: _bentoBox("INFO TRANSAKSI", [
            _bentoItem(
              "Tanggal Bayar",
              controller.formatTanggalBayar(tagihan.tanggalBayar),
            ),
            _bentoItem(
              "Status",
              controller.statusLabel,
            ),
          ]),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _bentoBox("DETAIL METER", [
            _bentoItem(
              "Bulan",
              controller.formatBulan(tagihan.bulan),
            ),
            _bentoItem(
              "Pemakaian",
              "${tagihan.penggunaanM3.toStringAsFixed(1)} m³",
            ),
          ]),
        ),
      ],
    );
  }

  Widget _bentoBox(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.primaryContainer,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _bentoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
                color: AppColors.onSurfaceVariant, fontSize: 10),
          ),
          Text(
            value,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildCostBreakdown() {
    final tagihan = controller.tagihan;
    // Estimasi biaya: hitung dari total - biaya layanan tetap Rp15.000
    // atau tampilkan total langsung
    final totalTagihan = tagihan.totalTagihan;
    final biayaLayanan = 15000.0;
    final biayaPemakaian = totalTagihan > biayaLayanan
        ? totalTagihan - biayaLayanan
        : totalTagihan;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0x0D0D47A1),
              borderRadius:
                  BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: const Row(
              children: [
                Icon(LucideIcons.receipt,
                    size: 16, color: AppColors.primaryContainer),
                SizedBox(width: 8),
                Text(
                  "RINCIAN BIAYA",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: AppColors.primaryContainer,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _costRow(
                  "Biaya Pemakaian (${tagihan.penggunaanM3.toStringAsFixed(1)} m³)",
                  controller.formatRupiah(biayaPemakaian),
                ),
                if (totalTagihan > biayaLayanan) ...[
                  const SizedBox(height: 12),
                  _costRow(
                    "Biaya Layanan",
                    controller.formatRupiah(biayaLayanan),
                  ),
                ],
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total Bayar",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      controller.formatRupiah(totalTagihan),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: AppColors.primaryContainer,
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

  Widget _costRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            label,
            style: const TextStyle(color: AppColors.onSurfaceVariant),
          ),
        ),
        Text(value,
            style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(color: Colors.white),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                Get.snackbar(
                  'Fitur segera hadir',
                  'Simpan struk dalam pengembangan',
                  backgroundColor: AppColors.primaryContainer,
                  colorText: Colors.white,
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
              icon: const Icon(LucideIcons.download, size: 18),
              label: const Text("Simpan Struk"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryContainer,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                Get.snackbar(
                  'Fitur segera hadir',
                  'Bagikan struk dalam pengembangan',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
              icon: const Icon(LucideIcons.share, size: 18),
              label: const Text("Bagikan"),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                side: const BorderSide(color: AppColors.primaryContainer),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
