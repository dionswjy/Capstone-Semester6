import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
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

  // GPS / Lokasi
  RxDouble currentLat = (-7.003292).obs;
  RxDouble currentLng = (109.054250).obs;
  var isLocating = false.obs;
  var locationError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserFromStorage();
    fetchDashboardData();
    fetchCurrentLocation();
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

  /// Ambil koordinat GPS petugas saat ini
  Future<void> fetchCurrentLocation() async {
    isLocating.value = true;
    locationError.value = '';

    try {
      // 1. Cek apakah layanan lokasi aktif
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        locationError.value = 'GPS tidak aktif di perangkat';
        isLocating.value = false;
        return;
      }

      // 2. Cek & minta izin
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          locationError.value = 'Izin lokasi ditolak';
          isLocating.value = false;
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        locationError.value = 'Izin lokasi diblokir. Buka Pengaturan untuk mengaktifkan.';
        isLocating.value = false;
        return;
      }

      // 3. Ambil posisi
      final Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );

      currentLat.value = position.latitude;
      currentLng.value = position.longitude;
      debugPrint('GPS: ${position.latitude}, ${position.longitude}');
    } catch (e) {
      locationError.value = 'Gagal ambil lokasi: $e';
      debugPrint('fetchCurrentLocation error: $e');
    } finally {
      isLocating.value = false;
    }
  }
}