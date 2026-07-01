import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:tirta_desa/app/routes/app_pages.dart';
import 'package:tirta_desa/core/values/api.dart';

class ForgotPasswordController extends GetxController {
  final emailController = TextEditingController();
  final otpController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isSendingOtp = false.obs;
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final isConfirmVisible = false.obs;

  final String baseUrl = Api.baseUrl;

  void togglePassword() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirm() {
    isConfirmVisible.value = !isConfirmVisible.value;
  }

  Future<void> sendOtp() async {
    if (emailController.text.trim().isEmpty) {
      Get.snackbar(
        "Gagal",
        "Email wajib diisi terlebih dahulu",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isSendingOtp.value = true;

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/forgot-password/send-otp"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "email": emailController.text.trim(),
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        Get.snackbar(
          "Berhasil",
          data["message"] ?? "OTP berhasil dikirim ke email",
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          "Gagal",
          data["detail"]?.toString() ?? "Gagal mengirim OTP",
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
      isSendingOtp.value = false;
    }
  }

  Future<void> resetPassword() async {
    if (emailController.text.trim().isEmpty ||
        otpController.text.trim().isEmpty ||
        newPasswordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      Get.snackbar(
        "Gagal",
        "Semua field wajib diisi",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (newPasswordController.text != confirmPasswordController.text) {
      Get.snackbar(
        "Gagal",
        "Password baru dan konfirmasi tidak sama",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/forgot-password/reset"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "email": emailController.text.trim(),
          "otp": otpController.text.trim(),
          "new_password": newPasswordController.text,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        Get.snackbar(
          "Berhasil",
          data["message"] ?? "Password berhasil diubah",
          snackPosition: SnackPosition.BOTTOM,
        );

        Get.offAllNamed(Routes.LOGIN);
      } else {
        Get.snackbar(
          "Gagal",
          data["detail"]?.toString() ?? "Reset password gagal",
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
    // Jangan dispose dulu agar tidak muncul error TextEditingController disposed.
    super.onClose();
  }
}