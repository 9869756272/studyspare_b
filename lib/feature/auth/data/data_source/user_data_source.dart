import 'package:studyspare_b/feature/auth/domain/entity/login_response.dart';
import 'package:studyspare_b/feature/auth/domain/entity/user_entity.dart';

abstract interface class IuserDataSource {
  Future<void> registerUser(UserEntity userData);

  Future<LoginResponse> loginUser(String username, String password);
}
