import 'package:get/get.dart';

import '../../../core/repositories/register/register_repository.dart';
import '../../../core/repositories/register/register_repository_impl.dart';
import 'register_controller.dart';

class RegisterBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterRepository>(() => RegisterRepositoryImpl(Get.find()));
    Get.lazyPut<RegisterController>(() => RegisterController(Get.find()));
  }
} 