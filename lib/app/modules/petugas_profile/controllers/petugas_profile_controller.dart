import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../../../routes/app_pages.dart';

class PetugasProfileController extends GetxController {
  final _box = GetStorage();

  // ── Session Data ──────────────────────────────
  var petugasId = 0.obs;
  var petugasNama = ''.obs;
  var petugasEmail = ''.obs;
  var petugasPhone = ''.obs;

  // ── Profile Photo ─────────────────────────────
  var profilePhotoPath = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadProfileData();
  }

  void _loadProfileData() {
    petugasId.value = _box.read('id') ?? 0;
    petugasNama.value = _box.read('name') ?? 'Agus Susanto';
    petugasEmail.value = _box.read('email') ?? 'agus.susanto@desa.id';
    petugasPhone.value = _box.read('phone') ?? '081234567890';

    // Load photo path specific to current user ID
    final savedPath = _box.read('petugas_profile_photo_${petugasId.value}') ?? '';
    if (savedPath.isNotEmpty && File(savedPath).existsSync()) {
      profilePhotoPath.value = savedPath;
    } else {
      profilePhotoPath.value = '';
    }
  }

  Future<void> changeProfilePhoto(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: source,
        imageQuality: 85,
      );

      if (picked != null) {
        // Save locally to storage
        _box.write('petugas_profile_photo_${petugasId.value}', picked.path);
        profilePhotoPath.value = picked.path;

        // Simpan log update profil ke lokal
        final profileLogs = _box.read<List<dynamic>>("profile_logs_${petugasId.value}") ?? [];
        profileLogs.add(DateTime.now().toIso8601String());
        _box.write("profile_logs_${petugasId.value}", profileLogs);

        Get.snackbar(
          'Berhasil',
          'Foto profil berhasil diperbarui',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xff0D47A1),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint('Error picking profile image: $e');
      Get.snackbar(
        'Gagal',
        'Gagal mengambil gambar',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void logout() {
    _box.erase();
    Get.offAllNamed(Routes.LOGIN);
  }
}