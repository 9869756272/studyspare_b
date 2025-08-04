import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studyspare_b/app/auth/auth_provider.dart';
import 'package:studyspare_b/app/service_locator/service_locator.dart';
import 'package:studyspare_b/core/common/snackbar.dart';
import 'package:studyspare_b/feature/auth/domain/use_case/user_login_usecase.dart';
import 'package:studyspare_b/feature/auth/presentation/view/sign_up.dart';
import 'package:studyspare_b/feature/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:studyspare_b/feature/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:studyspare_b/feature/auth/presentation/view_model/register_view_model/register_view_model.dart';
import 'package:studyspare_b/feature/home/presentation/view/home_view.dart';
import 'package:studyspare_b/feature/home/presentation/view_model/home_view_model.dart';

class LoginViewModel extends Bloc<LoginEvent, LoginState> {
  final UserLoginUsecase _userLoginUsecase;
  final AuthProvider _authProvider;

  LoginViewModel(this._userLoginUsecase)
    : _authProvider = serviceLocator<AuthProvider>(),
      super(LoginState.initial()) {
    on<NavigateToRegisterViewEvent>(_onNavigateToRegisterView);
    on<LoginWithuserNameAndPasswordEvent>(_onLoginWithuserNameAndPassword);
  }

  void _onNavigateToRegisterView(
    NavigateToRegisterViewEvent event,
    Emitter<LoginState> emit,
  ) {
    if (event.context.mounted) {
      Navigator.push(
        event.context,
        MaterialPageRoute(
          builder:
              (context) => MultiBlocProvider(
                providers: [
                  BlocProvider.value(
                    value: serviceLocator<RegisterViewModel>(),
                  ),
                ],
                child: SignupScreen(),
              ),
        ),
      );
    }
  }

  void _onLoginWithuserNameAndPassword(
    LoginWithuserNameAndPasswordEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final result = await _userLoginUsecase(
      LoginUsecaseParams(username: event.username, password: event.password),
    );

    result.fold(
      (failure) {
        emit(state.copyWith(isLoading: false, isSuccess: false));

        // Show more specific error messages based on the failure
        String errorMessage = 'Login failed. Please try again.';

        if (failure.message.contains('Connection timeout')) {
          errorMessage =
              'Connection timeout. Please check your internet connection and try again.';
        } else if (failure.message.contains('Connection error')) {
          errorMessage =
              'Connection error. Please check if the server is running.';
        } else if (failure.message.contains('Invalid credentials')) {
          errorMessage =
              'Invalid credentials. Please check your username and password.';
        } else if (failure.message.contains('Login endpoint not found')) {
          errorMessage = 'Server configuration error. Please contact support.';
        } else if (failure.message.contains('HTTP Error: 401')) {
          errorMessage =
              'Invalid credentials. Please check your username and password.';
        } else if (failure.message.contains('HTTP Error: 404')) {
          errorMessage =
              'Login endpoint not found. Please check the API configuration.';
        } else if (failure.message.contains('HTTP Error: 500')) {
          errorMessage = 'Server error. Please try again later.';
        }

        showMySnackBar(
          context: event.context,
          message: errorMessage,
          color: Colors.red,
        );
      },
      (loginResponse) async {
        emit(state.copyWith(isLoading: false, isSuccess: true));

        // Save token and user data
        await _authProvider.login(loginResponse.token, loginResponse.user);

        showMySnackBar(
          context: event.context,
          message: "Login Successful",
          color: Colors.green,
        );

        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          event.context,
          MaterialPageRoute(
            builder:
                (_) => BlocProvider.value(
                  value: serviceLocator<HomeViewModel>(),
                  child: HomeView(),
                ),
          ),
        );

        // Optional: Navigate to Home after login
        // add(NavigateToHomeViewEvent(context: event.context));
      },
    );
  }
}
