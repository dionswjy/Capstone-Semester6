import 'package:get/get.dart';

import '../controllers/petugas_dashboard_controller.dart';

class PetugasDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PetugasDashboardController>(
      () => PetugasDashboardController(),
    );
  }
}