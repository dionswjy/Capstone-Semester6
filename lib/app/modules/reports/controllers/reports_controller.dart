import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:tirta_desa/core/values/api.dart';

class ReportsController extends GetxController {
  final box = GetStorage();
  final reports = <dynamic>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchReports();
  }

  Future<void> fetchReports() async {
    final token = box.read("token");
    if (token == null) return;

    int? pelangganId = box.read("pelanggan_id");
    if (pelangganId == null) {
      try {
        final dashRes = await http.get(
          Uri.parse("${Api.baseUrl}/dashboard"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        );
        if (dashRes.statusCode == 200) {
          final dashData = jsonDecode(dashRes.body);
          pelangganId = dashData["pelanggan_id"];
          if (pelangganId != null) {
            box.write("pelanggan_id", pelangganId);
          }
        }
      } catch (_) {}
    }

    isLoading.value = true;
    try {
      final response = await http.get(
        Uri.parse("${Api.baseUrl}/admin/komplain"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final List allReports = jsonResponse["data"] ?? [];
        
        if (pelangganId != null) {
          reports.assignAll(
            allReports.where((item) => item["pelanggan_id"] == pelangganId).toList(),
          );
        } else {
          reports.assignAll(allReports);
        }
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat riwayat laporan");
    } finally {
      isLoading.value = false;
    }
  }
}
