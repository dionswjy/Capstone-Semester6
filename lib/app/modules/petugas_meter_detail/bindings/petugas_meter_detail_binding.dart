import 'package:get/get.dart';

import '../controllers/petugas_meter_detail_controller.dart';

class PetugasMeterDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PetugasMeterDetailController>(
      () => PetugasMeterDetailController(),
    );
  }
}
