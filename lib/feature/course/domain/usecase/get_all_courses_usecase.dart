import 'package:dartz/dartz.dart';
import 'package:studyspare_b/app/usecase/usecase.dart';
import 'package:studyspare_b/core/error/failure.dart';
import 'package:studyspare_b/feature/course/domain/entities/course.dart';
import 'package:studyspare_b/feature/course/domain/repository/course_repository.dart';

class GetAllCoursesUsecase implements UsecaseWithoutParams<List<Course>> {
  final ICourseRepository _repository;
  GetAllCoursesUsecase(this._repository);

  @override
  Future<Either<Failure, List<Course>>> call() async {
    return await _repository.getAllCourses();
  }
}
