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
                image: const DecorationImage(
                  image: NetworkImage("https://lh3.googleusercontent.com/aida-public/AB6AXuC-jGrDmQhewq-IbWLb5qQqbnDJa2XEgoBMB-VEGTQUyqjZN_qHFpIf_rqyWejALzi4aaVxxYQYMdOQbJ-lMqXA2E-r7vd_l6Cn0yUfDNhGsGjA92eKaVS_tKutvYaXXmII8wF29B6VvluLeKjMqbrzMNiiN9b9twtLxbrfb6SljCSiMp0Q6A7xRhuiHG-2UmhVdfonnt_WyNaxIqMQAnQAa3r913HCoUGDB1_tALRtprkUDn6g5zg87Xzd7_sgx43X77q-AB86nhk"),
                  fit: BoxFit.cover,
                ),
              ),
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
        const Text("Budi Santoso", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(20)),
          child: const Text("ID: TD-2024-001", style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant)),
        ),
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
              TextButton(onPressed: () {}, child: const Text("Ubah", style: TextStyle(fontSize: 12))),
            ],
          ),
          const SizedBox(height: 12),
          _infoRow(LucideIcons.mail, "Email", "budi.santoso@desa.id"),
          const SizedBox(height: 16),
          _infoRow(LucideIcons.phone, "No. Telepon", "0812 3456 7890"),
          const SizedBox(height: 16),
          _infoRow(LucideIcons.mapPin, "Alamat", "Jl. Melati No. 12, Desa Sumber Air"),
        ],
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
