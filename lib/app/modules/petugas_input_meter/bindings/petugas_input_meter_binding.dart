import 'package:get/get.dart';

import '../controllers/petugas_input_meter_controller.dart';

class PetugasInputMeterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PetugasInputMeterController>(
      () => PetugasInputMeterController(),
    );
  }
}
