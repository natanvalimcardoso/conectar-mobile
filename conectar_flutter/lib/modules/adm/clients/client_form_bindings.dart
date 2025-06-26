import 'package:get/get.dart';

import 'client_form_controller.dart';

class ClientFormBindings extends Bindings {
  @override
  void dependencies() {
    // Remove o controller anterior se existir
    if (Get.isRegistered<ClientFormController>()) {
      Get.delete<ClientFormController>();
    }
    
    // Cria um novo controller
    Get.put<ClientFormController>(
      ClientFormController(clientId: Get.parameters['id']),
    );
  }
} 