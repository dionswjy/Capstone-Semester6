import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tirta_desa/app/routes/app_pages.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isPasswordVisible = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void login() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email == 'petugas@tirtadesa.com' && password == '123456') {
      Get.offAllNamed(Routes.PETUGAS_DASHBOARD);
    } else if (email == 'pelanggan@tirtadesa.com' && password == '123456') {
      Get.offAllNamed(Routes.DASHBOARD);
    } else {
      Get.snackbar(
        'Login Gagal',
        'Email atau password salah',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}