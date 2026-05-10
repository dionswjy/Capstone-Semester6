import 'package:get/get.dart';
import 'package:tirta_desa/app/routes/app_pages.dart';

class ProfileController extends GetxController {
  void logout() {
    Get.offAllNamed(Routes.LOGIN);
  }
}