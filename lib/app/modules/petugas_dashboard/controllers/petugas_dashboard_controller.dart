import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tirta_desa/app/data/models/petugas_dashboard_model.dart';
import 'package:tirta_desa/app/data/services/dashboard_service.dart';

class PetugasDashboardController extends GetxController {
  final _box = GetStorage();
  final _service = DashboardService();

  // Data user dari storage
  var userName = 'Petugas'.obs;
  var userEmail = ''.obs;

  // Data dashboard dari backend
  var totalPelanggan = 0.obs;
  var totalMeter = 0.obs;
  var komplainBaru = 0.obs;
  var pengajuanPemasanganBaru = 0.obs;
  var tagihanBelumLunas = 0.obs;

  var isLoading = false.obs;
  var hasError = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserFromStorage();
    fetchDashboardData();
  }

  void _loadUserFromStorage() {
    userName.value = _box.read('name') ?? 'Petugas';
    userEmail.value = _box.read('email') ?? '';
  }

  Future<void> fetchDashboardData() async {
    final token = _box.read('token');
    if (token == null) {
      debugPrint('PetugasDashboardController: token tidak ditemukan');
      return;
    }

    isLoading.value = true;
    hasError.value = false;

    try {
      final PetugasDashboardModel? data =
          await _service.fetchPetugasDashboard(token);

      if (data != null) {
        totalPelanggan.value = data.totalPelanggan;
        totalMeter.value = data.totalMeter;
        komplainBaru.value = data.komplainBaru;
        pengajuanPemasanganBaru.value = data.pengajuanPemasanganBaru;
        tagihanBelumLunas.value = data.tagihanBelumLunas;
      } else {
        hasError.value = true;
      }
    } catch (e) {
      debugPrint('fetchDashboardData error: $e');
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }
}