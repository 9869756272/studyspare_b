import 'package:dio/dio.dart';
import 'package:studyspare_b/app/auth/user_model.dart';
import 'package:studyspare_b/app/constant/api_endpoints.dart';
import 'package:studyspare_b/core/network/api_service.dart';

abstract class IProfileRemoteDataSource {
  Future<UserModel> getUserProfile({required String token});
  Future<UserModel> updateUserProfile({
    required String token,
    required String name,
    String? newPassword,
  });
  Future<void> deleteUserAccount({
    required String token,
    required String password,
  });
}

class ProfileRemoteDataSourceImpl implements IProfileRemoteDataSource {
  final ApiService _apiService;

  ProfileRemoteDataSourceImpl({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<UserModel> getUserProfile({required String token}) async {
    try {
      final response = await _apiService.dio.get(
        ApiEndpoints.baseUrl + ApiEndpoints.profile,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        return UserModel.fromJson(response.data['data']);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: response.data['message'] ?? 'Failed to get profile',
        );
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }

  @override
  Future<UserModel> updateUserProfile({
    required String token,
    required String name,
    String? newPassword,
  }) async {
    try {
      final Map<String, dynamic> data = {'name': name};
      if (newPassword != null && newPassword.isNotEmpty) {
        data['password'] = newPassword;
      }

      final response = await _apiService.dio.put(
        ApiEndpoints.baseUrl + ApiEndpoints.profile,
        data: data,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        return UserModel.fromJson(response.data['data']);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: response.data['message'] ?? 'Failed to update profile',
        );
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }

  @override
  Future<void> deleteUserAccount({
    required String token,
    required String password,
  }) async {
    try {
      // NOTE: This assumes your backend expects a DELETE request with the password in the body.
      final response = await _apiService.dio.delete(
        ApiEndpoints.baseUrl + ApiEndpoints.profile,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        // Send password for verification
        data: {'password': password},
      );

      // Assuming 200 or 204 means success
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: response.data?['message'] ?? 'Failed to delete account',
        );
      }
    } on DioException catch (e) {
      // Handle specific errors like wrong password
      if (e.response?.statusCode == 401) {
        throw Exception('Incorrect password. Please try again.');
      }
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }
}
