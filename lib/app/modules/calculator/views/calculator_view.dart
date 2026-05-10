import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:tirta_desa/core/values/colors.dart';
import '../controllers/calculator_controller.dart';

class CalculatorView extends GetView<CalculatorController> {
  const CalculatorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Kalkulator", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Kalkulator Tagihan",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: AppColors.primaryContainer)),
            const SizedBox(height: 8),
            const Text("Estimasi biaya pemakaian air Anda secara mandiri dengan memasukkan angka pada meteran air.",
                style: TextStyle(color: AppColors.onSurfaceVariant)),
            const SizedBox(height: 32),
            _buildInputCard(),
            const SizedBox(height: 24),
            _buildResultCard(),
            const SizedBox(height: 24),
            _buildInfoGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outline.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          _buildMeterField("Meter Awal (m³)", controller.startMeterController, LucideIcons.gauge),
          const SizedBox(height: 16),
          _buildMeterField("Meter Akhir (m³)", controller.endMeterController, LucideIcons.edit3, hint: "Masukkan angka "),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: controller.calculate,
              icon: const Icon(LucideIcons.sparkles, size: 18),
              label: const Text("Hitung Tagihan Sekarang"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryContainer,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMeterField(String label, TextEditingController ctrl, IconData icon, {String hint = ""}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, size: 20, color: AppColors.outline),
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }

  Widget _buildResultCard() {
    return Obx(() {
      if (controller.totalUsage.value == 0 && controller.estimation.value == 0) return const SizedBox();
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.primaryContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("TOTAL PEMAKAIAN", style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text("${controller.totalUsage.value} m³", style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                  ],
                ),
                const Icon(LucideIcons.droplets, color: Colors.white30, size: 48),
              ],
            ),
            const Divider(color: Colors.white24, height: 32),
            _resultRow("Estimasi Tagihan", "Rp ${controller.estimation.value - controller.serviceFee}"),
            const SizedBox(height: 8),
            _resultRow("Biaya Layanan", "Rp ${controller.serviceFee}"),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Total Dibayar", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryContainer)),
                  Text("Rp ${controller.estimation.value}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primaryContainer)),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _resultRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70)),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildInfoGrid() {
    return Row(
      children: [
        Expanded(child: _infoBox("Tarif Per m³", "Rp ${controller.ratePerM3}")),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.outline.withOpacity(0.1))),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Status Alat", style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12)),
                SizedBox(height: 4),
                Row(
                  children: [
                    CircleAvatar(radius: 4, backgroundColor: Colors.green),
                    SizedBox(width: 8),
                    Text("Normal", style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _infoBox(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.primaryFixed.withOpacity(0.2), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.primaryFixed)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: AppColors.primaryContainer, fontSize: 12)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }
}
