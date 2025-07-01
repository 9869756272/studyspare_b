import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studyspare_b/app/shared_preference/token_shared_prefs.dart';
import 'package:studyspare_b/app/auth/user_model.dart';

// Auth State
class AuthState {
  final bool isAuthenticated;
  final String? token;
  final UserModel? user;
  final bool isLoading;
  final String? error;

  const AuthState({
    this.isAuthenticated = false,
    this.token,
    this.user,
    this.isLoading = false,
    this.error,
  });
  //uninitialized state
  const AuthState.uninitialized()
    : isAuthenticated = false,
      token = null,
      user = null,
      isLoading = false,
      error = null;

  AuthState copyWith({
    bool? isAuthenticated,
    String? token,
    UserModel? user,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      token: token ?? this.token,
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

// Auth Events
abstract class AuthEvent {}

class AuthCheckEvent extends AuthEvent {}

class AuthLoginEvent extends AuthEvent {
  final String token;
  final UserModel user;
  AuthLoginEvent(this.token, this.user);
}

class AuthLogoutEvent extends AuthEvent {}

class AuthLoadingEvent extends AuthEvent {
  final bool isLoading;
  AuthLoadingEvent(this.isLoading);
}

// Auth Provider (Cubit)
class AuthProvider extends Cubit<AuthState> {
  final TokenSharedPrefs _tokenSharedPrefs;

  AuthProvider({required TokenSharedPrefs tokenSharedPrefs})
    : _tokenSharedPrefs = tokenSharedPrefs,
      super(const AuthState());

  // Check if user is authenticated on app start
  Future<void> checkAuthStatus() async {
    emit(state.copyWith(isLoading: true));

    final tokenResult = await _tokenSharedPrefs.getToken();
    final userResult = await _tokenSharedPrefs.getUserData();

    tokenResult.fold(
      (failure) {
        emit(
          state.copyWith(
            isLoading: false,
            isAuthenticated: false,
            error: failure.message,
          ),
        );
      },
      (token) async {
        if (token != null && token.isNotEmpty) {
          // Get user data
          userResult.fold(
            (userFailure) {
              emit(
                state.copyWith(
                  isLoading: false,
                  isAuthenticated: false,
                  error: userFailure.message,
                ),
              );
            },
            (user) {
              emit(
                state.copyWith(
                  isLoading: false,
                  isAuthenticated: true,
                  token: token,
                  user: user,
                ),
              );
            },
          );
        } else {
          emit(state.copyWith(isLoading: false, isAuthenticated: false));
        }
      },
    );
  }

  // Login user and save token
  Future<void> login(String token, UserModel user) async {
    emit(state.copyWith(isLoading: true));

    final saveTokenResult = await _tokenSharedPrefs.saveToken(token);
    final saveUserResult = await _tokenSharedPrefs.saveUserData(user);

    if (saveTokenResult.isLeft() || saveUserResult.isLeft()) {
      emit(
        state.copyWith(
          isLoading: false,
          error: 'Failed to save authentication data',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        token: token,
        user: user,
      ),
    );
  }

  // Logout user and clear token
  Future<void> logout() async {
    emit(state.copyWith(isLoading: true));

    final clearResult = await _tokenSharedPrefs.clearToken();

    clearResult.fold(
      (failure) {
        emit(state.copyWith(isLoading: false, error: failure.message));
      },
      (_) {
        emit(
          state.copyWith(
            isLoading: false,
            isAuthenticated: false,
            token: null,
            user: null,
          ),
        );
      },
    );
  }

  // Set loading state
  void setLoading(bool isLoading) {
    emit(state.copyWith(isLoading: isLoading));
  }

  // Clear error
  void clearError() {
    emit(state.copyWith(error: null));
  }

  // Get current token
  String? get currentToken => state.token;

  // Get current user
  UserModel? get currentUser => state.user;

  // Check if user is currently authenticated
  bool get isAuthenticated => state.isAuthenticated;
}
