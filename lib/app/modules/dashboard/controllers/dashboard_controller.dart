import 'package:get/get.dart';
import 'package:tirta_desa/app/routes/app_pages.dart';

class DashboardController extends GetxController {
  final currentIndex = 0.obs;

  void changeTabIndex(int index) {
    if (index == 2) {
      Get.toNamed(Routes.PROFILE);
    } else {
      currentIndex.value = index;
    }
  }
}
