import '../../models/register/register_request_model.dart';
import '../../models/register/register_response_model.dart';
import '../../network/dio_client.dart';
import 'register_repository.dart';

class RegisterRepositoryImpl implements RegisterRepository {
  final DioClient _dioClient;

  RegisterRepositoryImpl(this._dioClient);

  @override
  Future<RegisterResponseModel> register(RegisterRequestModel request) async {
    try {
      final response = await _dioClient.post(
        'auth/register',
        data: request.toJson(),
      );
      
      return RegisterResponseModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Erro ao realizar registro: $e');
    }
  }
} 