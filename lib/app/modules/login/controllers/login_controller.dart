import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tirta_desa/app/routes/app_pages.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isPasswordVisible = false.obs;

  void togglePasswordVisibility() => isPasswordVisible.value = !isPasswordVisible.value;

  void login() {
    // Implement actual login logic here
    Get.offAllNamed(Routes.DASHBOARD);
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
