import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'storage_client.dart';

class DioClient {
  final Dio dio;

  DioClient({required this.dio}) {
    dio.options = BaseOptions(
      baseUrl: 'https://rational-jawfish-positive.ngrok-free.app/iumi/v1/',
      connectTimeout: const Duration(seconds: 90),
      receiveTimeout: kIsWeb ? null : const Duration(seconds: 90),
      sendTimeout: kIsWeb ? null : const Duration(seconds: 90),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'ngrok-skip-browser-warning': 'true',
      },
    );

    if (!kReleaseMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          request: false,
          responseBody: true,
          requestBody: true,
          
          compact: false,
          enabled: !kReleaseMode,
        ),
      );
    }

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await StorageClient.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) {
          _logDioError(error);
          return handler.next(error);
        },
      ),
    );
  }

  static void _logDioError(DioException error) {
    String errorMessage = 'Erro desconhecido: ${error.message}';
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        errorMessage = '⏰ Timeout: ${error.message}';
        break;
      case DioExceptionType.badResponse:
        errorMessage =
            '❌ Erro ${error.response?.statusCode}: ${error.response?.statusMessage ?? error.message}';
        break;
      case DioExceptionType.cancel:
        errorMessage = '🚫 Requisição cancelada';
        break;
      case DioExceptionType.connectionError:
        errorMessage = '🌐 Erro de conexão: ${error.message}';
        break;
      case DioExceptionType.badCertificate:
        errorMessage = '🔒 Erro de certificado: ${error.message}';
        break;
      case DioExceptionType.unknown:
      default:
        errorMessage = '❓ Erro desconhecido (${error.type}): ${error.message}';
        break;
    }
    if (!kReleaseMode) {
      print('DioClient Error: $errorMessage');
    }
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await dio.get(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await dio.patch(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }
}
