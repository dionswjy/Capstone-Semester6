import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:tirta_desa/app/data/models/meter_model.dart';
import 'package:tirta_desa/app/data/services/meter_service.dart';
import '../views/meter_crop_view.dart';

class PetugasInputMeterController extends GetxController {
  final _box = GetStorage();
  final _service = MeterService();

  // ── Data pelanggan dari argument ────────────────
  late final PelangganModel pelanggan;

  // ── State user ──────────────────────────────────
  var petugasNama = 'Petugas'.obs;

  // ── Daftar data dari backend ────────────────────
  var meterList = <MeterModel>[].obs;
  var catatList = <CatatMeterModel>[].obs;

  // ── Meter yang ditemukan untuk pelanggan ini ────
  var selectedMeter = Rxn<MeterModel>();

  // ── Input form ──────────────────────────────────
  final angkaMeterKiniCtrl = TextEditingController();
  final angkaMeterLaluCtrl = TextEditingController();
  var angkaMeterLalu = 0.0.obs;
  var penggunaan = 0.0.obs;

  // ── UI state ─────────────────────────────────────
  var isLoadingData = false.obs;
  var isSaving = false.obs;
  var isScanning = false.obs;
  var hasError = false.obs;

  // Bulan aktif format: "YYYY-MM"
  String get bulanAktif =>
      DateFormat('yyyy-MM').format(DateTime.now());

  @override
  void onInit() {
    super.onInit();
    petugasNama.value = _box.read('name') ?? 'Petugas';

    // Ambil pelanggan dari argument navigasi
    if (Get.arguments != null && Get.arguments is PelangganModel) {
      pelanggan = Get.arguments as PelangganModel;
    } else {
      // Fallback jika tidak ada argument (seharusnya tidak terjadi)
      pelanggan = PelangganModel(
        id: 0, userId: 0, nama: '-', alamat: '-', noMeter: '-',
        kategori: '-', noHp: '-', nik: '-',
        statusPelanggan: '-', jenisPelanggan: '-',
      );
    }

    _loadData();
    angkaMeterKiniCtrl.addListener(_hitungPenggunaan);
  }

  @override
  void onClose() {
    angkaMeterKiniCtrl.removeListener(_hitungPenggunaan);
    angkaMeterKiniCtrl.dispose();
    angkaMeterLaluCtrl.dispose();
    super.onClose();
  }

  // ─────────────────────────────────────────────
  // LOAD DATA
  // ─────────────────────────────────────────────

  Future<void> _loadData() async {
    final token = _box.read('token');
    if (token == null) return;

    isLoadingData.value = true;
    hasError.value = false;

    try {
      final results = await Future.wait([
        _service.fetchMeter(token),
        _service.fetchCatatMeter(token),
      ]);

      meterList.assignAll(results[0] as List<MeterModel>);
      catatList.assignAll(results[1] as List<CatatMeterModel>);

      // Otomatis cari meter milik pelanggan ini
      final meter = meterList.firstWhereOrNull(
        (m) => m.pelangganId == pelanggan.id,
      );
      if (meter != null) {
        _setupMeter(meter);
      }
    } catch (e) {
      debugPrint('_loadData error: $e');
      hasError.value = true;
    } finally {
      isLoadingData.value = false;
    }
  }

  Future<void> refreshData() => _loadData();

  // ─────────────────────────────────────────────
  // SETUP METER & LOAD METER LALU
  // ─────────────────────────────────────────────

  void _setupMeter(MeterModel meter) {
    selectedMeter.value = meter;
    angkaMeterKiniCtrl.clear();
    penggunaan.value = 0.0;

    // Cari catatan terakhir → angka meter lalu
    final catatanMeter = catatList
        .where((c) => c.meterId == meter.id)
        .toList()
      ..sort((a, b) => b.id.compareTo(a.id));

    if (catatanMeter.isNotEmpty) {
      angkaMeterLalu.value = catatanMeter.first.angkaMeterKini;
    } else {
      angkaMeterLalu.value = 0.0;
    }
    angkaMeterLaluCtrl.text = angkaMeterLalu.value.toStringAsFixed(2);
  }

  // ─────────────────────────────────────────────
  // HITUNG PENGGUNAAN
  // ─────────────────────────────────────────────

  void _hitungPenggunaan() {
    final kiniStr = angkaMeterKiniCtrl.text.trim();
    if (kiniStr.isEmpty) {
      penggunaan.value = 0.0;
      return;
    }
    final kini = double.tryParse(kiniStr) ?? 0.0;
    final lalu = angkaMeterLalu.value;
    penggunaan.value = (kini - lalu).clamp(0.0, double.infinity);
  }

  // ─────────────────────────────────────────────
  // SIMPAN KE BACKEND
  // ─────────────────────────────────────────────

  Future<void> simpanMeter() async {
    if (selectedMeter.value == null) {
      Get.snackbar(
        'Perhatian',
        'Data meter tidak ditemukan untuk pelanggan ini',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    final kiniStr = angkaMeterKiniCtrl.text.trim();
    if (kiniStr.isEmpty) {
      Get.snackbar(
        'Perhatian',
        'Masukkan angka meteran saat ini',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    final kini = double.tryParse(kiniStr);
    if (kini == null) {
      Get.snackbar(
        'Perhatian',
        'Angka meteran tidak valid',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    if (kini < angkaMeterLalu.value) {
      Get.snackbar(
        'Perhatian',
        'Meteran saat ini tidak boleh lebih kecil dari bulan lalu',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    final token = _box.read('token');
    if (token == null) return;

    isSaving.value = true;

    final berhasil = await _service.simpanCatatMeter(
      token: token,
      meterId: selectedMeter.value!.id,
      bulan: bulanAktif,
      petugasNama: petugasNama.value,
      angkaMeterLalu: angkaMeterLalu.value,
      angkaMeterKini: kini,
      penggunaanM3: penggunaan.value,
    );

    isSaving.value = false;

    if (berhasil) {
      Get.snackbar(
        'Berhasil',
        'Data meteran berhasil disimpan',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xff007BFF),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      Get.back();
    } else {
      Get.snackbar(
        'Gagal',
        'Terjadi kesalahan saat menyimpan data',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // ─────────────────────────────────────────────
  // SCAN METER (OCR)
  // ─────────────────────────────────────────────

  Future<void> scanMeterFromCamera() => _pickAndScan(ImageSource.camera);
  Future<void> scanMeterFromGallery() => _pickAndScan(ImageSource.gallery);

  Future<void> _pickAndScan(ImageSource source) async {
    final token = _box.read('token');
    if (token == null) return;

    final picker = ImagePicker();
    final XFile? picked = await picker.pickImage(
      source: source,
      imageQuality: 90,
    );
    if (picked == null) return;

    isScanning.value = true;

    try {
      // Buka halaman pangkas terlebih dahulu
      final String? croppedPath = await Get.to<String>(() => MeterCropView(imagePath: picked.path));
      if (croppedPath == null) {
        isScanning.value = false;
        return;
      }

      final result = await _service.scanMeter(
        token: token,
        imageFile: File(croppedPath),
      );

      if (result != null && result.isNotEmpty) {
        angkaMeterKiniCtrl.text = result;
        _hitungPenggunaan();
        Get.snackbar(
          'Scan Berhasil',
          'Angka meter terdeteksi: $result',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xff007BFF),
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      } else {
        Get.snackbar(
          'Scan Gagal',
          'Angka meter tidak dapat dibaca. Coba foto yang lebih jelas.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint('_pickAndScan error: $e');
      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat scan',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isScanning.value = false;
    }
  }
}
