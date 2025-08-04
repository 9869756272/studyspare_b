import 'package:dartz/dartz.dart';
import 'package:studyspare_b/core/error/failure.dart';
import 'package:studyspare_b/feature/auth/data/data_source/remote_datasource/user_remote_datasource.dart';
import 'package:studyspare_b/feature/auth/domain/entity/login_response.dart';
import 'package:studyspare_b/feature/auth/domain/entity/user_entity.dart';
import 'package:studyspare_b/feature/auth/domain/repository/user_repositroy.dart';

class UserRemoteRepository implements IuserRepository {
  final UserRemoteDatasource _userRemoteDataSource;

  UserRemoteRepository({required UserRemoteDatasource userRemoteDataSource})
    : _userRemoteDataSource = userRemoteDataSource;

  @override
  Future<Either<Failure, LoginResponse>> loginUser(
    String username,
    String password,
  ) async {
    try {
      final result = await _userRemoteDataSource.loginUser(username, password);
      return Right(result);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> registerUser(UserEntity userData) async {
    try {
      await _userRemoteDataSource.registerUser(userData);
      return const Right(null);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }
}
