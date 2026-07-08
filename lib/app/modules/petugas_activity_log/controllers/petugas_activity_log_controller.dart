import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:tirta_desa/app/data/models/meter_model.dart';
import 'package:tirta_desa/app/data/services/meter_service.dart';

class PetugasActivityLog {
  final String title;
  final String description;
  final DateTime time;
  final PetugasActivityLogType type;

  PetugasActivityLog({
    required this.title,
    required this.description,
    required this.time,
    required this.type,
  });
}

enum PetugasActivityLogType { inputMeter, profile, login }

class PetugasActivityLogController extends GetxController {
  final _box = GetStorage();
  final _service = MeterService();

  // ── States ────────────────────────────────────
  var isLoading = false.obs;
  var hasError = false.obs;

  final RxList<PetugasActivityLog> logs = <PetugasActivityLog>[].obs;
  final RxString filterType = 'Semua'.obs;

  final List<String> filterOptions = [
    'Semua',
    'Catat Meter',
    'Profil',
    'Login',
  ];

  List<PetugasActivityLog> get filteredLogs {
    if (filterType.value == 'Semua') return logs;
    final map = {
      'Catat Meter': PetugasActivityLogType.inputMeter,
      'Profil': PetugasActivityLogType.profile,
      'Login': PetugasActivityLogType.login,
    };
    return logs.where((l) => l.type == map[filterType.value]).toList();
  }

  @override
  void onInit() {
    super.onInit();
    _loadLogs();
  }

  Future<void> _loadLogs() async {
    final token = _box.read('token');
    final userId = _box.read('id') ?? 0;
    final name = _box.read('name') ?? 'Petugas';

    if (token == null) return;

    isLoading.value = true;
    hasError.value = false;

    try {
      // 1. Fetch data dari backend
      final results = await Future.wait([
        _service.fetchPelanggan(token),
        _service.fetchMeter(token),
        _service.fetchCatatMeter(token),
      ]);

      final allPelanggan = results[0] as List<PelangganModel>;
      final allMeters = results[1] as List<MeterModel>;
      final allCatat = results[2] as List<CatatMeterModel>;

      final tempLogs = <PetugasActivityLog>[];

      // 2. Tambahkan log Login dari lokal
      final loginTimestamps = _box.read<List<dynamic>>("login_logs_$userId") ?? [];
      for (var ts in loginTimestamps) {
        try {
          final dt = DateTime.parse(ts.toString());
          tempLogs.add(PetugasActivityLog(
            title: 'Login Berhasil',
            description: 'Masuk ke aplikasi TirtaDesa sebagai petugas.',
            time: dt,
            type: PetugasActivityLogType.login,
          ));
        } catch (_) {}
      }

      // 3. Tambahkan log Profil dari lokal
      final profileTimestamps = _box.read<List<dynamic>>("profile_logs_$userId") ?? [];
      for (var ts in profileTimestamps) {
        try {
          final dt = DateTime.parse(ts.toString());
          tempLogs.add(PetugasActivityLog(
            title: 'Profil Diperbarui',
            description: 'Foto profil petugas berhasil diubah.',
            time: dt,
            type: PetugasActivityLogType.profile,
          ));
        } catch (_) {}
      }

      // 4. Tambahkan log Catat Meter dari backend
      final petugasCatat = allCatat
          .where((c) => c.petugasNama.toLowerCase().trim() == name.toLowerCase().trim())
          .toList();

      for (var c in petugasCatat) {
        final meter = allMeters.firstWhereOrNull((m) => m.id == c.meterId);
        final pelanggan = meter != null
            ? allPelanggan.firstWhereOrNull((p) => p.id == meter.pelangganId)
            : null;

        final customerName = pelanggan?.nama ?? 'Pelanggan #${c.meterId}';
        final noMeter = pelanggan?.noMeter ?? '-';

        DateTime logTime;
        if (c.createdAt != null) {
          logTime = c.createdAt!;
        } else {
          try {
            logTime = DateFormat('yyyy-MM').parse(c.bulan);
            // Set ke akhir bulan jika tidak ada created_at (untuk data lama)
            logTime = DateTime(logTime.year, logTime.month, 28, 12, 0);
          } catch (_) {
            logTime = DateTime.now();
          }
        }

        tempLogs.add(PetugasActivityLog(
          title: 'Input Meteran',
          description: 'Mencatat meteran pelanggan $customerName ($noMeter)\nAngka kini: ${c.angkaMeterKini.toStringAsFixed(2)} m³, pemakaian: ${c.penggunaanM3.toStringAsFixed(2)} m³',
          time: logTime,
          type: PetugasActivityLogType.inputMeter,
        ));
      }

      // 5. Urutkan berdasarkan waktu (terbaru dahulu)
      tempLogs.sort((a, b) => b.time.compareTo(a.time));

      logs.assignAll(tempLogs);
    } catch (e) {
      debugPrint('_loadLogs error: $e');
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshData() => _loadLogs();

  void setFilter(String filter) {
    filterType.value = filter;
  }
}
