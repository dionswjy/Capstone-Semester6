import 'package:get/get.dart';

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

enum PetugasActivityLogType { inputMeter, pengaduan, pelanggan, profile, login }

class PetugasActivityLogController extends GetxController {
  final RxList<PetugasActivityLog> logs = <PetugasActivityLog>[].obs;
  final RxString filterType = 'Semua'.obs;

  final List<String> filterOptions = [
    'Semua',
    'Input Meter',
    'Pengaduan',
    'Pelanggan',
    'Profil',
    'Login',
  ];

  List<PetugasActivityLog> get filteredLogs {
    if (filterType.value == 'Semua') return logs;
    final map = {
      'Input Meter': PetugasActivityLogType.inputMeter,
      'Pengaduan': PetugasActivityLogType.pengaduan,
      'Pelanggan': PetugasActivityLogType.pelanggan,
      'Profil': PetugasActivityLogType.profile,
      'Login': PetugasActivityLogType.login,
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
      PetugasActivityLog(
        title: 'Login Berhasil',
        description: 'Masuk ke aplikasi dari perangkat Android',
        time: now.subtract(const Duration(minutes: 5)),
        type: PetugasActivityLogType.login,
      ),
      PetugasActivityLog(
        title: 'Input Meteran',
        description: 'Catat meteran pelanggan Budi Santoso (TD-MET-88291)\nPenggunaan: 12 m³',
        time: now.subtract(const Duration(hours: 1)),
        type: PetugasActivityLogType.inputMeter,
      ),
      PetugasActivityLog(
        title: 'Pengaduan Ditangani',
        description: 'Pengaduan kebocoran pipa di Jl. Melati No. 12 selesai ditangani',
        time: now.subtract(const Duration(hours: 3)),
        type: PetugasActivityLogType.pengaduan,
      ),
      PetugasActivityLog(
        title: 'Input Meteran',
        description: 'Catat meteran pelanggan Siti Rahayu (TD-MET-77382)\nPenggunaan: 8 m³',
        time: now.subtract(const Duration(hours: 4)),
        type: PetugasActivityLogType.inputMeter,
      ),
      PetugasActivityLog(
        title: 'Data Pelanggan Dilihat',
        description: 'Lihat detail pelanggan Ahmad Fauzi (TD-2024-015)',
        time: now.subtract(const Duration(days: 1)),
        type: PetugasActivityLogType.pelanggan,
      ),
      PetugasActivityLog(
        title: 'Login Berhasil',
        description: 'Masuk ke aplikasi dari perangkat Android',
        time: now.subtract(const Duration(days: 1, hours: 7)),
        type: PetugasActivityLogType.login,
      ),
      PetugasActivityLog(
        title: 'Input Meteran',
        description: 'Catat meteran pelanggan Rudi Hartono (TD-MET-66210)\nPenggunaan: 15 m³',
        time: now.subtract(const Duration(days: 2)),
        type: PetugasActivityLogType.inputMeter,
      ),
      PetugasActivityLog(
        title: 'Pengaduan Ditangani',
        description: 'Pengaduan air keruh di Dusun Krajan dalam proses penanganan',
        time: now.subtract(const Duration(days: 3)),
        type: PetugasActivityLogType.pengaduan,
      ),
      PetugasActivityLog(
        title: 'Data Profil Diperbarui',
        description: 'Nomor telepon diubah ke 0812 3456 7890',
        time: now.subtract(const Duration(days: 5)),
        type: PetugasActivityLogType.profile,
      ),
      PetugasActivityLog(
        title: 'Login Berhasil',
        description: 'Masuk ke aplikasi dari perangkat Android',
        time: now.subtract(const Duration(days: 7)),
        type: PetugasActivityLogType.login,
      ),
    ]);
  }

  void setFilter(String filter) {
    filterType.value = filter;
  }
}
