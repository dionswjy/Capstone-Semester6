import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:tirta_desa/core/values/colors.dart';

import '../controllers/forgot_password_controller.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(LucideIcons.arrowLeft),
        ),
        title: const Text(
          "Lupa Sandi",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 32),
            _buildForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: AppColors.primaryContainer.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              LucideIcons.keyRound,
              size: 42,
              color: AppColors.primaryContainer,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          "Reset Password",
          style: Get.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "Masukkan email akun Anda, lalu sistem akan mengirim kode OTP untuk mengganti password.",
          style: TextStyle(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildField(
            label: "Alamat Email",
            controller: controller.emailController,
            icon: LucideIcons.mail,
            hint: "contoh@email.com",
            keyboardType: TextInputType.emailAddress,
          ),

          const Text(
            "Kode OTP",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller.otpController,
                  keyboardType: TextInputType.number,
                  decoration: _inputDecoration(
                    LucideIcons.shieldCheck,
                    "Masukkan OTP",
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Obx(
                () => ElevatedButton(
                  onPressed: controller.isSendingOtp.value
                      ? null
                      : controller.sendOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondaryContainer,
                    foregroundColor: AppColors.onSecondaryContainer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: controller.isSendingOtp.value
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text("Kirim OTP"),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Obx(
            () => _buildField(
              label: "Password Baru",
              controller: controller.newPasswordController,
              icon: LucideIcons.lock,
              hint: "Masukkan password baru",
              obscure: !controller.isPasswordVisible.value,
              onToggle: controller.togglePassword,
            ),
          ),

          Obx(
            () => _buildField(
              label: "Konfirmasi Password",
              controller: controller.confirmPasswordController,
              icon: LucideIcons.refreshCcw,
              hint: "Ulangi password baru",
              obscure: !controller.isConfirmVisible.value,
              onToggle: controller.toggleConfirm,
            ),
          ),

          const SizedBox(height: 24),

          Obx(
            () => SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : controller.resetPassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryContainer,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: controller.isLoading.value
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Ubah Password",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 8),
                          Icon(LucideIcons.checkCircle, size: 18),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    String? hint,
    bool obscure = false,
    VoidCallback? onToggle,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          decoration: _inputDecoration(icon, hint ?? "").copyWith(
            suffixIcon: onToggle != null
                ? IconButton(
                    icon: Icon(
                      obscure ? LucideIcons.eye : LucideIcons.eyeOff,
                      size: 20,
                    ),
                    onPressed: onToggle,
                  )
                : null,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  InputDecoration _inputDecoration(IconData icon, String hint) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, size: 20),
      filled: true,
      fillColor: AppColors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}