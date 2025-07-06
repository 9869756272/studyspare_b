import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:studyspare_b/app/usecase/usecase.dart';
import 'package:studyspare_b/core/error/failure.dart';
import 'package:studyspare_b/feature/course/domain/entities/content.dart';
import 'package:studyspare_b/feature/course/domain/repository/course_repository.dart';

class GetContentByIdUsecase
    implements UsecaseWithParams<Content, GetContentByIdParams> {
  final ICourseRepository _repository;

  GetContentByIdUsecase(this._repository);

  @override
  Future<Either<Failure, Content>> call(GetContentByIdParams params) async {
    return await _repository.getContentById(contentId: params.contentId);
  }
}

class GetContentByIdParams extends Equatable {
  final String contentId;

  const GetContentByIdParams({required this.contentId});

  @override
  List<Object?> get props => [contentId];
}
