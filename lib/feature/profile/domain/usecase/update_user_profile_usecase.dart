import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:studyspare_b/app/auth/user_model.dart';
import 'package:studyspare_b/app/usecase/usecase.dart';
import 'package:studyspare_b/core/error/failure.dart';
import 'package:studyspare_b/feature/profile/domain/repository/profile_repository.dart';

class UpdateUserProfileUsecase
    implements UsecaseWithParams<UserModel, UpdateUserParams> {
  final IProfileRepository _repository;

  UpdateUserProfileUsecase({required IProfileRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, UserModel>> call(UpdateUserParams params) async {
    return await _repository.updateUserProfile(
      name: params.name,
      newPassword: params.password,
    );
  }
}

class UpdateUserParams extends Equatable {
  final String name;
  final String? password;

  const UpdateUserParams({required this.name, this.password});

  @override
  List<Object?> get props => [name, password];
}
