import 'package:get/get.dart';

import 'adm_controller.dart';

class AdmBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<AdmController>(AdmController(), permanent: true);
  }
} 