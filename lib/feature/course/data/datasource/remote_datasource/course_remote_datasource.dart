import 'package:dio/dio.dart';
import 'package:studyspare_b/app/constant/api_endpoints.dart';
import 'package:studyspare_b/core/network/api_service.dart';
import 'package:studyspare_b/feature/course/data/datasource/course_data_source.dart';
import 'package:studyspare_b/feature/course/data/model/course_data_model.dart';

class CourseRemoteDataSourceImpl implements ICourseDataSource {
  final ApiService _apiService;
  CourseRemoteDataSourceImpl({required ApiService apiService})
    : _apiService = apiService;

  Options _authHeaders(String token) =>
      Options(headers: {'Authorization': 'Bearer $token'});

  @override
  Future<List<CourseModel>> getAllCourses({required String token}) async {
    try {
      final response = await _apiService.dio.get(
        ApiEndpoints.baseUrl + ApiEndpoints.courses,
        options: _authHeaders(token),
      );
      return (response.data as List)
          .map((course) => CourseModel.fromJson(course))
          .toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }

  @override
  Future<CourseModel> getCourseById({
    required String token,
    required String courseId,
  }) async {
    try {
      final response = await _apiService.dio.get(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.courses}/$courseId',
        options: _authHeaders(token),
      );
      return CourseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }

  @override
  Future<List<ModuleModel>> getModulesForCourse({
    required String token,
    required String courseId,
  }) async {
    try {
      // Assuming endpoint from React code: /api/courses/:id/modules
      final response = await _apiService.dio.get(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.courses}/$courseId/modules',
        options: _authHeaders(token),
      );
      return (response.data as List)
          .map((module) => ModuleModel.fromJson(module))
          .toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }

  @override
  Future<List<ContentModel>> getContentForModule({
    required String token,
    required String moduleId,
  }) async {
    try {
      final response = await _apiService.dio.get(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.modules}/$moduleId/content',
        options: _authHeaders(token),
      );
      return (response.data as List)
          .map((content) => ContentModel.fromJson(content))
          .toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }

  @override
  Future<ContentModel> getContentById({
    required String token,
    required String contentId,
  }) async {
    try {
      final response = await _apiService.dio.get(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.content}/$contentId',
        options: _authHeaders(token),
      );
      return ContentModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }
}
