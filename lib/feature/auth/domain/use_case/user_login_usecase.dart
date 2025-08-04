import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:studyspare_b/app/usecase/usecase.dart';
import 'package:studyspare_b/core/error/failure.dart';
import 'package:studyspare_b/feature/auth/domain/entity/login_response.dart';
import 'package:studyspare_b/feature/auth/domain/repository/user_repositroy.dart';

class LoginUsecaseParams extends Equatable {
  final String username;
  final String password;

  const LoginUsecaseParams({required this.username, required this.password});

  const LoginUsecaseParams.initial() : username = '', password = '';

  @override
  List<Object?> get props => [username, password];
}

class UserLoginUsecase
    implements UsecaseWithParams<LoginResponse, LoginUsecaseParams> {
  final IuserRepository _userRepository;

  UserLoginUsecase({required IuserRepository userRepository})
    : _userRepository = userRepository;

  @override
  Future<Either<Failure, LoginResponse>> call(LoginUsecaseParams params) {
    return _userRepository.loginUser(params.username, params.password);
  }
}
