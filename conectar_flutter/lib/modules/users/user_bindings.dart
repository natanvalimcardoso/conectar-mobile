import 'package:get/get.dart';

import '../../core/repositories/user/user_repository.dart';
import '../../core/repositories/user/user_repository_impl.dart';
import '../../core/network/dio_client.dart';
import 'user_controller.dart';

class UserBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserRepository>(
      () => UserRepositoryImpl(Get.find<DioClient>()),
    );
    
    Get.lazyPut<UserController>(
      () => UserController(Get.find<UserRepository>()),
    );
  }
} 