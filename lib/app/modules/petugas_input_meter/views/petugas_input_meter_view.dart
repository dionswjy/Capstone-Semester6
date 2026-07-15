import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/petugas_input_meter_controller.dart';

class PetugasInputMeterView extends GetView<PetugasInputMeterController> {
  const PetugasInputMeterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F8FB),
      body: SafeArea(
        child: Obx(() {
          // ── Loading awal ──────────────────────────
          if (controller.isLoadingData.value) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xff007BFF)),
            );
          }

          // ── Error state ───────────────────────────
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

          // ── Konten utama ──────────────────────────
          return SingleChildScrollView(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
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

                const SizedBox(height: 26),

                const Text(
                  'Input Meter Air',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 4),

                Obx(() => Text(
                      'Petugas: ${controller.petugasNama.value}',
                      style: TextStyle(
                          fontSize: 17, color: Colors.grey.shade700),
                    )),

                const SizedBox(height: 26),

                // ── Info Pelanggan ────────────────────
                _cardPelanggan(),

                const SizedBox(height: 18),

                // ── SCAN OCR CARD ─────────────────────
                Obx(() => Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xff0D47A1),
                            Color(0xff1565C0),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.document_scanner_outlined,
                                  color: Colors.white, size: 22),
                              SizedBox(width: 8),
                              Text(
                                'SCAN FOTO METERAN',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Ambil foto meteran, angka akan terisi otomatis',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (controller.isScanning.value)
                            const Center(
                              child: Column(
                                children: [
                                  CircularProgressIndicator(
                                      color: Colors.white),
                                  SizedBox(height: 10),
                                  Text(
                                    'Memproses gambar...',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            )
                          else
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed:
                                        controller.scanMeterFromCamera,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor:
                                          const Color(0xff0D47A1),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 14),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10),
                                      ),
                                    ),
                                    icon: const Icon(Icons.camera_alt),
                                    label: const Text(
                                      'Kamera',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed:
                                        controller.scanMeterFromGallery,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white
                                          .withValues(alpha: 0.15),
                                      foregroundColor: Colors.white,
                                      side: const BorderSide(
                                          color: Colors.white54),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 14),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10),
                                      ),
                                    ),
                                    icon: const Icon(Icons.photo_library),
                                    label: const Text(
                                      'Galeri',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    )),

                const SizedBox(height: 18),

                // ── Form input meter ──────────────────
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.edit_note, color: Color(0xff007BFF)),
                          SizedBox(width: 8),
                          Text(
                            'INPUT MANUAL',
                            style: TextStyle(
                              color: Color(0xff007BFF),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 22),

                      // Meter bulan lalu (read-only dari backend)
                      Text(
                        'Meteran Bulan Lalu (m³)',
                        style: TextStyle(
                            fontSize: 16, color: Colors.grey.shade700),
                      ),
                      const SizedBox(height: 10),
                      Obx(() => TextField(
                            enabled: false,
                            decoration: InputDecoration(
                              hintText: controller.selectedMeter.value == null
                                  ? 'Memuat...'
                                  : controller.angkaMeterLalu.value
                                      .toStringAsFixed(2),
                              filled: true,
                              fillColor: const Color(0xffF1F4F7),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: Colors.grey.shade300),
                              ),
                            ),
                            controller: controller.angkaMeterLaluCtrl,
                          )),

                      const SizedBox(height: 20),

                      // Meter saat ini (input petugas)
                      Text(
                        'Meteran Saat Ini (m³)',
                        style: TextStyle(
                            fontSize: 16, color: Colors.grey.shade700),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: controller.angkaMeterKiniCtrl,
                        textAlign: TextAlign.center,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff007BFF),
                        ),
                        decoration: InputDecoration(
                          hintText: '00000.00',
                          hintStyle:
                              const TextStyle(color: Color(0xff007BFF)),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 18),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: Color(0xff007BFF), width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: Color(0xff007BFF), width: 2),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Tampilkan pemakaian (auto-hitung)
                      Obx(() => Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: const Color(0xffEAF2FF),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: const Color(0xffC8DCF8)),
                            ),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                const Expanded(
                                  child: Text(
                                    'Pemakaian Bulan Ini:',
                                    style: TextStyle(fontSize: 16),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    controller.penggunaan.value > 0
                                        ? '${controller.penggunaan.value.toStringAsFixed(2)} m³'
                                        : '-- m³',
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff007BFF),
                                    ),
                                    textAlign: TextAlign.end,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // ── Tombol Simpan ─────────────────────
                Obx(() {
                  final isSaving = controller.isSaving.value;
                  final hasNoMeter = controller.selectedMeter.value == null;

                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: (isSaving || hasNoMeter)
                          ? null
                          : controller.simpanMeter,
                      icon: isSaving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2),
                            )
                          : const Icon(Icons.save, color: Colors.white),
                      label: Text(
                        hasNoMeter
                            ? 'Meteran Belum Terdaftar'
                            : (isSaving ? 'Menyimpan...' : 'Simpan Data Meteran'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff007BFF),
                        disabledBackgroundColor: hasNoMeter
                            ? Colors.grey.shade400
                            : const Color(0xff007BFF).withOpacity(0.6),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 16),

                // ── Tombol Batal ──────────────────────
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      side: const BorderSide(color: Colors.black54),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Batal & Kembali',
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 80),
              ],
            ),
          );
        }),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // WIDGETS HELPER
  // ─────────────────────────────────────────────

  Widget _cardPelanggan() {
    final p = controller.pelanggan;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xffEAF2FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.person_outline,
                color: Color(0xff007BFF)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'PELANGGAN',
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                Text(
                  p.nama,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff007BFF),
                  ),
                ),
                Text('No. Meter: ${p.noMeter}'),
                const SizedBox(height: 4),
                Text(p.alamat,
                    style: TextStyle(color: Colors.grey.shade600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}