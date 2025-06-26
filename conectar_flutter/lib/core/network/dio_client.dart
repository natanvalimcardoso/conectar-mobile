import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'storage_client.dart';

class DioClient {
  final Dio dio;

  DioClient({required this.dio}) {
    dio.options = BaseOptions(
      baseUrl: 'http://localhost:3000/',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      // sendTimeout só para plataformas móveis - Web não suporta bem
      sendTimeout: kIsWeb ? null : const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      responseType: ResponseType.json,
      followRedirects: true,
      validateStatus: (status) => status != null && status < 500,
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
            options.headers['Authorization'] = 'Bearer $token';
          
          return handler.next(options);
        },
        onError: (error, handler) {
          _logDioError(error);
          
          // Log específico para erro de acesso negado
          if (error.response?.statusCode == 200 && 
              error.response?.data['success'] == false &&
              error.response?.data['message'] == 'Acesso negado') {
          }
          
          if (kIsWeb && error.type == DioExceptionType.connectionError) {
          }
          
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
