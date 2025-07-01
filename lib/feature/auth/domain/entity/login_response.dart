import 'package:equatable/equatable.dart';
import 'package:studyspare_b/app/auth/user_model.dart';

class LoginResponse extends Equatable {
  final String token;
  final UserModel user;

  const LoginResponse({required this.token, required this.user});

  @override
  List<Object?> get props => [token, user];
}
