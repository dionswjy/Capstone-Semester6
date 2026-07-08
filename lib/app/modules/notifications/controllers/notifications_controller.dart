import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:tirta_desa/core/values/api.dart';

// ─────────────────────────────────────────────
// Model Notifikasi
// ─────────────────────────────────────────────

enum NotifType { tagihan, komplain, meter, info }

class AppNotification {
  final String title;
  final String body;
  final DateTime time;
  final NotifType type;
  bool isRead;

  AppNotification({
    required this.title,
    required this.body,
    required this.time,
    required this.type,
    this.isRead = false,
  });
}

// ─────────────────────────────────────────────
// Controller
// ─────────────────────────────────────────────

class NotificationsController extends GetxController {
  final _box = GetStorage();
  final String _baseUrl = Api.baseUrl;

  var notifications = <AppNotification>[].obs;
  var isLoading = false.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  Map<String, String> _headers(String token) => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    final token = _box.read('token');
    if (token == null) {
      hasError.value = true;
      errorMessage.value = 'Silakan login terlebih dahulu';
      return;
    }

    isLoading.value = true;
    hasError.value = false;
    final collected = <AppNotification>[];

    try {
      // Step 1: Ambil dashboard → pelanggan_id
      final dashRes = await http.get(
        Uri.parse('$_baseUrl/dashboard'),
        headers: _headers(token),
      );
      if (dashRes.statusCode != 200) {
        hasError.value = true;
        errorMessage.value = 'Gagal memuat data. Periksa koneksi internet.';
        return;
      }
      final dashboard = jsonDecode(dashRes.body) as Map<String, dynamic>;
      final pelangganId = dashboard['pelanggan_id'];

      if (pelangganId != null) {
        // Step 2: Cari meter_id
        final meterRes = await http.get(
          Uri.parse('$_baseUrl/meter'),
          headers: _headers(token),
        );
        int? meterId;
        if (meterRes.statusCode == 200) {
          final body = jsonDecode(meterRes.body);
          final list = (body['data'] ?? body) as List<dynamic>;
          for (final m in list) {
            if ((m['pelanggan_id'] ?? 0) == pelangganId) {
              meterId = m['id'] as int;
              break;
            }
          }
        }

        // Step 3: Notifikasi dari tagihan
        if (meterId != null) {
          final tagihanRes = await http.get(
            Uri.parse('$_baseUrl/admin/tagihan'),
            headers: _headers(token),
          );
          if (tagihanRes.statusCode == 200) {
            final body = jsonDecode(tagihanRes.body);
            final list = (body['data'] ?? body) as List<dynamic>;
            final myTagihan =
                list.where((t) => (t['meter_id'] ?? 0) == meterId).toList();

            for (final t in myTagihan) {
              final status = (t['status_pembayaran'] ?? '').toString();
              final total = (t['total_tagihan'] ?? 0).toDouble();
              final bulan = t['bulan']?.toString() ?? '-';

              if (status == 'belum_lunas') {
                collected.add(AppNotification(
                  title: '⚠️ Tagihan Belum Lunas',
                  body:
                      'Tagihan bulan ${_formatBulan(bulan)} sebesar ${_formatRupiah(total)} belum dibayar. Segera lakukan pembayaran.',
                  time: DateTime.now().subtract(const Duration(hours: 1)),
                  type: NotifType.tagihan,
                  isRead: false,
                ));
              } else if (status == 'lunas') {
                final tanggal = t['tanggal_bayar']?.toString();
                collected.add(AppNotification(
                  title: '✅ Pembayaran Dikonfirmasi',
                  body:
                      'Tagihan bulan ${_formatBulan(bulan)} sebesar ${_formatRupiah(total)} telah lunas${tanggal != null ? ' pada ${_formatTanggal(tanggal)}' : ''}.',
                  time: tanggal != null
                      ? _parseDate(tanggal)
                      : DateTime.now().subtract(const Duration(days: 1)),
                  type: NotifType.tagihan,
                  isRead: true,
                ));
              }
            }
          }

          // Step 4: Notifikasi dari catatan meter
          final catatRes = await http.get(
            Uri.parse('$_baseUrl/catat-meter'),
            headers: _headers(token),
          );
          if (catatRes.statusCode == 200) {
            final body = jsonDecode(catatRes.body);
            final list = (body['data'] ?? body) as List<dynamic>;
            final myMeter =
                list.where((c) => (c['meter_id'] ?? 0) == meterId).toList();

            for (final c in myMeter) {
              final bulan = c['bulan']?.toString() ?? '-';
              final penggunaan = (c['penggunaan_m3'] ?? 0).toDouble();
              final petugas = c['petugas_nama']?.toString() ?? 'Petugas';

              collected.add(AppNotification(
                title: '📊 Meteran Dicatat',
                body:
                    'Meteran bulan ${_formatBulan(bulan)} telah dicatat oleh $petugas. Penggunaan: ${penggunaan.toStringAsFixed(1)} m³.',
                time: DateTime.now().subtract(const Duration(days: 2)),
                type: NotifType.meter,
                isRead: true,
              ));
            }
          }
        }

        // Step 5: Notifikasi dari komplain
        final komplainRes = await http.get(
          Uri.parse('$_baseUrl/admin/komplain'),
          headers: _headers(token),
        );
        if (komplainRes.statusCode == 200) {
          final body = jsonDecode(komplainRes.body);
          final list = (body['data'] ?? body) as List<dynamic>;
          final myKomplain = list
              .where((k) => (k['pelanggan_id'] ?? 0) == pelangganId)
              .toList();

          for (final k in myKomplain) {
            final judul = k['judul']?.toString() ?? 'Laporan';
            final status = (k['status'] ?? 'pending').toString();

            if (status == 'resolved') {
              collected.add(AppNotification(
                title: '✅ Laporan Selesai',
                body:
                    'Laporan "$judul" telah ditangani oleh tim kami. Terima kasih telah melapor.',
                time: DateTime.now().subtract(const Duration(days: 1)),
                type: NotifType.komplain,
                isRead: false,
              ));
            } else if (status == 'pending') {
              collected.add(AppNotification(
                title: '🕐 Laporan Dalam Proses',
                body:
                    'Laporan "$judul" sedang diproses oleh tim kami. Mohon tunggu.',
                time: DateTime.now().subtract(const Duration(days: 3)),
                type: NotifType.komplain,
                isRead: true,
              ));
            }
          }
        }
      }

      // Urutkan: belum dibaca dulu, lalu dari terbaru
      collected.sort((a, b) {
        if (a.isRead != b.isRead) return a.isRead ? 1 : -1;
        return b.time.compareTo(a.time);
      });

      notifications.assignAll(collected);
    } catch (e) {
      debugPrint('NotificationsController.loadNotifications: $e');
      hasError.value = true;
      errorMessage.value = 'Terjadi kesalahan: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Tandai semua sebagai sudah dibaca
  void markAllRead() {
    for (final n in notifications) {
      n.isRead = true;
    }
    notifications.refresh();
  }

  /// Tandai satu notifikasi sebagai sudah dibaca
  void markRead(AppNotification notif) {
    notif.isRead = true;
    notifications.refresh();
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
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(amount);
  }

  String _formatTanggal(String iso) {
    try {
      final dt = DateTime.parse(iso).toLocal();
      return DateFormat('dd MMM yyyy', 'id_ID').format(dt);
    } catch (_) {
      return iso;
    }
  }

  DateTime _parseDate(String iso) {
    try {
      return DateTime.parse(iso).toLocal();
    } catch (_) {
      return DateTime.now();
    }
  }
}