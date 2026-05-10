import 'package:get/get.dart';
import 'package:tirta_desa/app/routes/app_pages.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    Future.delayed(const Duration(seconds: 3), () {
      Get.offAllNamed(Routes.LOGIN);
    });
  }
}
