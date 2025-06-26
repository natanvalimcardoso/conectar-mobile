import '../../models/login/login_request_model.dart';
import '../../models/login/login_response_model.dart';
import '../../network/dio_client.dart';
import 'login_repository.dart';

class LoginRepositoryImpl implements LoginRepository {
  final DioClient _dioClient;

  LoginRepositoryImpl(this._dioClient);

  @override
  Future<LoginResponseModel> login(LoginRequestModel request) async {
    try {
      final response = await _dioClient.post(
        'auth/login',
        data: request.toJson(),
      );
      
      return LoginResponseModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Erro ao realizar login: $e');
    }
  }
}