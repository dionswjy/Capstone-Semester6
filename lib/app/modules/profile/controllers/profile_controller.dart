import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:tirta_desa/app/routes/app_pages.dart';
import 'package:tirta_desa/core/values/api.dart';

class ProfileController extends GetxController {
  final box = GetStorage();

  var userName = "".obs;
  var userEmail = "".obs;
  var userPhone = "".obs;
  var userId = 0.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  void loadUserData() {
    userName.value = box.read("name") ?? "-";
    userEmail.value = box.read("email") ?? "-";
    userPhone.value = box.read("phone") ?? "-";
    userId.value = box.read("id") ?? 0;
  }

  Future<bool> updateProfile(String name, String phone, {String? password}) async {
    if (name.trim().isEmpty || phone.trim().isEmpty) {
      Get.snackbar("Gagal", "Nama dan nomor telepon tidak boleh kosong",
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }

    final token = box.read("token");
    if (token == null) {
      Get.snackbar("Gagal", "Sesi Anda telah berakhir, silakan login kembali",
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }

    isLoading.value = true;
    try {
      final bodyMap = <String, dynamic>{
        "name": name,
        "phone": phone,
      };
      if (password != null && password.trim().isNotEmpty) {
        bodyMap["password"] = password;
      }

      final response = await http.put(
        Uri.parse("${Api.baseUrl}/admin/user/${userId.value}"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(bodyMap),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final updatedUser = data["data"];
        box.write("name", updatedUser["name"]);
        box.write("phone", updatedUser["phone"]);
        
        // Reload local variables
        loadUserData();

        Get.snackbar("Berhasil", "Profil Anda berhasil diperbarui",
            snackPosition: SnackPosition.BOTTOM);
        return true;
      } else {
        Get.snackbar("Gagal", data["detail"]?.toString() ?? "Gagal memperbarui profil",
            snackPosition: SnackPosition.BOTTOM);
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", "Tidak dapat terhubung ke server",
          snackPosition: SnackPosition.BOTTOM);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void logout() {
    box.erase();
    Get.offAllNamed(Routes.LOGIN);
  }
}