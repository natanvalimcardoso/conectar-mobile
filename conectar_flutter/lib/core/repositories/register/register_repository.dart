import '../../models/register/register_request_model.dart';
import '../../models/register/register_response_model.dart';

abstract class RegisterRepository {
  Future<RegisterResponseModel> register(RegisterRequestModel request);
} 