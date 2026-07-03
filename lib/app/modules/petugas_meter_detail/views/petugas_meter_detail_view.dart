import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tirta_desa/app/data/models/meter_model.dart';

import '../controllers/petugas_meter_detail_controller.dart';

class PetugasMeterDetailView
    extends GetView<PetugasMeterDetailController> {
  const PetugasMeterDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),
      body: SafeArea(
        child: Obx(() {
          // ── Loading ─────────────────────────────
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xff0D47A1)),
            );
          }

          // ── Error ───────────────────────────────
          if (controller.hasError.value) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.wifi_off_rounded,
                      size: 56, color: Colors.red),
                  const SizedBox(height: 12),
                  const Text('Gagal memuat data',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('Pastikan server aktif dan koneksi tersedia',
                      textAlign: TextAlign.center),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff007BFF)),
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    label: const Text('Coba Lagi',
                        style: TextStyle(color: Colors.white)),
                    onPressed: controller.refreshData,
                  ),
                ],
              ),
            );
          }

          // ── Konten utama ────────────────────────
          return RefreshIndicator(
            onRefresh: controller.refreshData,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // HEADER
                  Row(
                    children: [
                      InkWell(
                        onTap: () => Get.back(),
                        child: const Icon(Icons.arrow_back,
                            color: Color(0xff0D47A1)),
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.water_drop_outlined,
                          color: Color(0xff0D47A1)),
                      const SizedBox(width: 8),
                      const Text(
                        'TirtaDesa',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff0D47A1),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ── CUSTOMER CARD ──────────────────────
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CircleAvatar(
                          radius: 34,
                          backgroundColor: Color(0xff1565F9),
                          child: Icon(Icons.person_outline,
                              color: Colors.white, size: 34),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.pelanggan.nama,
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff0D47A1),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'No. Meter: ${controller.pelanggan.noMeter}',
                                style: TextStyle(
                                    color: Colors.grey.shade600),
                              ),
                              const SizedBox(height: 4),
                              Obx(() => Text(
                                    'Status Meter: ${controller.meterPelanggan.value?.statusMeter ?? "-"}',
                                    style: TextStyle(
                                        color: Colors.grey.shade600),
                                  )),
                              const SizedBox(height: 16),
                              Text(
                                'ALAMAT METER',
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Obx(() => Text(
                                    controller.meterPelanggan.value
                                            ?.alamatLokasi ??
                                        controller.pelanggan.alamat,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── METERAN TERKINI ────────────────────
                  Obx(() => _infoCard(
                        title: 'Meteran Terkini',
                        value: controller.indexTerkini.value
                            .toStringAsFixed(2),
                        unit: 'm³',
                        color: const Color(0xff1565F9),
                        textColor: Colors.white,
                      )),

                  const SizedBox(height: 18),

                  // ── RATA-RATA BULANAN ──────────────────
                  Obx(() => _infoCard(
                        title: 'Rata-rata Pemakaian Bulanan',
                        value: controller.rataRataBulanan.value
                            .toStringAsFixed(2),
                        unit: 'm³',
                        color: Colors.white,
                        textColor: const Color(0xff006D77),
                      )),

                  const SizedBox(height: 18),

                  // ── STATUS PEMBAYARAN ──────────────────
                  Obx(() {
                    final status =
                        controller.statusPembayaran.value.toLowerCase();
                    final isLunas = status == 'lunas' ||
                        status == 'dibayar' ||
                        status == 'paid';
                    return Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Status Pembayaran',
                            style:
                                TextStyle(color: Colors.grey.shade700),
                          ),
                          const SizedBox(height: 18),
                          Row(
                            children: [
                              Icon(
                                isLunas
                                    ? Icons.check_circle
                                    : Icons.warning_amber_rounded,
                                color: isLunas
                                    ? Colors.green
                                    : Colors.orange,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  controller.statusPembayaran.value
                                      .isEmpty
                                      ? 'Belum Ada Tagihan'
                                      : controller
                                          .statusPembayaran.value
                                          .toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: isLunas
                                        ? Colors.green
                                        : Colors.orange,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),

                  const SizedBox(height: 34),

                  // ── RIWAYAT PENCATATAN ─────────────────
                  const Text(
                    'Riwayat\nPencatatan',
                    style: TextStyle(
                      fontSize: 34,
                      height: 1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 18),

                  Obx(() {
                    if (controller.riwayatCatat.isEmpty) {
                      return Container(
                        width: double.infinity,
                        padding:
                            const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: const Column(
                          children: [
                            Icon(Icons.history,
                                size: 48, color: Colors.grey),
                            SizedBox(height: 12),
                            Text(
                              'Belum ada riwayat pencatatan',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      );
                    }

                    return Column(
                      children: controller.riwayatCatat
                          .map((c) => _historyCard(c))
                          .toList(),
                    );
                  }),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _infoCard({
    required String title,
    required String value,
    required String unit,
    required Color color,
    required Color textColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: textColor.withValues(alpha: 0.8),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  unit,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _historyCard(CatatMeterModel c) {
    final bulanFormatted = controller.formatBulan(c.bulan);
    final isVerified = c.statusVerifikasi == 'terverifikasi' ||
        c.statusVerifikasi == 'verified';

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xffF3F7FF),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.calendar_month,
                    color: Color(0xff0D47A1)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bulanFormatted,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Petugas: ${c.petugasNama}',
                      style:
                          TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _historyItem('Meter Lalu',
                  '${c.angkaMeterLalu.toStringAsFixed(2)} m³'),
              _historyItem('Meter Kini',
                  '${c.angkaMeterKini.toStringAsFixed(2)} m³'),
              _historyItem(
                'Pemakaian',
                '${c.penggunaanM3.toStringAsFixed(2)} m³',
                valueColor: const Color(0xff006D77),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: isVerified
                  ? const Color(0xffD7F8FF)
                  : const Color(0xffFFF3CD),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Center(
              child: Text(
                isVerified
                    ? '✓ Terverifikasi'
                    : '⏳ ${c.statusVerifikasi.toUpperCase()}',
                style: TextStyle(
                  color: isVerified
                      ? const Color(0xff006D77)
                      : const Color(0xff856404),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _historyItem(
    String title,
    String value, {
    Color valueColor = Colors.black,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}