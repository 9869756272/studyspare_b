import 'package:dartz/dartz.dart';
import 'package:studyspare_b/app/auth/user_model.dart';
import 'package:studyspare_b/core/error/failure.dart';

import 'package:studyspare_b/feature/auth/data/data_source/local_datasource/user_local_datasource.dart';
import 'package:studyspare_b/feature/auth/data/data_source/remote_datasource/user_remote_datasource.dart';
import 'package:studyspare_b/feature/auth/domain/entity/login_response.dart';
import 'package:studyspare_b/feature/auth/domain/entity/user_entity.dart';
import 'package:studyspare_b/feature/auth/domain/repository/user_repositroy.dart';

class UserLocalRepository implements IuserRepository {
  final UserLocalDatasource _userLocalDatasource;

  UserLocalRepository({required UserLocalDatasource userLocalDatasource})
    : _userLocalDatasource = userLocalDatasource;

  @override
  Future<Either<Failure, void>> registerUser(UserEntity user) async {
    try {
      await _userLocalDatasource.registerUser(user);
      return Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: "Failed to register: $e"));
    }
  }

  @override
  Future<Either<Failure, LoginResponse>> loginUser(
    String username,
    String password,
  ) async {
    try {
      final userId = await _userLocalDatasource.loginUser(username, password);
      return Right(
        LoginResponse(
          token: "userId",
          user: UserModel(
            id: "userId",
            name: "username",
            email: "username",
            password: "password",
            role: 'user',
          ),
        ),
      );
    } catch (e) {
      return Left(LocalDatabaseFailure(message: 'Loginfailed: $e'));
    }
  }
}
