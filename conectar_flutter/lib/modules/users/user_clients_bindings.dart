import 'package:get/get.dart';

import 'user_clients_controller.dart';

class UserClientsBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<UserClientsController>(UserClientsController(), permanent: true);
  }
} 