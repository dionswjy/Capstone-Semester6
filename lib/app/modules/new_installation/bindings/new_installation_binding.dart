import 'package:get/get.dart';
import '../controllers/new_installation_controller.dart';

class NewInstallationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(NewInstallationController());
  }
}

