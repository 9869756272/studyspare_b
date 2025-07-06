import 'package:dartz/dartz.dart';
import 'package:studyspare_b/app/auth/auth_provider.dart';
import 'package:studyspare_b/core/error/failure.dart';
import 'package:studyspare_b/feature/course/data/datasource/course_data_source.dart';
import 'package:studyspare_b/feature/course/domain/entities/content.dart';
import 'package:studyspare_b/feature/course/domain/entities/course.dart';
import 'package:studyspare_b/feature/course/domain/entities/module.dart';
import 'package:studyspare_b/feature/course/domain/repository/course_repository.dart';

class CourseRemoteRepository implements ICourseRepository {
  final ICourseDataSource _remoteDataSource;
  final AuthProvider _authProvider;

  CourseRemoteRepository({
    required ICourseDataSource remoteDataSource,
    required AuthProvider authProvider,
  }) : _remoteDataSource = remoteDataSource,
       _authProvider = authProvider;

  Either<Failure, String> _getToken() {
    final token = _authProvider.currentToken;
    if (token == null) {
      return Left(
        RemoteDatabaseFailure(message: 'Not authenticated. Please login.'),
      );
    }
    return Right(token);
  }

  @override
  Future<Either<Failure, List<Course>>> getAllCourses() async {
    return _getToken().fold((failure) => Future.value(Left(failure)), (
      token,
    ) async {
      try {
        final courses = await _remoteDataSource.getAllCourses(token: token);
        return Right(courses);
      } catch (e) {
        return Left(RemoteDatabaseFailure(message: e.toString()));
      }
    });
  }

  @override
  Future<Either<Failure, Course>> getCourseById({
    required String courseId,
  }) async {
    return _getToken().fold((failure) => Future.value(Left(failure)), (
      token,
    ) async {
      try {
        final course = await _remoteDataSource.getCourseById(
          token: token,
          courseId: courseId,
        );
        return Right(course);
      } catch (e) {
        return Left(RemoteDatabaseFailure(message: e.toString()));
      }
    });
  }

  @override
  Future<Either<Failure, List<Module>>> getModulesForCourse({
    required String courseId,
  }) async {
    return _getToken().fold((failure) => Future.value(Left(failure)), (
      token,
    ) async {
      try {
        final modules = await _remoteDataSource.getModulesForCourse(
          token: token,
          courseId: courseId,
        );
        return Right(modules);
      } catch (e) {
        return Left(RemoteDatabaseFailure(message: e.toString()));
      }
    });
  }

  @override
  Future<Either<Failure, List<Content>>> getContentForModule({
    required String moduleId,
  }) async {
    return _getToken().fold((failure) => Future.value(Left(failure)), (
      token,
    ) async {
      try {
        final content = await _remoteDataSource.getContentForModule(
          token: token,
          moduleId: moduleId,
        );
        return Right(content);
      } catch (e) {
        return Left(RemoteDatabaseFailure(message: e.toString()));
      }
    });
  }

  @override
  Future<Either<Failure, Content>> getContentById({required String contentId}) {
    return _getToken().fold((failure) => Future.value(Left(failure)), (
      token,
    ) async {
      try {
        final content = await _remoteDataSource.getContentById(
          token: token,
          contentId: contentId,
        );
        return Right(content);
      } catch (e) {
        return Left(RemoteDatabaseFailure(message: e.toString()));
      }
    });
  }
}
