import 'package:dartz/dartz.dart';
import 'package:studyspare_b/app/auth/user_model.dart';
import 'package:studyspare_b/app/usecase/usecase.dart';
import 'package:studyspare_b/core/error/failure.dart';
import 'package:studyspare_b/feature/profile/domain/repository/profile_repository.dart';

class GetUserProfileUsecase implements UsecaseWithoutParams<UserModel> {
  final IProfileRepository _repository;

  GetUserProfileUsecase({required IProfileRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, UserModel>> call() async {
    return await _repository.getUserProfile();
  }
}
