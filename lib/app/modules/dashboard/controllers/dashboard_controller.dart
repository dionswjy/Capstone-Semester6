import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:tirta_desa/app/routes/app_pages.dart';
import 'package:tirta_desa/app/data/models/dashboard_model.dart';
import 'package:tirta_desa/core/values/api.dart';

class DashboardController extends GetxController {
  final currentIndex = 0.obs;
  final box = GetStorage();

  final String baseUrl = Api.baseUrl;

  var userName = "Pelanggan".obs;
  var email = "".obs;

  var penggunaanAir = "0 m³".obs;
  var statusPembayaran = "Belum Ada Tagihan".obs;
  var totalTagihan = 0.0.obs;
  var totalTagihanStr = "Rp 0".obs;
  var noMeter = "-".obs;
  var isLoading = false.obs;
  var usageHistory = <UsageHistoryModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
    fetchDashboardData();
  }

  void loadUserData() {
    userName.value = box.read("name") ?? "Pelanggan";
    email.value = box.read("email") ?? "";
  }

  Future<void> fetchDashboardData() async {
    final token = box.read("token");
    if (token == null) return;

    isLoading.value = true;
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/dashboard"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final dashboardData = DashboardModel.fromJson(data);

        userName.value = dashboardData.nama;
        email.value = dashboardData.email;
        penggunaanAir.value = "${dashboardData.penggunaanAir.toStringAsFixed(1).replaceAll('.0', '')} m³";
        
        final status = dashboardData.statusPembayaran.toLowerCase();
        if (status == 'lunas') {
          statusPembayaran.value = "Lunas";
        } else if (status == 'belum_lunas' || status == 'belum lunas') {
          statusPembayaran.value = "Belum Lunas";
        } else {
          statusPembayaran.value = dashboardData.statusPembayaran;
        }

        totalTagihan.value = dashboardData.totalTagihan;
        
        final formatter = NumberFormat.currency(
          locale: 'id_ID',
          symbol: 'Rp ',
          decimalDigits: 0,
        );
        totalTagihanStr.value = formatter.format(dashboardData.totalTagihan);
        noMeter.value = dashboardData.noMeter;
        usageHistory.assignAll(dashboardData.historiPenggunaan);
      }
    } catch (e) {
      debugPrint("Error fetching dashboard data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void changeTabIndex(int index) {
    if (index == 2) {
      Get.toNamed(Routes.PROFILE);
    } else {
      currentIndex.value = index;
    }
  }
}