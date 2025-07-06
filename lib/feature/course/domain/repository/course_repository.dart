import 'package:dartz/dartz.dart';
import 'package:studyspare_b/core/error/failure.dart';
import 'package:studyspare_b/feature/course/domain/entities/content.dart';
import 'package:studyspare_b/feature/course/domain/entities/course.dart';
import 'package:studyspare_b/feature/course/domain/entities/module.dart';

abstract class ICourseRepository {
  Future<Either<Failure, List<Course>>> getAllCourses();
  Future<Either<Failure, Course>> getCourseById({required String courseId});
  Future<Either<Failure, List<Module>>> getModulesForCourse({
    required String courseId,
  });
  Future<Either<Failure, List<Content>>> getContentForModule({
    required String moduleId,
  });
  Future<Either<Failure, Content>> getContentById({required String contentId});
}
