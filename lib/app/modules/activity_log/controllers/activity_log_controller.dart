import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:tirta_desa/app/data/services/activity_log_service.dart';

// ─────────────────────────────────────────────
// Model
// ─────────────────────────────────────────────

enum ActivityLogType { payment, report, profile, meter, login }

class ActivityLog {
  final String title;
  final String description;
  final DateTime time;
  final ActivityLogType type;

  ActivityLog({
    required this.title,
    required this.description,
    required this.time,
    required this.type,
  });
}

// ─────────────────────────────────────────────
// Controller
// ─────────────────────────────────────────────

class ActivityLogController extends GetxController {
  final _box = GetStorage();
  final _service = ActivityLogService();

  final RxList<ActivityLog> logs = <ActivityLog>[].obs;
  final RxString filterType = 'Semua'.obs;
  var isLoading = false.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;

  final List<String> filterOptions = [
    'Semua',
    'Pembayaran',
    'Laporan',
    'Profil',
    'Meteran',
    'Login',
  ];

  List<ActivityLog> get filteredLogs {
    if (filterType.value == 'Semua') return logs;
    final map = {
      'Pembayaran': ActivityLogType.payment,
      'Laporan': ActivityLogType.report,
      'Profil': ActivityLogType.profile,
      'Meteran': ActivityLogType.meter,
      'Login': ActivityLogType.login,
    };
    return logs.where((l) => l.type == map[filterType.value]).toList();
  }

  @override
  void onInit() {
    super.onInit();
    loadActivityLogs();
  }

  Future<void> loadActivityLogs() async {
    final token = _box.read('token');
    if (token == null) {
      hasError.value = true;
      errorMessage.value = 'Silakan login terlebih dahulu';
      return;
    }

    isLoading.value = true;
    hasError.value = false;
    final collected = <ActivityLog>[];

    try {
      // 1. Ambil dashboard → dapat pelanggan_id dan info dasar
      final dashboard = await _service.fetchDashboard(token);
      if (dashboard == null) {
        hasError.value = true;
        errorMessage.value = 'Gagal memuat data. Periksa koneksi internet.';
        return;
      }

      final pelangganId = dashboard['pelanggan_id'];

      // 2. Tambah log "sesi aktif" (login hari ini dari storage)
      collected.add(ActivityLog(
        title: 'Login Berhasil',
        description:
            'Masuk sebagai ${dashboard['nama'] ?? _box.read('name') ?? 'Pengguna'}',
        time: DateTime.now().subtract(const Duration(minutes: 1)),
        type: ActivityLogType.login,
      ));

      if (pelangganId != null) {
        // 3. Cari meter_id
        final meterId =
            await _service.fetchMeterIdByPelanggan(token, pelangganId);

        if (meterId != null) {
          // 4. Riwayat pembayaran tagihan
          final tagihans = await _service.fetchTagihanByMeter(token, meterId);
          for (final t in tagihans) {
            final status = (t['status_pembayaran'] ?? '').toString();
            final total = (t['total_tagihan'] ?? 0).toDouble();
            final bulan = t['bulan'] ?? '-';
            final tanggalBayar = t['tanggal_bayar'];

            // Hanya tampilkan tagihan yang sudah lunas sebagai aktivitas pembayaran
            if (status == 'lunas' && tanggalBayar != null) {
              DateTime? tgl;
              try {
                tgl = DateTime.parse(tanggalBayar.toString()).toLocal();
              } catch (_) {}

              collected.add(ActivityLog(
                title: 'Pembayaran Tagihan',
                description:
                    'Pembayaran tagihan ${_formatBulan(bulan)} berhasil\n${_formatRupiah(total)}',
                time: tgl ?? DateTime.now(),
                type: ActivityLogType.payment,
              ));
            } else if (status == 'belum_lunas') {
              // Tagihan belum lunas → log sebagai notifikasi meteran
              DateTime? tgl;
              if (t['created_at'] != null) {
                try {
                  tgl = DateTime.parse(t['created_at'].toString()).toLocal();
                } catch (_) {}
              }
              collected.add(ActivityLog(
                title: 'Tagihan Baru',
                description:
                    'Tagihan ${_formatBulan(bulan)} sebesar ${_formatRupiah(total)} belum dibayar',
                time: tgl ?? DateTime.now(),
                type: ActivityLogType.payment,
              ));
            }
          }

          // 5. Riwayat pencatatan meter
          final catatans =
              await _service.fetchCatatMeterByMeter(token, meterId);
          for (final c in catatans) {
            final bulan = c['bulan'] ?? '-';
            final penggunaan = (c['penggunaan_m3'] ?? 0).toDouble();
            final petugas = c['petugas_nama'] ?? 'Petugas';

            DateTime? tgl;
            if (c['created_at'] != null) {
              try {
                tgl = DateTime.parse(c['created_at'].toString()).toLocal();
              } catch (_) {}
            }

            collected.add(ActivityLog(
              title: 'Meter Dicatat',
              description:
                  'Meteran bulan ${_formatBulan(bulan)} dicatat oleh $petugas\nPenggunaan: ${penggunaan.toStringAsFixed(1)} m³',
              time: tgl ?? DateTime.now(),
              type: ActivityLogType.meter,
            ));
          }
        }

        // 6. Riwayat laporan/komplain
        final komplains =
            await _service.fetchKomplainByPelanggan(token, pelangganId);
        for (final k in komplains) {
          final judul = k['judul'] ?? 'Laporan';
          final status = k['status'] ?? 'pending';
          final deskripsi = k['deskripsi'] ?? '';

          DateTime? tgl;
          if (k['created_at'] != null) {
            try {
              tgl = DateTime.parse(k['created_at'].toString()).toLocal();
            } catch (_) {}
          }

          collected.add(ActivityLog(
            title: 'Laporan Dikirim',
            description:
                '$judul\nStatus: ${_formatStatus(status)}\n$deskripsi',
            time: tgl ?? DateTime.now(),
            type: ActivityLogType.report,
          ));
        }
      }

      // Urutkan dari yang terbaru
      collected.sort((a, b) => b.time.compareTo(a.time));
      logs.assignAll(collected);
    } catch (e) {
      debugPrint('ActivityLogController.loadActivityLogs error: $e');
      hasError.value = true;
      errorMessage.value = 'Terjadi kesalahan: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void setFilter(String filter) {
    filterType.value = filter;
  }

  // ─── Helpers ─────────────────────────────
  String _formatBulan(String bulan) {
    try {
      if (RegExp(r'^\d{4}-\d{2}').hasMatch(bulan)) {
        final date = DateFormat('yyyy-MM').parse(bulan);
        return DateFormat('MMMM yyyy', 'id_ID').format(date);
      }
    } catch (_) {}
    return bulan;
  }

  String _formatRupiah(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  String _formatStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Dalam Proses';
      case 'resolved':
        return 'Selesai';
      case 'rejected':
        return 'Ditolak';
      default:
        return status;
    }
  }
}
