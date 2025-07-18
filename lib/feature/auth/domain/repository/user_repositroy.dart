import 'package:dartz/dartz.dart';
import 'package:studyspare_b/core/error/failure.dart';

import 'package:studyspare_b/feature/auth/domain/entity/user_entity.dart';

abstract interface class IuserRepository{
  Future <Either<Failure, void>> registerUser(UserEntity user);

  Future<Either<Failure, String >> loginUser( String username, String password);
}