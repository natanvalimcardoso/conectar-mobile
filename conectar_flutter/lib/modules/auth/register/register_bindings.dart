import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../../core/network/dio_client.dart';
import '../../../core/repositories/register/register_repository.dart';
import '../../../core/repositories/register/register_repository_impl.dart';
import 'register_controller.dart';

class RegisterBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DioClient>(() => DioClient(dio: Dio()));
    Get.lazyPut<RegisterRepository>(() => RegisterRepositoryImpl(Get.find()));
    Get.lazyPut<RegisterController>(() => RegisterController(Get.find()));
  }
} 