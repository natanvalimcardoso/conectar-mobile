import 'package:get/get.dart';
import '../../../core/repositories/login/login_repository.dart';
import '../../../core/repositories/login/login_repository_impl.dart';
import 'login_controller.dart';

class LoginBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginRepository>(
      () => LoginRepositoryImpl(Get.find()),
    );
    
    Get.lazyPut<LoginController>(
      () => LoginController(Get.find<LoginRepository>()),
    );
  }
}
