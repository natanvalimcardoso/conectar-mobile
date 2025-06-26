import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';

import 'package:conectar_flutter/core/repositories/login/login_repository_impl.dart';
import 'package:conectar_flutter/core/network/dio_client.dart';
import 'package:conectar_flutter/core/models/login/login_request_model.dart';
import 'package:conectar_flutter/core/models/login/login_response_model.dart';

class MockDioClient extends Mock implements DioClient {}

void main() {
  group('LoginRepositoryImpl', () {
    late LoginRepositoryImpl repository;
    late MockDioClient mockDioClient;

    setUp(() {
      mockDioClient = MockDioClient();
      repository = LoginRepositoryImpl(mockDioClient);
    });

    group('login', () {
      test('deve retornar LoginResponseModel quando login for bem-sucedido', () async {
        final request = LoginRequestModel(
          email: 'teste@exemplo.com',
          password: '123456',
        );

        final mockResponse = Response(
          data: {
            'success': true,
            'message': 'Login realizado com sucesso',
            'data': {
              'user': {
                'id': '1',
                'name': 'Usuário Teste',
                'email': 'teste@exemplo.com',
                'role': 'user',
                'createdAt': '2023-01-01T00:00:00.000Z',
                'updatedAt': '2023-01-01T00:00:00.000Z',
              },
              'token': 'jwt_token_aqui'
            }
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: '/auth/login'),
        );

        when(() => mockDioClient.post('auth/login', data: request.toJson()))
            .thenAnswer((_) async => mockResponse);

        final result = await repository.login(request);

        expect(result.success, isTrue);
        expect(result.message, 'Login realizado com sucesso');
        expect(result.data, isNotNull);
        expect(result.data!.user.email, 'teste@exemplo.com');
        expect(result.data!.token, 'jwt_token_aqui');

        verify(() => mockDioClient.post('auth/login', data: request.toJson()));
      });

      test('deve retornar LoginResponseModel com success false quando credenciais forem inválidas', () async {
        final request = LoginRequestModel(
          email: 'teste@exemplo.com',
          password: 'senha_errada',
        );

        final mockResponse = Response(
          data: {
            'success': false,
            'message': 'Credenciais inválidas',
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: '/auth/login'),
        );

        when(() => mockDioClient.post('auth/login', data: request.toJson()))
            .thenAnswer((_) async => mockResponse);

        final result = await repository.login(request);

        expect(result.success, isFalse);
        expect(result.message, 'Credenciais inválidas');
        expect(result.data, isNull);
      });

      test('deve lançar Exception quando ocorrer erro de rede', () async {
        final request = LoginRequestModel(
          email: 'teste@exemplo.com',
          password: '123456',
        );

        when(() => mockDioClient.post('auth/login', data: request.toJson()))
            .thenThrow(DioException(
          requestOptions: RequestOptions(path: '/auth/login'),
          error: 'Erro de conexão',
        ));

        expect(
          () => repository.login(request),
          throwsA(isA<Exception>()),
        );
      });

      test('deve lançar Exception quando response tiver formato inesperado', () async {
        final request = LoginRequestModel(
          email: 'teste@exemplo.com',
          password: '123456',
        );

        final mockResponse = Response(
          data: 'response_inválido',
          statusCode: 200,
          requestOptions: RequestOptions(path: '/auth/login'),
        );

        when(() => mockDioClient.post('auth/login', data: request.toJson()))
            .thenAnswer((_) async => mockResponse);

        expect(
          () => repository.login(request),
          throwsA(isA<Exception>()),
        );
      });
    });
  });
} 