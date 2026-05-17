import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class PetugasProfileController extends GetxController {
  void logout() {
    Get.offAllNamed(Routes.LOGIN);
  }
}