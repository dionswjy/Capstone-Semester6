import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:tirta_desa/app/routes/app_pages.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tirta_desa/core/values/api.dart';

class LoginController extends GetxController {
  final box = GetStorage();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isPasswordVisible = false.obs;
  final isLoading = false.obs;

  final String baseUrl = Api.baseUrl;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        "Gagal",
        "Email dan password wajib diisi",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {

    final user = data["user"];

    box.write("token", data["access_token"]);
    box.write("id", user["id"]);
    box.write("name", user["name"]);
    box.write("email", user["email"]);
    box.write("phone", user["phone"]);
    box.write("role", user["role"]);

    final role = user["role"];

    // Ambil pelanggan_id di background (tidak block login)
    _fetchAndSavePelangganId(user["id"], data["access_token"]);

    Get.snackbar(
      "Berhasil",
      data["message"] ?? "Login berhasil",
      snackPosition: SnackPosition.BOTTOM,
    );

    if (role == "petugas") {
      Get.offAllNamed(Routes.PETUGAS_DASHBOARD);
    } else {
      Get.offAllNamed(Routes.DASHBOARD);
    }
} else {
        Get.snackbar(
          "Login Gagal",
          data["detail"]?.toString() ?? "Email atau password salah",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Tidak bisa terhubung ke server",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Cari pelanggan_id berdasarkan user_id lalu simpan ke storage
  Future<void> _fetchAndSavePelangganId(int userId, String token) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/pelanggan"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      if (response.statusCode == 200) {
        final List list = jsonDecode(response.body);
        for (final item in list) {
          if (item["user_id"] == userId) {
            box.write("pelanggan_id", item["id"]);
            break;
          }
        }
      }
    } catch (_) {
      // silent fail — akan coba ulang saat kirim laporan
    }
  }

  @override
  void onClose() {
    // Jangan dispose dulu supaya tidak error TextEditingController saat halaman dibuka ulang.
    super.onClose();
  }
}