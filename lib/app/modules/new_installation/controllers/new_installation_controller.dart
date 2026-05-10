import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewInstallationController extends GetxController {
  final nameController = TextEditingController();
  final nikController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  final selectedCategory = "Rumah".obs;

  void selectCategory(String cat) => selectedCategory.value = cat;

  void submit() {
    Get.back();
    Get.snackbar("Terkirim", "Pengajuan pemasangan baru Anda sedang diproses.");
  }

  @override
  void onClose() {
    nameController.dispose();
    nikController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.onClose();
  }
}
