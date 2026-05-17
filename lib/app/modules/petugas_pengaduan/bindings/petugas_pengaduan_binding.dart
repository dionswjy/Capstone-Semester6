import 'package:get/get.dart';

import '../controllers/petugas_pengaduan_controller.dart';

class PetugasPengaduanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PetugasPengaduanController>(
      () => PetugasPengaduanController(),
    );
  }
}
