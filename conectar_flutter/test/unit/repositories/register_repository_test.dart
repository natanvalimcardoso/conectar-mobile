import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';

import 'package:conectar_flutter/core/repositories/register/register_repository_impl.dart';
import 'package:conectar_flutter/core/network/dio_client.dart';
import 'package:conectar_flutter/core/models/register/register_request_model.dart';
import 'package:conectar_flutter/core/models/register/register_response_model.dart';

class MockDioClient extends Mock implements DioClient {}

void main() {
  group('RegisterRepositoryImpl', () {
    late RegisterRepositoryImpl repository;
    late MockDioClient mockDioClient;

    setUp(() {
      mockDioClient = MockDioClient();
      repository = RegisterRepositoryImpl(mockDioClient);
    });

    group('register', () {
      test('deve retornar RegisterResponseModel quando registro for bem-sucedido', () async {
        final request = RegisterRequestModel(
          name: 'João Silva',
          email: 'joao@exemplo.com',
          password: '123456',
        );

        final mockResponse = Response(
          data: {
            'success': true,
            'message': 'Usuário registrado com sucesso',
            'data': {
              'id': '1',
              'name': 'João Silva',
              'email': 'joao@exemplo.com',
              'role': 'user',
              'createdAt': '2023-01-01T00:00:00.000Z',
              'updatedAt': '2023-01-01T00:00:00.000Z',
            }
          },
          statusCode: 201,
          requestOptions: RequestOptions(path: '/auth/register'),
        );

        when(() => mockDioClient.post('auth/register', data: request.toJson()))
            .thenAnswer((_) async => mockResponse);

        final result = await repository.register(request);

        expect(result.success, isTrue);
        expect(result.message, 'Usuário registrado com sucesso');
        expect(result.data, isNotNull);
        expect(result.data!.name, 'João Silva');
        expect(result.data!.email, 'joao@exemplo.com');

        verify(() => mockDioClient.post('auth/register', data: request.toJson()));
      });

      test('deve retornar RegisterResponseModel com success false quando email já existe', () async {
        final request = RegisterRequestModel(
          name: 'João Silva',
          email: 'existente@exemplo.com',
          password: '123456',
        );

        final mockResponse = Response(
          data: {
            'success': false,
            'message': 'Email já cadastrado',
          },
          statusCode: 409,
          requestOptions: RequestOptions(path: '/auth/register'),
        );

        when(() => mockDioClient.post('auth/register', data: request.toJson()))
            .thenAnswer((_) async => mockResponse);

        final result = await repository.register(request);

        expect(result.success, isFalse);
        expect(result.message, 'Email já cadastrado');
        expect(result.data, isNull);
      });

      test('deve retornar RegisterResponseModel com success false quando dados são inválidos', () async {
        final request = RegisterRequestModel(
          name: '',
          email: 'email_invalido',
          password: '123',
        );

        final mockResponse = Response(
          data: {
            'success': false,
            'message': 'Dados inválidos',
          },
          statusCode: 400,
          requestOptions: RequestOptions(path: '/auth/register'),
        );

        when(() => mockDioClient.post('auth/register', data: request.toJson()))
            .thenAnswer((_) async => mockResponse);

        final result = await repository.register(request);

        expect(result.success, isFalse);
        expect(result.message, 'Dados inválidos');
        expect(result.data, isNull);
      });

      test('deve lançar Exception quando ocorrer erro de rede', () async {
        final request = RegisterRequestModel(
          name: 'João Silva',
          email: 'joao@exemplo.com',
          password: '123456',
        );

        when(() => mockDioClient.post('auth/register', data: request.toJson()))
            .thenThrow(DioException(
          requestOptions: RequestOptions(path: '/auth/register'),
          type: DioExceptionType.connectionError,
        ));

        expect(
          () => repository.register(request),
          throwsA(isA<Exception>()),
        );
      });

      test('deve lançar Exception quando ocorrer timeout', () async {
        final request = RegisterRequestModel(
          name: 'João Silva',
          email: 'joao@exemplo.com',
          password: '123456',
        );

        when(() => mockDioClient.post('auth/register', data: request.toJson()))
            .thenThrow(DioException(
          requestOptions: RequestOptions(path: '/auth/register'),
          type: DioExceptionType.connectionTimeout,
        ));

        expect(
          () => repository.register(request),
          throwsA(isA<Exception>()),
        );
      });

      test('deve lançar Exception quando response tiver formato inesperado', () async {
        final request = RegisterRequestModel(
          name: 'João Silva',
          email: 'joao@exemplo.com',
          password: '123456',
        );

        final mockResponse = Response(
          data: 'response_inválido',
          statusCode: 200,
          requestOptions: RequestOptions(path: '/auth/register'),
        );

        when(() => mockDioClient.post('auth/register', data: request.toJson()))
            .thenAnswer((_) async => mockResponse);

        expect(
          () => repository.register(request),
          throwsA(isA<Exception>()),
        );
      });

      test('deve verificar se dados são enviados corretamente', () async {
        final request = RegisterRequestModel(
          name: 'Maria Santos',
          email: 'maria@exemplo.com',
          password: 'senha123',
        );

        final mockResponse = Response(
          data: {
            'success': true,
            'message': 'Usuário registrado com sucesso',
            'data': {
              'id': '2',
              'name': 'Maria Santos',
              'email': 'maria@exemplo.com',
              'role': 'user',
              'createdAt': '2023-01-01T00:00:00.000Z',
              'updatedAt': '2023-01-01T00:00:00.000Z',
            }
          },
          statusCode: 201,
          requestOptions: RequestOptions(path: '/auth/register'),
        );

        when(() => mockDioClient.post('auth/register', data: request.toJson()))
            .thenAnswer((_) async => mockResponse);

        await repository.register(request);

        final capturedData = verify(() => mockDioClient.post('auth/register', data: captureAny(named: 'data'))).captured;
        final sentData = capturedData.first as Map<String, dynamic>;

        expect(sentData['name'], 'Maria Santos');
        expect(sentData['email'], 'maria@exemplo.com');
        expect(sentData['password'], 'senha123');
      });
    });
  });
} 