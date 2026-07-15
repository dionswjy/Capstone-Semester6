import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:tirta_desa/core/values/colors.dart';
import 'package:tirta_desa/app/routes/app_pages.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 48),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  LucideIcons.droplet,
                  color: AppColors.primaryContainer,
                  size: 48,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "Selamat Datang",
                style: Get.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Kelola kebutuhan air desa Anda dengan mudah dan transparan.",
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.onSurfaceVariant),
              ),
              const SizedBox(height: 40),
              _buildLoginForm(),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Belum punya akun?"),
                  TextButton(
                    onPressed: () => Get.toNamed(Routes.REGISTER),
                    child: const Text(
                      "Daftar Akun Baru",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.outline.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Alamat Email", style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          TextField(
            controller: controller.emailController,
            decoration: InputDecoration(
              hintText: "contoh@desa.id",
              prefixIcon: const Icon(LucideIcons.mail, size: 20),
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Kata Sandi", style: TextStyle(fontWeight: FontWeight.w600)),
              TextButton(
                onPressed: () => Get.toNamed(Routes.FORGOT_PASSWORD),
                child: const Text("Lupa Sandi?", style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
          Obx(() => TextField(
                controller: controller.passwordController,
                obscureText: !controller.isPasswordVisible.value,
                decoration: InputDecoration(
                  hintText: "••••••••",
                  prefixIcon: const Icon(LucideIcons.lock, size: 20),
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.isPasswordVisible.value ? LucideIcons.eye : LucideIcons.eyeOff,
                      size: 20,
                    ),
                    onPressed: controller.togglePasswordVisibility,
                  ),
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              )),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: controller.login,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryContainer,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("Masuk", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

}