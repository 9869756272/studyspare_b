import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studyspare_b/core/error/failure.dart';
import 'package:studyspare_b/app/auth/user_model.dart';

class TokenSharedPrefs {
  final SharedPreferences _sharedPreferences;

  TokenSharedPrefs({required SharedPreferences sharedPreferences})
    : _sharedPreferences = sharedPreferences;

  Future<Either<Failure, void>> saveToken(String token) async {
    try {
      await _sharedPreferences.setString('token', token);
      return Right(null);
    } catch (e) {
      return Left(
        SharedPreferencesFailure(message: 'Failed to save token: $e'),
      );
    }
  }

  Future<Either<Failure, String?>> getToken() async {
    try {
      final token = _sharedPreferences.getString('token');
      return Right(token);
    } catch (e) {
      return Left(
        SharedPreferencesFailure(message: 'Failed to retrieve token: $e'),
      );
    }
  }

  Future<Either<Failure, void>> clearToken() async {
    try {
      await _sharedPreferences.remove('token');
      await _sharedPreferences.remove('user_data');
      return Right(null);
    } catch (e) {
      return Left(
        SharedPreferencesFailure(message: 'Failed to clear token: $e'),
      );
    }
  }

  Future<Either<Failure, void>> saveUserData(UserModel user) async {
    try {
      final userJson = jsonEncode(user.toJson());
      await _sharedPreferences.setString('user_data', userJson);
      return Right(null);
    } catch (e) {
      return Left(
        SharedPreferencesFailure(message: 'Failed to save user data: $e'),
      );
    }
  }

  Future<Either<Failure, UserModel?>> getUserData() async {
    try {
      final userDataString = _sharedPreferences.getString('user_data');
      if (userDataString != null) {
        final userData = jsonDecode(userDataString) as Map<String, dynamic>;
        return Right(UserModel.fromJson(userData));
      }
      return Right(null);
    } catch (e) {
      return Left(
        SharedPreferencesFailure(message: 'Failed to retrieve user data: $e'),
      );
    }
  }
}
