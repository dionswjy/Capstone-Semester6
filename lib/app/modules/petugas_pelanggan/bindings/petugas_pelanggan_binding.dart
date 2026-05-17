import 'package:get/get.dart';

import '../controllers/petugas_pelanggan_controller.dart';

class PetugasPelangganBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PetugasPelangganController>(
      () => PetugasPelangganController(),
    );
  }
}
