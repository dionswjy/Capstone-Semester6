import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:tirta_desa/app/routes/app_pages.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isPasswordVisible = false.obs;
  final isLoading = false.obs;

  final String baseUrl = "http://127.0.0.1:8000";

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
        final role = data["user"]["role"];

        Get.snackbar(
          "Berhasil",
          data["message"] ?? "Login berhasil",
          snackPosition: SnackPosition.BOTTOM,
        );

        if (role == "petugas") {
          Get.offAllNamed(Routes.PETUGAS_DASHBOARD);
        } else if (role == "pelanggan") {
          Get.offAllNamed(Routes.DASHBOARD);
        } else {
          Get.snackbar(
            "Gagal",
            "Role pengguna tidak dikenali",
            snackPosition: SnackPosition.BOTTOM,
          );
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

  @override
  void onClose() {
    // Jangan dispose dulu supaya tidak error TextEditingController saat halaman dibuka ulang.
    super.onClose();
  }
}