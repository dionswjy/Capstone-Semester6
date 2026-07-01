import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:tirta_desa/core/values/api.dart';
import '../../reports/controllers/reports_controller.dart';

class NewReportController extends GetxController {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final selectedCategory = "".obs;
  final isLoading = false.obs;
  final box = GetStorage();

  void selectCategory(String cat) => selectedCategory.value = cat;

  Future<void> submit() async {
    final category = selectedCategory.value;
    final description = descriptionController.text.trim();

    if (category.isEmpty) {
      Get.snackbar("Gagal", "Pilih kategori masalah terlebih dahulu",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (description.isEmpty) {
      Get.snackbar("Gagal", "Deskripsi masalah tidak boleh kosong",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final token = box.read("token");
    if (token == null) {
      Get.snackbar("Gagal", "Sesi Anda telah berakhir, silakan login kembali",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // Ambil pelanggan_id dari token/storage; jika belum tersimpan, fetch dulu dari /dashboard
    int? pelangganId = box.read("pelanggan_id");

    if (pelangganId == null) {
      // Coba ambil pelanggan_id dari backend dashboard
      try {
        final dashRes = await http.get(
          Uri.parse("${Api.baseUrl}/dashboard"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        );
        if (dashRes.statusCode == 200) {
          final dashData = jsonDecode(dashRes.body);
          pelangganId = dashData["pelanggan_id"];
          if (pelangganId != null) box.write("pelanggan_id", pelangganId);
        }
      } catch (_) {}
    }

    if (pelangganId == null) {
      Get.snackbar("Gagal", "Data pelanggan tidak ditemukan. Pastikan akun Anda sudah terdaftar sebagai pelanggan.",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isLoading.value = true;
    try {
      final response = await http.post(
        Uri.parse("${Api.baseUrl}/admin/komplain"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "pelanggan_id": pelangganId,
          "judul": category,
          "deskripsi": description,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        descriptionController.clear();
        selectedCategory.value = "";
        if (Get.isRegistered<ReportsController>()) {
          Get.find<ReportsController>().fetchReports();
        }
        Get.back();
        Get.snackbar("Sukses", data["message"] ?? "Laporan Anda telah terkirim.",
            snackPosition: SnackPosition.BOTTOM);
      } else {
        Get.snackbar("Gagal", data["detail"]?.toString() ?? "Gagal mengirim laporan",
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar("Error", "Tidak dapat terhubung ke server",
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}

