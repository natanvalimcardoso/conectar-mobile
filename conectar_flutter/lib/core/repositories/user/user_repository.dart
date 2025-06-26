import '../../models/user_model.dart';

abstract class UserRepository {
  Future<UserModel> getUserProfile();
  Future<UserModel> updateUserProfile({
    required String userId,
    String? name,
    String? currentPassword,
    String? newPassword,
  });
} 