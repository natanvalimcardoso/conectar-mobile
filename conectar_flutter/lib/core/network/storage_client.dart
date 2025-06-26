import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageClient {
  static const String _accessTokenKey = 'access_token';
  
  static const _secureOptions = AndroidOptions(
    encryptedSharedPreferences: true,
  );
  
  static const _storage = FlutterSecureStorage(
    aOptions: _secureOptions,
  );

  static Future<void> saveToken(String token) async {
    try {
      await _storage.write(key: _accessTokenKey, value: token);
    } catch (e) {
      throw StorageException('Erro ao salvar token: $e');
    }
  }

  static Future<String?> getToken() async {
    try {
      return await _storage.read(key: _accessTokenKey);
    } catch (e) {
      throw StorageException('Erro ao recuperar token: $e');
    }
  }

  static Future<bool> hasToken() async {
    try {
      final token = await getToken();
      return token != null && token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> hasValidToken() async {
    try {
      final token = await getToken();
      if (token == null || token.isEmpty) return false;
      
      // Verifica se o token tem um formato básico válido (JWT)
      final parts = token.split('.');
      return parts.length == 3;
    } catch (e) {
      return false;
    }
  }

  static Future<void> removeToken() async {
    try {
      await _storage.delete(key: _accessTokenKey);
    } catch (e) {
      throw StorageException('Erro ao remover token: $e');
    }
  }

  static Future<void> clearAll() async {
    try {
      await _storage.deleteAll();
    } catch (e) {
      throw StorageException('Erro ao limpar storage: $e');
    }
  }
}

class StorageException implements Exception {
  final String message;
  
  const StorageException(this.message);
  
  @override
  String toString() => 'StorageException: $message';
}

