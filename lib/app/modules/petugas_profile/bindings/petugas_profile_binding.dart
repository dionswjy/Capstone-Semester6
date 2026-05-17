import 'package:get/get.dart';

import '../controllers/petugas_profile_controller.dart';

class PetugasProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PetugasProfileController>(
      () => PetugasProfileController(),
    );
  }
}
