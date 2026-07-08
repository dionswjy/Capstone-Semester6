import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:tirta_desa/app/data/models/meter_model.dart';
import 'package:tirta_desa/app/data/services/payment_service.dart';

class PaymentHistoryController extends GetxController {
  final _box = GetStorage();
  final _service = PaymentService();

  // State
  var isLoading = false.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;

  // Data tagihan
  var tagihanList = <TagihanModel>[].obs;
  var totalTahunIni = 0.0.obs;
  var jumlahTerbayar = 0.obs;

  // Info meter
  var meterId = 0.obs;
  var pelangganId = 0.obs;

  // Data tagihan terbaru (untuk card "status terakhir")
  TagihanModel? get tagihanTerbaru =>
      tagihanList.isNotEmpty ? tagihanList.first : null;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    final token = _box.read('token');
    if (token == null) {
      hasError.value = true;
      errorMessage.value = 'Silakan login terlebih dahulu';
      return;
    }

    isLoading.value = true;
    hasError.value = false;

    try {
      // Step 1: Ambil data dashboard pelanggan (berisi pelanggan_id)
      final dashboard = await _service.fetchDashboardPelanggan(token);
      if (dashboard == null) {
        hasError.value = true;
        errorMessage.value = 'Gagal memuat data. Cek koneksi internet.';
        return;
      }

      final pId = dashboard['pelanggan_id'];
      if (pId == null) {
        hasError.value = true;
        errorMessage.value = 'Data pelanggan belum tersedia';
        return;
      }
      pelangganId.value = pId;

      // Step 2: Cari meter_id
      final mId = await _service.fetchMeterIdByPelanggan(token, pId);
      if (mId == null) {
        hasError.value = true;
        errorMessage.value = 'Meter belum terdaftar untuk akun ini';
        return;
      }
      meterId.value = mId;

      // Step 3: Ambil riwayat tagihan berdasarkan meter_id
      final list = await _service.fetchRiwayatTagihan(token, mId);
      tagihanList.value = list;

      // Hitung statistik tahun ini
      final now = DateTime.now();
      final tahunIni = now.year;
      double totalBayar = 0;
      int terbayar = 0;

      for (final t in list) {
        // Coba parse bulan dari format "YYYY-MM" atau nama bulan
        int? tahunTagihan = _parseTahun(t.bulan);
        if (tahunTagihan == tahunIni && t.statusPembayaran == 'lunas') {
          totalBayar += t.totalTagihan;
          terbayar++;
        }
      }

      totalTahunIni.value = totalBayar;
      jumlahTerbayar.value = terbayar;
    } catch (e) {
      debugPrint('PaymentHistoryController.loadData error: $e');
      hasError.value = true;
      errorMessage.value = 'Terjadi kesalahan: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Parse tahun dari string bulan (bisa "2024-01" atau "Januari 2024")
  int? _parseTahun(String bulan) {
    try {
      // Format "YYYY-MM"
      if (RegExp(r'^\d{4}-\d{2}').hasMatch(bulan)) {
        return int.parse(bulan.substring(0, 4));
      }
      // Format "Januari 2024" atau "Jan 2024"
      final parts = bulan.trim().split(' ');
      if (parts.length >= 2) {
        return int.tryParse(parts.last);
      }
    } catch (_) {}
    return null;
  }

  /// Format angka ke Rupiah: 75000 → "Rp 75.000"
  String formatRupiah(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  /// Format bulan: "2024-01" → "Januari 2024"
  String formatBulan(String bulan) {
    try {
      if (RegExp(r'^\d{4}-\d{2}').hasMatch(bulan)) {
        final date = DateFormat('yyyy-MM').parse(bulan);
        return DateFormat('MMMM yyyy', 'id_ID').format(date);
      }
    } catch (_) {}
    return bulan;
  }

  /// Format tanggal bayar dari ISO string
  String formatTanggalBayar(String? tanggal) {
    if (tanggal == null || tanggal.isEmpty) return '-';
    try {
      final dt = DateTime.parse(tanggal).toLocal();
      return DateFormat('dd MMM yyyy', 'id_ID').format(dt);
    } catch (_) {
      return tanggal;
    }
  }
}
