import 'package:get/get.dart';

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

enum ActivityLogType { payment, report, profile, meter, login }

class ActivityLogController extends GetxController {
  final RxList<ActivityLog> logs = <ActivityLog>[].obs;
  final RxString filterType = 'Semua'.obs;

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
    _loadDummyLogs();
  }

  void _loadDummyLogs() {
    final now = DateTime.now();
    logs.assignAll([
      ActivityLog(
        title: 'Login Berhasil',
        description: 'Masuk ke aplikasi dari perangkat Android',
        time: now.subtract(const Duration(minutes: 10)),
        type: ActivityLogType.login,
      ),
      ActivityLog(
        title: 'Pembayaran Tagihan',
        description: 'Pembayaran tagihan bulan Juni 2025 berhasil\nRp 45.000',
        time: now.subtract(const Duration(hours: 2)),
        type: ActivityLogType.payment,
      ),
      ActivityLog(
        title: 'Laporan Dikirim',
        description: 'Laporan kebocoran pipa di Jl. Melati No. 12',
        time: now.subtract(const Duration(hours: 5)),
        type: ActivityLogType.report,
      ),
      ActivityLog(
        title: 'Data Profil Diperbarui',
        description: 'Nomor telepon diubah ke 0812 3456 7890',
        time: now.subtract(const Duration(days: 1)),
        type: ActivityLogType.profile,
      ),
      ActivityLog(
        title: 'Login Berhasil',
        description: 'Masuk ke aplikasi dari perangkat Android',
        time: now.subtract(const Duration(days: 1, hours: 8)),
        type: ActivityLogType.login,
      ),
      ActivityLog(
        title: 'Cek Meteran',
        description: 'Melihat riwayat penggunaan meteran TD-MET-88291',
        time: now.subtract(const Duration(days: 2)),
        type: ActivityLogType.meter,
      ),
      ActivityLog(
        title: 'Pembayaran Tagihan',
        description: 'Pembayaran tagihan bulan Mei 2025 berhasil\nRp 42.000',
        time: now.subtract(const Duration(days: 3)),
        type: ActivityLogType.payment,
      ),
      ActivityLog(
        title: 'Laporan Dikirim',
        description: 'Laporan air keruh di Dusun Krajan',
        time: now.subtract(const Duration(days: 5)),
        type: ActivityLogType.report,
      ),
      ActivityLog(
        title: 'Login Berhasil',
        description: 'Masuk ke aplikasi dari perangkat Android',
        time: now.subtract(const Duration(days: 7)),
        type: ActivityLogType.login,
      ),
    ]);
  }

  void setFilter(String filter) {
    filterType.value = filter;
  }
}
