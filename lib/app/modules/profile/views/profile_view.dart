import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:tirta_desa/core/values/colors.dart';
import 'package:tirta_desa/app/routes/app_pages.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Profil", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 32),
            _buildAccountInfo(),
            const SizedBox(height: 24),
            _buildMeterInfo(),
            const SizedBox(height: 32),
            _buildLogoutButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
                color: AppColors.primaryFixed,
              ),
              child: const Icon(LucideIcons.user, size: 48, color: AppColors.primaryContainer),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(color: AppColors.primaryContainer, shape: BoxShape.circle),
                child: const Icon(LucideIcons.pencil, color: Colors.white, size: 14),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Obx(() => Text(controller.userName.value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20))),
        const SizedBox(height: 4),
        Obx(() => Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(20)),
          child: Text("ID: ${controller.userId.value}", style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant)),
        )),
      ],
    );
  }

  Widget _buildAccountInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("INFORMASI AKUN", style: TextStyle(color: AppColors.primaryContainer, fontSize: 10, fontWeight: FontWeight.bold)),
              TextButton(
                onPressed: () => _showEditProfileSheet(Get.context!),
                child: const Text("Ubah", style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Obx(() => _infoRow(LucideIcons.mail, "Email", controller.userEmail.value)),
          const SizedBox(height: 16),
          Obx(() => _infoRow(LucideIcons.phone, "No. Telepon", controller.userPhone.value)),
        ],
      ),
    );
  }

  void _showEditProfileSheet(BuildContext context) {
    final nameCtrl = TextEditingController(text: controller.userName.value);
    final phoneCtrl = TextEditingController(text: controller.userPhone.value);
    final passwordCtrl = TextEditingController();
    final isPasswordVisible = false.obs;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 20),
              const Text("Edit Profil", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 20),
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(
                  labelText: "Nama Lengkap",
                  prefixIcon: const Icon(LucideIcons.user),
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: "No. Telepon",
                  prefixIcon: const Icon(LucideIcons.phone),
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 16),
              Obx(() => TextField(
                controller: passwordCtrl,
                obscureText: !isPasswordVisible.value,
                decoration: InputDecoration(
                  labelText: "Password Baru (kosongkan jika tidak ingin ganti)",
                  prefixIcon: const Icon(LucideIcons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(isPasswordVisible.value ? LucideIcons.eyeOff : LucideIcons.eye),
                    onPressed: () => isPasswordVisible.value = !isPasswordVisible.value,
                  ),
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              )),
              const SizedBox(height: 24),
              Obx(() => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () async {
                          final success = await controller.updateProfile(
                            nameCtrl.text,
                            phoneCtrl.text,
                            password: passwordCtrl.text.isEmpty ? null : passwordCtrl.text,
                          );
                          if (success) Get.back();
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryContainer,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: controller.isLoading.value
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text("Simpan Perubahan", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              )),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, size: 18, color: AppColors.primaryContainer),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 10)),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }

  Widget _buildMeterInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("INFORMASI METERAN", style: TextStyle(color: AppColors.primaryContainer, fontSize: 10, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: AppColors.secondaryContainer.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                child: const Icon(LucideIcons.gauge, size: 18, color: AppColors.onSecondaryContainer),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("No. Meter Utama", style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 10)),
                  Text("TD-MET-88291", style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(LucideIcons.history, color: AppColors.onSurfaceVariant),
            title: const Text("Riwayat Pembayaran", style: TextStyle(fontSize: 14)),
            trailing: const Icon(LucideIcons.chevronRight, size: 18),
            onTap: () => Get.toNamed(Routes.PAYMENT_HISTORY),
          ),
          const Divider(),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(LucideIcons.clipboardList, color: AppColors.onSurfaceVariant),
            title: const Text("Log Aktivitas", style: TextStyle(fontSize: 14)),
            trailing: const Icon(LucideIcons.chevronRight, size: 18),
            onTap: () => Get.toNamed(Routes.ACTIVITY_LOG),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return OutlinedButton.icon(
      onPressed: controller.logout,
      icon: const Icon(LucideIcons.logOut, size: 18),
      label: const Text("Keluar"),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 54),
        foregroundColor: Colors.red,
        side: const BorderSide(color: Colors.red),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
