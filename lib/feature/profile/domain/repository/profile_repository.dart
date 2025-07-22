import 'package:dartz/dartz.dart';
import 'package:studyspare_b/app/auth/user_model.dart';
import 'package:studyspare_b/core/error/failure.dart';

abstract class IProfileRepository {
  Future<Either<Failure, UserModel>> getUserProfile();
  Future<Either<Failure, UserModel>> updateUserProfile({
    required String name,
    String? newPassword,
  });
  // Method now requires a password
  Future<Either<Failure, void>> deleteUserAccount({required String password});
}
