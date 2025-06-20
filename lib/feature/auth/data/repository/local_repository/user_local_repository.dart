import 'package:dartz/dartz.dart';
import 'package:studyspare_b/core/error/failure.dart';

import 'package:studyspare_b/feature/auth/data/data_source/local_datasource/user_local_datasource.dart';
import 'package:studyspare_b/feature/auth/domain/entity/user_entity.dart';
import 'package:studyspare_b/feature/auth/domain/repository/user_repositroy.dart';

class UserLocalRepository  implements IuserRepository{
  final UserLocalDatasource _userLocalDatasource;

  UserLocalRepository({
    required UserLocalDatasource userLocalDatasource,
  }) : _userLocalDatasource = userLocalDatasource;

  @override
  Future<Either<Failure, void>> registerUser(UserEntity user) async{
    try{
      await _userLocalDatasource.registerUser(user);
      return Right(null);
    }catch (e){
      return Left(LocalDatabaseFailure(message:  "Failed to register: $e"));
    }
  
   
  }
  
  @override
  Future<Either<Failure, String>> loginUser(
    String username, 
    String password,
    ) async{
      try{
        final userId = await _userLocalDatasource.loginUser(username, password);
        return Right(userId);

      } catch (e){
        return Left(LocalDatabaseFailure(message: 'Loginfailed: $e'));
      }
    
  }
}