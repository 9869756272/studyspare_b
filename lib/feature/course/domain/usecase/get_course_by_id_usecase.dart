import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:studyspare_b/app/usecase/usecase.dart';
import 'package:studyspare_b/core/error/failure.dart';
import 'package:studyspare_b/feature/course/domain/entities/course.dart';
import 'package:studyspare_b/feature/course/domain/repository/course_repository.dart';

class GetCourseByIdUsecase
    implements UsecaseWithParams<Course, GetCourseByIdParams> {
  final ICourseRepository _repository;
  GetCourseByIdUsecase(this._repository);

  @override
  Future<Either<Failure, Course>> call(GetCourseByIdParams params) async {
    return await _repository.getCourseById(courseId: params.courseId);
  }
}

class GetCourseByIdParams extends Equatable {
  final String courseId;
  const GetCourseByIdParams({required this.courseId});
  @override
  List<Object?> get props => [courseId];
}
