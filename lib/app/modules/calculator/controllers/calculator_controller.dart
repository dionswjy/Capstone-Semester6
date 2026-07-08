import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CalculatorController extends GetxController {
  final startMeterController = TextEditingController(text: "1245");
  final endMeterController = TextEditingController();

  final totalUsage = 0.obs;
  final estimation = 0.obs;
  final serviceFee = 5000;
  final ratePerM3 = 2000;

  void calculate() {
    final start = int.tryParse(startMeterController.text) ?? 0;
    final end = int.tryParse(endMeterController.text) ?? 0;
    
    if (end >= start) {
      totalUsage.value = end - start;
      estimation.value = (totalUsage.value * ratePerM3) + serviceFee;
    } else {
      Get.snackbar("Error", "Meter akhir tidak boleh lebih kecil dari meter awal", backgroundColor: Colors.redAccent, colorText: Colors.white);
    }
  }

  String formatRupiah(int amount) {
    final str = amount.toString();
    var result = '';
    for (var i = 0; i < str.length; i++) {
      if (i > 0 && i % 3 == 0) {
        result = '.${result}';
      }
      result = str[str.length - 1 - i] + result;
    }
    return 'Rp $result';
  }

  @override
  void onClose() {
    startMeterController.dispose();
    endMeterController.dispose();
    super.onClose();
  }
}