import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:studyspare_b/app/usecase/usecase.dart';
import 'package:studyspare_b/core/error/failure.dart';
import 'package:studyspare_b/feature/course/domain/entities/content.dart';
import 'package:studyspare_b/feature/course/domain/repository/course_repository.dart';

class GetContentForModuleUsecase
    implements UsecaseWithParams<List<Content>, GetContentForModuleParams> {
  final ICourseRepository _repository;
  GetContentForModuleUsecase(this._repository);

  @override
  Future<Either<Failure, List<Content>>> call(
    GetContentForModuleParams params,
  ) async {
    return await _repository.getContentForModule(moduleId: params.moduleId);
  }
}

class GetContentForModuleParams extends Equatable {
  final String moduleId;
  const GetContentForModuleParams({required this.moduleId});
  @override
  List<Object?> get props => [moduleId];
}
