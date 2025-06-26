import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import 'client_form_controller.dart';

class ClientFormBindings extends Bindings {
  @override
  void dependencies() {
    if (Get.isRegistered<ClientFormController>()) {
      Get.delete<ClientFormController>(force: true);
    }
    
    Get.put<ClientFormController>(
      ClientFormController(clientId: null),
      permanent: false,
    );
  }
} 