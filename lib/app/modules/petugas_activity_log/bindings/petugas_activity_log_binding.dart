import 'package:get/get.dart';
import '../controllers/petugas_activity_log_controller.dart';

class PetugasActivityLogBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PetugasActivityLogController>(
        () => PetugasActivityLogController());
  }
}
