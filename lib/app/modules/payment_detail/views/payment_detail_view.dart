import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:tirta_desa/core/values/colors.dart';

class PaymentDetailView extends StatelessWidget {
  const PaymentDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Rincian Pembayaran", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildSuccessCard(),
            const SizedBox(height: 24),
            _buildInfoBento(),
            const SizedBox(height: 24),
            _buildCostBreakdown(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomActions(),
    );
  }

  Widget _buildSuccessCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: AppColors.primaryContainer.withOpacity(0.05), blurRadius: 30, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.primaryContainer.withOpacity(0.1), shape: BoxShape.circle),
            child: const Icon(LucideIcons.checkCircle, color: AppColors.primaryContainer, size: 48),
          ),
          const SizedBox(height: 16),
          const Text("Pembayaran Berhasil", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          const Text("Terima kasih atas kontribusi Anda", style: TextStyle(color: AppColors.onSurfaceVariant)),
          const SizedBox(height: 24),
          const Text("Rp 75.000", style: TextStyle(color: AppColors.primaryContainer, fontSize: 32, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(30)),
            child: const Text("#TRX-992102", style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBento() {
    return Row(
      children: [
        Expanded(
          child: _bentoBox("INFO TRANSAKSI", [
            _bentoItem("Tanggal", "05 Okt 2023"),
            _bentoItem("Metode", "Transfer Bank"),
          ]),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _bentoBox("DETAIL METER", [
            _bentoItem("Bulan", "Oktober 2023"),
            _bentoItem("Total", "15 m³"),
          ]),
        ),
      ],
    );
  }

  Widget _bentoBox(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: AppColors.primaryContainer, fontSize: 10, fontWeight: FontWeight.bold)),
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
          Text(label, style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 10)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildCostBreakdown() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(color: AppColors.primaryContainer.withOpacity(0.05), borderRadius: const BorderRadius.vertical(top: Radius.circular(16))),
            child: const Row(
              children: [
                Icon(LucideIcons.receipt, size: 16, color: AppColors.primaryContainer),
                SizedBox(width: 8),
                Text("RINCIAN BIAYA", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primaryContainer)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _costRow("Biaya Pemakaian (15 m³)", "Rp 60.000"),
                const SizedBox(height: 12),
                _costRow("Biaya Layanan", "Rp 15.000"),
                const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text("Total Bayar", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text("Rp 75.000", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: AppColors.primaryContainer)),
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
        Text(label, style: const TextStyle(color: AppColors.onSurfaceVariant)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
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
              onPressed: () {},
              icon: const Icon(LucideIcons.download, size: 18),
              label: const Text("Simpan Struk"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryContainer,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(LucideIcons.share, size: 18),
              label: const Text("Bagikan"),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                side: const BorderSide(color: AppColors.primaryContainer),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
