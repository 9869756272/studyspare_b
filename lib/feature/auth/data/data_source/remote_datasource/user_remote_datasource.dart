// import 'package:dio/dio.dart';
import 'package:dio/dio.dart';
import 'package:studyspare_b/app/auth/user_model.dart';
import 'package:studyspare_b/app/constant/api_endpoints.dart';
import 'package:studyspare_b/core/network/api_service.dart';
import 'package:studyspare_b/feature/auth/data/data_source/user_data_source.dart';
import 'package:studyspare_b/feature/auth/data/model/user_api_model.dart';
import 'package:studyspare_b/feature/auth/domain/entity/login_response.dart';
import 'package:studyspare_b/feature/auth/domain/entity/user_entity.dart';

class UserRemoteDatasource implements IuserDataSource {
  final ApiService _apiService;

  UserRemoteDatasource({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<LoginResponse> loginUser(String username, String password) async {
    try {
      print('Attempting login for username: $username');
      print('API endpoint: ${ApiEndpoints.baseUrl}${ApiEndpoints.login}');

      final response = await _apiService.dio.post(
        ApiEndpoints.login,
        data: {
          'email': username,
          'password': password,
        }, // Changed from 'username' to 'email'
      );

      print('Response status code: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode == 200) {
        final responseData = response.data;

        // Check if response is a Map and contains token
        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('token')) {
          final token = responseData['token'];
          final userData = responseData['user'];

          if (userData != null && userData is Map<String, dynamic>) {
            final user = UserModel.fromJson(userData);
            print('Token received: $token');
            print('User data received: $user');
            return LoginResponse(token: token, user: user);
          } else {
            throw Exception('User data not found in response');
          }
        } else if (responseData is Map<String, dynamic> &&
            responseData.containsKey('success') &&
            responseData['success'] == true) {
          // Handle the actual API response structure
          final token = responseData['token'];
          final userData = responseData['user'];

          if (token != null &&
              userData != null &&
              userData is Map<String, dynamic>) {
            final user = UserModel.fromJson(userData);
            print('Token received from success response: $token');
            print('User data received from success response: $user');
            return LoginResponse(token: token, user: user);
          } else {
            print(
              'Token or user data not found in success response: $responseData',
            );
            throw Exception('Token or user data not found in response');
          }
        } else {
          print('Unexpected response format: $responseData');
          throw Exception(
            'Invalid response format: token not found in response',
          );
        }
      } else {
        print('HTTP Error: ${response.statusCode} - ${response.statusMessage}');
        throw Exception(
          'HTTP Error: ${response.statusCode} - ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      print('DioException caught: ${e.type}');
      print('DioException message: ${e.message}');
      print('DioException response: ${e.response?.data}');
      print('DioException status code: ${e.response?.statusCode}');

      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception(
          'Connection timeout. Please check your internet connection and try again.',
        );
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception(
          'Connection error. Please check if the server is running at ${ApiEndpoints.baseUrl}',
        );
      } else if (e.response?.statusCode == 401) {
        throw Exception(
          'Invalid credentials. Please check your username and password.',
        );
      } else if (e.response?.statusCode == 404) {
        throw Exception(
          'Login endpoint not found. Please check the API configuration.',
        );
      } else {
        throw Exception('Login failed: ${e.message}');
      }
    } catch (e) {
      print('General exception caught: $e');
      throw Exception('Failed to login user: $e');
    }
  }

  @override
  Future<void> registerUser(UserEntity userData) async {
    try {
      final userApiModel = UserApiModel.fromEntity(userData);
      final response = await _apiService.dio.post(
        ApiEndpoints.register,
        data: userApiModel.toJson(),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      } else {
        throw Exception('Failed to register user: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to register user: ${e.message}');
    } catch (e) {
      throw Exception('Failed to register user: $e');
    }
  }
}
