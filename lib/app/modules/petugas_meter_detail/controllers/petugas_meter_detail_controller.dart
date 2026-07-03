import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:tirta_desa/app/data/models/meter_model.dart';
import 'package:tirta_desa/app/data/services/meter_service.dart';

class PetugasMeterDetailController extends GetxController {
  final _box = GetStorage();
  final _service = MeterService();

  // ── Data pelanggan dari arguments ──────────────
  late final PelangganModel pelanggan;

  // ── Data meter, catatan, tagihan dari backend ──
  var meterList = <MeterModel>[].obs;
  var catatList = <CatatMeterModel>[].obs;
  var tagihanList = <TagihanModel>[].obs;

  // ── Computed state ─────────────────────────────
  var meterPelanggan = Rxn<MeterModel>();
  var riwayatCatat = <CatatMeterModel>[].obs;
  var indexTerkini = 0.0.obs;
  var rataRataBulanan = 0.0.obs;
  var statusPembayaran = ''.obs;

  // ── UI state ───────────────────────────────────
  var isLoading = false.obs;
  var hasError = false.obs;

  // Formatter mata uang
  final _currencyFmt = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  String formatRupiah(double amount) => _currencyFmt.format(amount);

  /// Format "YYYY-MM" → "Januari 2025"
  String formatBulan(String bulan) {
    try {
      final dt = DateFormat('yyyy-MM').parse(bulan);
      return DateFormat('MMMM yyyy', 'id_ID').format(dt);
    } catch (_) {
      return bulan;
    }
  }

  @override
  void onInit() {
    super.onInit();
    // Ambil argument pelanggan dari navigasi
    if (Get.arguments != null && Get.arguments is PelangganModel) {
      pelanggan = Get.arguments as PelangganModel;
    } else {
      // Fallback jika tidak ada argument
      pelanggan = PelangganModel(
        id: 0,
        userId: 0,
        nama: 'Pelanggan',
        alamat: '-',
        noMeter: '-',
        kategori: '-',
        noHp: '-',
        nik: '-',
        statusPelanggan: '-',
        jenisPelanggan: '-',
      );
    }
    _loadData();
  }

  Future<void> _loadData() async {
    final token = _box.read('token');
    if (token == null) return;

    isLoading.value = true;
    hasError.value = false;

    try {
      final results = await Future.wait([
        _service.fetchMeter(token),
        _service.fetchCatatMeter(token),
        _service.fetchTagihan(token),
      ]);

      meterList.assignAll(results[0] as List<MeterModel>);
      catatList.assignAll(results[1] as List<CatatMeterModel>);
      tagihanList.assignAll(results[2] as List<TagihanModel>);

      _computeData();
    } catch (e) {
      debugPrint('_loadData error: $e');
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshData() => _loadData();

  void _computeData() {
    // Cari meter milik pelanggan ini
    final meter = meterList.firstWhereOrNull(
      (m) => m.pelangganId == pelanggan.id,
    );
    meterPelanggan.value = meter;

    if (meter == null) {
      riwayatCatat.clear();
      indexTerkini.value = 0.0;
      rataRataBulanan.value = 0.0;
      statusPembayaran.value = 'Tidak Ada Data';
      return;
    }

    // Riwayat pencatatan meter untuk meter ini, diurutkan terbaru dulu
    final catatan = catatList
        .where((c) => c.meterId == meter.id)
        .toList()
      ..sort((a, b) => b.id.compareTo(a.id));

    riwayatCatat.assignAll(catatan);

    // Index meter terkini
    indexTerkini.value =
        catatan.isNotEmpty ? catatan.first.angkaMeterKini : 0.0;

    // Rata-rata bulanan (dari penggunaan_m3 semua catatan)
    if (catatan.isNotEmpty) {
      final totalUsage =
          catatan.fold(0.0, (sum, c) => sum + c.penggunaanM3);
      rataRataBulanan.value = totalUsage / catatan.length;
    } else {
      rataRataBulanan.value = 0.0;
    }

    // Status pembayaran tagihan terbaru untuk meter ini
    final tagihanMeter = tagihanList
        .where((t) => t.meterId == meter.id)
        .toList()
      ..sort((a, b) => b.id.compareTo(a.id));

    if (tagihanMeter.isNotEmpty) {
      final status = tagihanMeter.first.statusPembayaran;
      statusPembayaran.value = status;
    } else {
      statusPembayaran.value = 'Belum Ada Tagihan';
    }
  }
}
