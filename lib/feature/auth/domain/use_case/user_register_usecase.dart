import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:studyspare_b/app/usecase/usecase.dart';
import 'package:studyspare_b/core/error/failure.dart';
import 'package:studyspare_b/feature/auth/domain/entity/user_entity.dart';
import 'package:studyspare_b/feature/auth/domain/repository/user_repositroy.dart';


class RegisterUserParams extends Equatable{
  final String username;
  final String email;
  final String password;

  const RegisterUserParams({
    required this.username,
    required this.email,
    required this.password,
  });

    //intial constructor
    const RegisterUserParams.intial({
      required this.username,
      required this.email,
      required this.password
    });
  
  @override

  List<Object?> get props => [
    username,
    email,
    password
  ];
}

class UserRegisterUsecase  implements UsecaseWithParams<void, RegisterUserParams>{
  final IuserRepository _userRepository;
  UserRegisterUsecase({required IuserRepository userReposiotry})
  : _userRepository = userReposiotry;

  @override
  Future<Either<Failure, void>> call(RegisterUserParams params) {
    final userEntity = UserEntity(
      username: params.username,
      email : params.email,
      password: params.password,

    );
    return _userRepository.registerUser(userEntity);
  
   
  }
}