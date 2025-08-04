import 'package:studyspare_b/app/auth/user_model.dart';
import 'package:studyspare_b/core/network/hive_service.dart';
import 'package:studyspare_b/feature/auth/data/data_source/user_data_source.dart';
import 'package:studyspare_b/feature/auth/data/model/user_hive_model.dart';
import 'package:studyspare_b/feature/auth/domain/entity/login_response.dart';
import 'package:studyspare_b/feature/auth/domain/entity/user_entity.dart';

class UserLocalDatasource implements IuserDataSource {
  final HiveService _hiveService;

  UserLocalDatasource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<void> registerUser(UserEntity userData) async {
    try {
      final userHiveModel = UserHiveModel.fromEntity(userData);
      await _hiveService.register(userHiveModel);
    } catch (e) {
      throw Exception("Registration Failed: $e");
    }
  }

  @override
  Future<LoginResponse> loginUser(String username, String password) async {
    try {
      final user = await _hiveService.loginUser(username, password);
      if (user == null) {
        throw Exception('Invalid username or password');
      }

      // Create a mock token and user for local storage
      final token = user.userId ?? 'local_token';
      final userModel = UserModel(
        id: user.userId ?? '',
        name: user.username,
        email: user.email,
        role: 'user',
        password: password,
      );

      return LoginResponse(token: token, user: userModel);
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }
}
