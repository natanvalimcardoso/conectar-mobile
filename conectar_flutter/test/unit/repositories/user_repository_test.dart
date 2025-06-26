import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';

import 'package:conectar_flutter/core/repositories/user/user_repository_impl.dart';
import 'package:conectar_flutter/core/models/user_model.dart';
import 'package:conectar_flutter/core/network/dio_client.dart';

class MockDioClient extends Mock implements DioClient {}

void main() {
  group('UserRepositoryImpl', () {
    late UserRepositoryImpl repository;
    late MockDioClient mockDioClient;

    setUp(() {
      mockDioClient = MockDioClient();
      repository = UserRepositoryImpl(mockDioClient);
    });

    group('getUserProfile', () {
      test('deve retornar UserModel quando busca de perfil for bem-sucedida', () async {
        final mockResponse = Response(
          data: {
            'success': true,
            'message': 'Perfil carregado com sucesso',
            'data': {
              'id': '1',
              'name': 'João Silva',
              'email': 'joao@exemplo.com',
              'role': 'user',
              'lastLogin': '2023-01-01T12:00:00.000Z',
              'createdAt': '2023-01-01T00:00:00.000Z',
              'updatedAt': '2023-01-01T00:00:00.000Z',
            }
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: '/auth/me'),
        );

        when(() => mockDioClient.get('auth/me'))
            .thenAnswer((_) async => mockResponse);

        final result = await repository.getUserProfile();

        expect(result.id, '1');
        expect(result.name, 'João Silva');
        expect(result.email, 'joao@exemplo.com');
        expect(result.role, 'user');

        verify(() => mockDioClient.get('auth/me'));
      });

      test('deve lançar Exception quando resposta indica acesso negado', () async {
        final mockResponse = Response(
          data: {
            'success': false,
            'message': 'Acesso negado',
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: '/auth/me'),
        );

        when(() => mockDioClient.get('auth/me'))
            .thenAnswer((_) async => mockResponse);

        expect(
          () => repository.getUserProfile(),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Token inválido ou expirado'),
            ),
          ),
        );
      });

      test('deve lançar Exception quando resposta é de erro genérico', () async {
        final mockResponse = Response(
          data: {
            'success': false,
            'message': 'Erro interno do servidor',
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: '/auth/me'),
        );

        when(() => mockDioClient.get('auth/me'))
            .thenAnswer((_) async => mockResponse);

        expect(
          () => repository.getUserProfile(),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Erro interno do servidor'),
            ),
          ),
        );
      });

      test('deve lançar Exception específica para status 401', () async {
        when(() => mockDioClient.get('auth/me'))
            .thenThrow(DioException(
          requestOptions: RequestOptions(path: '/auth/me'),
          response: Response(
            statusCode: 401,
            requestOptions: RequestOptions(path: '/auth/me'),
          ),
        ));

        expect(
          () => repository.getUserProfile(),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Sessão expirada'),
            ),
          ),
        );
      });

      test('deve lançar Exception específica para status 403', () async {
        when(() => mockDioClient.get('auth/me'))
            .thenThrow(DioException(
          requestOptions: RequestOptions(path: '/auth/me'),
          response: Response(
            statusCode: 403,
            requestOptions: RequestOptions(path: '/auth/me'),
          ),
        ));

        expect(
          () => repository.getUserProfile(),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Acesso negado'),
            ),
          ),
        );
      });

      test('deve lançar Exception específica para status 404', () async {
        when(() => mockDioClient.get('auth/me'))
            .thenThrow(DioException(
          requestOptions: RequestOptions(path: '/auth/me'),
          response: Response(
            statusCode: 404,
            requestOptions: RequestOptions(path: '/auth/me'),
          ),
        ));

        expect(
          () => repository.getUserProfile(),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Usuário não encontrado'),
            ),
          ),
        );
      });

      test('deve lançar Exception para timeout de conexão', () async {
        when(() => mockDioClient.get('auth/me'))
            .thenThrow(DioException(
          requestOptions: RequestOptions(path: '/auth/me'),
          type: DioExceptionType.connectionTimeout,
        ));

        expect(
          () => repository.getUserProfile(),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Timeout na conexão'),
            ),
          ),
        );
      });

      test('deve lançar Exception para timeout de recebimento', () async {
        when(() => mockDioClient.get('auth/me'))
            .thenThrow(DioException(
          requestOptions: RequestOptions(path: '/auth/me'),
          type: DioExceptionType.receiveTimeout,
        ));

        expect(
          () => repository.getUserProfile(),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Timeout na conexão'),
            ),
          ),
        );
      });

      test('deve lançar Exception para erro de conexão', () async {
        when(() => mockDioClient.get('auth/me'))
            .thenThrow(DioException(
          requestOptions: RequestOptions(path: '/auth/me'),
          type: DioExceptionType.connectionError,
        ));

        expect(
          () => repository.getUserProfile(),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Erro de conexão'),
            ),
          ),
        );
      });
    });

    group('updateUserProfile', () {
      test('deve retornar UserModel atualizado quando update for bem-sucedido', () async {
        const userId = '1';
        const newName = 'João Santos';

        final mockResponse = Response(
          data: {
            'success': true,
            'message': 'Perfil atualizado com sucesso',
            'data': {
              'id': userId,
              'name': newName,
              'email': 'joao@exemplo.com',
              'role': 'user',
              'lastLogin': '2023-01-01T12:00:00.000Z',
              'createdAt': '2023-01-01T00:00:00.000Z',
              'updatedAt': '2023-01-01T01:00:00.000Z',
            }
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: '/users/$userId'),
        );

        when(() => mockDioClient.patch(
              'users/$userId',
              data: {'name': newName},
            )).thenAnswer((_) async => mockResponse);

        final result = await repository.updateUserProfile(
          userId: userId,
          name: newName,
        );

        expect(result.id, userId);
        expect(result.name, newName);
        expect(result.email, 'joao@exemplo.com');

        verify(() => mockDioClient.patch(
              'users/$userId',
              data: {'name': newName},
            ));
      });

      test('deve atualizar apenas senha quando fornecida', () async {
        const userId = '1';
        const currentPassword = 'senha123';
        const newPassword = 'novaSenha456';

        final mockResponse = Response(
          data: {
            'success': true,
            'message': 'Senha atualizada com sucesso',
            'data': {
              'id': userId,
              'name': 'João Silva',
              'email': 'joao@exemplo.com',
              'role': 'user',
              'lastLogin': '2023-01-01T12:00:00.000Z',
              'createdAt': '2023-01-01T00:00:00.000Z',
              'updatedAt': '2023-01-01T01:00:00.000Z',
            }
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: '/users/$userId'),
        );

        when(() => mockDioClient.patch(
              'users/$userId',
              data: {
                'currentPassword': currentPassword,
                'password': newPassword,
              },
            )).thenAnswer((_) async => mockResponse);

        await repository.updateUserProfile(
          userId: userId,
          currentPassword: currentPassword,
          newPassword: newPassword,
        );

        verify(() => mockDioClient.patch(
              'users/$userId',
              data: {
                'currentPassword': currentPassword,
                'password': newPassword,
              },
            ));
      });

      test('deve atualizar nome e senha juntos', () async {
        const userId = '1';
        const newName = 'João Santos';
        const currentPassword = 'senha123';
        const newPassword = 'novaSenha456';

        final mockResponse = Response(
          data: {
            'success': true,
            'message': 'Perfil atualizado com sucesso',
            'data': {
              'id': userId,
              'name': newName,
              'email': 'joao@exemplo.com',
              'role': 'user',
              'lastLogin': '2023-01-01T12:00:00.000Z',
              'createdAt': '2023-01-01T00:00:00.000Z',
              'updatedAt': '2023-01-01T01:00:00.000Z',
            }
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: '/users/$userId'),
        );

        when(() => mockDioClient.patch(
              'users/$userId',
              data: {
                'name': newName,
                'currentPassword': currentPassword,
                'password': newPassword,
              },
            )).thenAnswer((_) async => mockResponse);

        final result = await repository.updateUserProfile(
          userId: userId,
          name: newName,
          currentPassword: currentPassword,
          newPassword: newPassword,
        );

        expect(result.name, newName);

        verify(() => mockDioClient.patch(
              'users/$userId',
              data: {
                'name': newName,
                'currentPassword': currentPassword,
                'password': newPassword,
              },
            ));
      });

      test('deve lançar Exception para status 401 no update', () async {
        const userId = '1';

        when(() => mockDioClient.patch(
              'users/$userId',
              data: {'name': 'João Santos'},
            )).thenThrow(DioException(
          requestOptions: RequestOptions(path: '/users/$userId'),
          response: Response(
            statusCode: 401,
            requestOptions: RequestOptions(path: '/users/$userId'),
          ),
        ));

        expect(
          () => repository.updateUserProfile(
            userId: userId,
            name: 'João Santos',
          ),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Sessão expirada'),
            ),
          ),
        );
      });

      test('deve lançar Exception para status 400 (dados inválidos)', () async {
        const userId = '1';

        when(() => mockDioClient.patch(
              'users/$userId',
              data: {'name': 'João Santos'},
            )).thenThrow(DioException(
          requestOptions: RequestOptions(path: '/users/$userId'),
          response: Response(
            statusCode: 400,
            data: {'message': 'Nome é obrigatório'},
            requestOptions: RequestOptions(path: '/users/$userId'),
          ),
        ));

        expect(
          () => repository.updateUserProfile(
            userId: userId,
            name: 'João Santos',
          ),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Nome é obrigatório'),
            ),
          ),
        );
      });

      test('deve lançar Exception para status 422 (senha atual incorreta)', () async {
        const userId = '1';

        when(() => mockDioClient.patch(
              'users/$userId',
              data: {
                'currentPassword': 'senhaErrada',
                'password': 'novaSenha',
              },
            )).thenThrow(DioException(
          requestOptions: RequestOptions(path: '/users/$userId'),
          response: Response(
            statusCode: 422,
            data: {'message': 'Senha atual incorreta'},
            requestOptions: RequestOptions(path: '/users/$userId'),
          ),
        ));

        expect(
          () => repository.updateUserProfile(
            userId: userId,
            currentPassword: 'senhaErrada',
            newPassword: 'novaSenha',
          ),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Senha atual incorreta'),
            ),
          ),
        );
      });

      test('deve lançar Exception para timeout no update', () async {
        const userId = '1';

        when(() => mockDioClient.patch(
              'users/$userId',
              data: {'name': 'João Santos'},
            )).thenThrow(DioException(
          requestOptions: RequestOptions(path: '/users/$userId'),
          type: DioExceptionType.connectionTimeout,
        ));

        expect(
          () => repository.updateUserProfile(
            userId: userId,
            name: 'João Santos',
          ),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Timeout na conexão'),
            ),
          ),
        );
      });

      test('deve lançar Exception para erro de conexão no update', () async {
        const userId = '1';

        when(() => mockDioClient.patch(
              'users/$userId',
              data: {'name': 'João Santos'},
            )).thenThrow(DioException(
          requestOptions: RequestOptions(path: '/users/$userId'),
          type: DioExceptionType.connectionError,
        ));

        expect(
          () => repository.updateUserProfile(
            userId: userId,
            name: 'João Santos',
          ),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Erro de conexão'),
            ),
          ),
        );
      });
    });
  });
} 