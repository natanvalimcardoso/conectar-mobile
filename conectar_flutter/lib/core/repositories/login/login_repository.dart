import '../../models/login/login_request_model.dart';
import '../../models/login/login_response_model.dart';

abstract class LoginRepository {
  Future<LoginResponseModel> login(LoginRequestModel request);
}