import 'package:dio/dio.dart';

import '../../models/user_model.dart';
import '../../network/dio_client.dart';
import 'user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final DioClient _dioClient;

  UserRepositoryImpl(this._dioClient);

  @override
  Future<UserModel> getUserProfile() async {
    try {
      final response = await _dioClient.get('auth/me');
      
      // Verifica se a resposta indica sucesso
      if (response.statusCode == 200 && response.data['success'] == true && response.data['data'] != null) {
        return UserModel.fromJson(response.data['data']);
      }
      
      // Trata caso específico de "Acesso negado" com status 200
      if (response.statusCode == 200 && response.data['success'] == false) {
        final message = response.data['message'];
        if (message == 'Acesso negado') {
          throw Exception('Token inválido ou expirado. Faça login novamente.');
        }
        throw Exception(message ?? 'Erro ao carregar perfil');
      }
      
      throw Exception(response.data['message'] ?? 'Erro ao carregar perfil');
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Sessão expirada. Faça login novamente.');
      } else if (e.response?.statusCode == 403) {
        throw Exception('Acesso negado. Faça login novamente.');
      } else if (e.response?.statusCode == 404) {
        throw Exception('Usuário não encontrado.');
      } else if (e.type == DioExceptionType.connectionTimeout || 
                 e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Timeout na conexão. Tente novamente.');
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception('Erro de conexão. Verifique sua internet.');
      }
      throw Exception('Erro ao carregar perfil: ${e.message}');
    } catch (e) {
      throw Exception('Erro ao carregar perfil do usuário: $e');
    }
  }

  @override
  Future<UserModel> updateUserProfile({
    required String userId,
    String? name,
    String? currentPassword,
    String? newPassword,
  }) async {
    try {
      final Map<String, dynamic> data = {};
      
      if (name != null) data['name'] = name;
      if (currentPassword != null) data['currentPassword'] = currentPassword;
      if (newPassword != null) data['password'] = newPassword;

      final response = await _dioClient.patch(
        'users/$userId',
        data: data,
      );
      
      print('📊 [UserRepository] Response status: ${response.statusCode}');
      print('📊 [UserRepository] Response data: ${response.data}');
      
      if (response.statusCode == 200 && response.data['success'] == true && response.data['data'] != null) {
        print('✅ [UserRepository] Criando UserModel com dados: ${response.data['data']}');
        return UserModel.fromJson(response.data['data']);
      } else {
        print('❌ [UserRepository] Erro na resposta: ${response.data['message']}');
        throw Exception(response.data['message'] ?? 'Erro ao atualizar perfil');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Sessão expirada. Faça login novamente.');
      } else if (e.response?.statusCode == 400) {
        final message = e.response?.data['message'] ?? 'Dados inválidos.';
        throw Exception(message);
      } else if (e.response?.statusCode == 422) {
        final message = e.response?.data['message'] ?? 'Senha atual incorreta.';
        throw Exception(message);
      } else if (e.type == DioExceptionType.connectionTimeout || 
                 e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Timeout na conexão. Tente novamente.');
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception('Erro de conexão. Verifique sua internet.');
      }
      throw Exception('Erro ao atualizar perfil: ${e.message}');
    } catch (e) {
      throw Exception('Erro ao atualizar perfil: $e');
    }
  }
} 