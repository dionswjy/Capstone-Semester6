import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewReportController extends GetxController {
  final descriptionController = TextEditingController();
  final selectedCategory = "".obs;

  void selectCategory(String cat) => selectedCategory.value = cat;

  void submit() {
    Get.back();
    Get.snackbar("Sukses", "Laporan Anda telah terkirim.");
  }

  @override
  void onClose() {
    descriptionController.dispose();
    super.onClose();
  }
}
