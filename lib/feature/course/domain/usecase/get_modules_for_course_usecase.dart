import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:studyspare_b/app/usecase/usecase.dart';
import 'package:studyspare_b/core/error/failure.dart';
import 'package:studyspare_b/feature/course/domain/entities/module.dart';
import 'package:studyspare_b/feature/course/domain/repository/course_repository.dart';

class GetModulesForCourseUsecase
    implements UsecaseWithParams<List<Module>, GetModulesForCourseParams> {
  final ICourseRepository _repository;
  GetModulesForCourseUsecase(this._repository);

  @override
  Future<Either<Failure, List<Module>>> call(
    GetModulesForCourseParams params,
  ) async {
    return await _repository.getModulesForCourse(courseId: params.courseId);
  }
}

class GetModulesForCourseParams extends Equatable {
  final String courseId;
  const GetModulesForCourseParams({required this.courseId});
  @override
  List<Object?> get props => [courseId];
}
