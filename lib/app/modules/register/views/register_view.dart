import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:tirta_desa/core/values/colors.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(LucideIcons.droplets, color: AppColors.primaryContainer),
            const SizedBox(width: 8),
            Text(
              "TirtaDesa",
              style: Get.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryContainer,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Daftar Akun Baru",
              style: Get.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Bergabunglah untuk mengelola penggunaan air Anda dengan lebih transparan.",
              style: TextStyle(color: AppColors.onSurfaceVariant),
            ),
            const SizedBox(height: 32),
            _buildForm(),
            const SizedBox(height: 24),
            Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                children: [
                  const Text("Sudah punya akun?"),
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text("Masuk", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildField("Nama Lengkap", controller.nameController, LucideIcons.user, hint: "Masukkan nama lengkap Anda"),
          _buildField("Alamat Email", controller.emailController, LucideIcons.mail, hint: "contoh@email.com"),
          const Text("Kode OTP", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller.otpController,
                  decoration: _inputDecoration(LucideIcons.shieldCheck, "Masukkan kode OTP"),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryContainer,
                  foregroundColor: AppColors.onSecondaryContainer,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("Kirim OTP"),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildField("Nomor Telepon", controller.phoneController, LucideIcons.phone, hint: "0812xxxx"),
          Obx(() => _buildField(
                "Kata Sandi",
                controller.passwordController,
                LucideIcons.lock,
                hint: "••••••••",
                obscure: !controller.isPasswordVisible.value,
                onToggle: controller.togglePassword,
              )),
          Obx(() => _buildField(
                "Konfirmasi",
                controller.confirmPasswordController,
                LucideIcons.refreshCcw,
                hint: "••••••••",
                obscure: !controller.isConfirmVisible.value,
                onToggle: controller.toggleConfirm,
              )),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: controller.register,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryContainer,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Daftar Sekarang", style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(width: 8),
                  Icon(LucideIcons.arrowRight, size: 18),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const _SocialRegisterSection(),
        ],
      ),
    );
  }

  Widget _buildField(String label, TextEditingController ctrl, IconData icon,
      {String? hint, bool obscure = false, VoidCallback? onToggle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 8),
        TextField(
          controller: ctrl,
          obscureText: obscure,
          decoration: _inputDecoration(icon, hint ?? "").copyWith(
            suffixIcon: onToggle != null
                ? IconButton(
                    icon: Icon(obscure ? LucideIcons.eye : LucideIcons.eyeOff, size: 20),
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
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
    );
  }
}

class _SocialRegisterSection extends StatelessWidget {
  const _SocialRegisterSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          children: [
            Expanded(child: Divider()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text("Atau daftar dengan", style: TextStyle(fontSize: 12, color: AppColors.outline)),
            ),
            Expanded(child: Divider()),
          ],
        ),
        const SizedBox(height: 16),
        OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 54),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            side: BorderSide(color: AppColors.outline.withOpacity(0.2)),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(LucideIcons.chrome, size: 20),
              SizedBox(width: 12),
              Text("Daftar dengan Google", style: TextStyle(color: AppColors.onSurface)),
            ],
          ),
        ),
      ],
    );
  }
}