import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:studyspare_b/app/usecase/usecase.dart';
import 'package:studyspare_b/core/error/failure.dart';
import 'package:studyspare_b/feature/profile/domain/repository/profile_repository.dart';

// Usecase now takes parameters
class DeleteUserUsecase implements UsecaseWithParams<void, DeleteUserParams> {
  final IProfileRepository _repository;

  DeleteUserUsecase({required IProfileRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, void>> call(DeleteUserParams params) async {
    return await _repository.deleteUserAccount(password: params.password);
  }
}

// New class for parameters
class DeleteUserParams extends Equatable {
  final String password;

  const DeleteUserParams({required this.password});

  @override
  List<Object?> get props => [password];
}
