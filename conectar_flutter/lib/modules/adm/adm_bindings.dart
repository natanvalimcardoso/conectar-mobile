import 'package:get/get.dart';

import 'adm_controller.dart';

class AdmBindings extends Bindings {
  @override
  void dependencies() {
    // Cria o AdmController imediatamente para garantir que os controllers filhos sejam inicializados
    Get.put<AdmController>(AdmController(), permanent: true);
  }
} 