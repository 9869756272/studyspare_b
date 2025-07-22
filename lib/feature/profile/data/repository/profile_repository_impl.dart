import 'package:dartz/dartz.dart';
import 'package:studyspare_b/app/auth/auth_provider.dart';
import 'package:studyspare_b/app/auth/user_model.dart';
import 'package:studyspare_b/core/error/failure.dart';
import 'package:studyspare_b/feature/profile/data/datasource/profile_remote_datasource.dart';
import 'package:studyspare_b/feature/profile/domain/repository/profile_repository.dart';

class ProfileRepositoryImpl implements IProfileRepository {
  final IProfileRemoteDataSource _remoteDataSource;
  final AuthProvider _authProvider; // To get the token

  ProfileRepositoryImpl({
    required IProfileRemoteDataSource remoteDataSource,
    required AuthProvider authProvider,
  }) : _remoteDataSource = remoteDataSource,
       _authProvider = authProvider;

  // Helper to get the token or return a failure
  Either<Failure, String> _getToken() {
    final token = _authProvider.currentToken;
    if (token == null) {
      return Left(
        RemoteDatabaseFailure(message: 'Not authenticated. No token found.'),
      );
    }
    return Right(token);
  }

  @override
  Future<Either<Failure, UserModel>> getUserProfile() async {
    return _getToken().fold((failure) => Future.value(Left(failure)), (
      token,
    ) async {
      try {
        final userModel = await _remoteDataSource.getUserProfile(token: token);
        return Right(userModel);
      } catch (e) {
        return Left(RemoteDatabaseFailure(message: e.toString()));
      }
    });
  }

  @override
  Future<Either<Failure, UserModel>> updateUserProfile({
    required String name,
    String? newPassword,
  }) async {
    return _getToken().fold((failure) => Future.value(Left(failure)), (
      token,
    ) async {
      try {
        final userModel = await _remoteDataSource.updateUserProfile(
          token: token,
          name: name,
          newPassword: newPassword,
        );
        return Right(userModel);
      } catch (e) {
        return Left(RemoteDatabaseFailure(message: e.toString()));
      }
    });
  }

  @override
  Future<Either<Failure, void>> deleteUserAccount({
    required String password,
  }) async {
    return _getToken().fold((failure) => Future.value(Left(failure)), (
      token,
    ) async {
      try {
        await _remoteDataSource.deleteUserAccount(
          token: token,
          password: password,
        );
        return const Right(null);
      } catch (e) {
        return Left(RemoteDatabaseFailure(message: e.toString()));
      }
    });
  }
}
