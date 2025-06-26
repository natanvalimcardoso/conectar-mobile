import 'package:conectar_flutter/core/network/dio_client.dart';
import 'package:conectar_flutter/core/network/storage_client.dart' show StorageClient;
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<Dio>(Dio(), permanent: true);
    Get.put<StorageClient>(StorageClient(), permanent: true);
    Get.put<DioClient>(DioClient(dio: Get.find()), permanent: true);
  }
}
