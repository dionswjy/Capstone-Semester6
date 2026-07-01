import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:tirta_desa/core/values/api.dart';

class RegisterController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final otpController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nikController = TextEditingController();
  final alamatController = TextEditingController();

  final selectedKategori = "Rumah Tangga".obs;
  final listKategori = ["Rumah Tangga", "Sosial", "Niaga", "Industri"];

  final isPasswordVisible = false.obs;
  final isConfirmVisible = false.obs;
  final isLoading = false.obs;
  final isSendingOtp = false.obs;

  final String baseUrl = Api.baseUrl;

  void togglePassword() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirm() {
    isConfirmVisible.value = !isConfirmVisible.value;
  }

  void changeKategori(String? val) {
    if (val != null) {
      selectedKategori.value = val;
    }
  }

  Future<void> sendOtp() async {
    if (emailController.text.trim().isEmpty) {
      Get.snackbar("Gagal", "Email wajib diisi terlebih dahulu");
      return;
    }

    isSendingOtp.value = true;

    try {
      final url = Uri.parse("$baseUrl/send-otp");

      final response = await http.post(
        url,
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
        );
      } else {
        Get.snackbar(
          "Gagal",
          data["detail"]?.toString() ?? "Gagal mengirim OTP",
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Tidak bisa terhubung ke server. Pastikan FastAPI sudah jalan.",
      );
    } finally {
      isSendingOtp.value = false;
    }
  }

  Future<void> register() async {
    if (nameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        otpController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty ||
        nikController.text.trim().isEmpty ||
        alamatController.text.trim().isEmpty) {
      Get.snackbar("Gagal", "Semua field wajib diisi");
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar("Gagal", "Password dan konfirmasi tidak sama");
      return;
    }

    isLoading.value = true;

    try {
      final url = Uri.parse("$baseUrl/register");

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "name": nameController.text.trim(),
          "email": emailController.text.trim(),
          "phone": phoneController.text.trim(),
          "password": passwordController.text,
          "otp": otpController.text.trim(),
          "nik": nikController.text.trim(),
          "alamat": alamatController.text.trim(),
          "kategori": selectedKategori.value,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          "Berhasil",
          data["message"] ?? "Akun berhasil dibuat",
        );

        Get.offAllNamed('/login');
      } else {
        Get.snackbar(
          "Gagal",
          data["detail"]?.toString() ?? "Register gagal",
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Tidak bisa terhubung ke server. Pastikan FastAPI sudah jalan.",
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    otpController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nikController.dispose();
    alamatController.dispose();
    super.onClose();
  }
}