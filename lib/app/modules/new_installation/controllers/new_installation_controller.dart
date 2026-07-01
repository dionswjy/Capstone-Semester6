import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:tirta_desa/core/values/api.dart';

class NewInstallationController extends GetxController {
  final nameController = TextEditingController();
  final nikController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  final selectedCategory = "Rumah".obs;
  final isLoading = false.obs;
  final box = GetStorage();

  final String baseUrl = Api.baseUrl;

  void selectCategory(String cat) => selectedCategory.value = cat;

  Future<void> submit() async {
    final name = nameController.text.trim();
    final nik = nikController.text.trim();
    final phone = phoneController.text.trim();
    final address = addressController.text.trim();
    final category = selectedCategory.value;

    if (name.isEmpty || nik.isEmpty || phone.isEmpty || address.isEmpty) {
      Get.snackbar(
        "Gagal",
        "Semua kolom wajib diisi",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final token = box.read("token");
    if (token == null) {
      Get.snackbar(
        "Gagal",
        "Sesi Anda telah berakhir, silakan login kembali",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/admin/pemasangan-baru"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "nama": name,
          "nik": nik,
          "no_hp": phone,
          "alamat": address,
          "jenis_pelanggan": category,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back();
        Get.snackbar(
          "Berhasil",
          data["message"] ?? "Pengajuan pemasangan baru Anda berhasil dikirim.",
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          "Gagal",
          data["detail"]?.toString() ?? "Gagal mengirim pengajuan",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Tidak dapat terhubung ke server",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    nikController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.onClose();
  }
}

