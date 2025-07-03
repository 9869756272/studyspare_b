
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studyspare_b/app/service_locator/service_locator.dart';
import 'package:studyspare_b/core/common/snackbar.dart';
import 'package:studyspare_b/feature/auth/domain/use_case/user_login_usecase.dart';
import 'package:studyspare_b/feature/auth/presentation/view/sign_up.dart';
import 'package:studyspare_b/feature/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:studyspare_b/feature/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:studyspare_b/feature/auth/presentation/view_model/register_view_model/register_view_model.dart';
import 'package:studyspare_b/screen/dashboardscreen.dart';


class LoginViewModel extends Bloc<LoginEvent, LoginState> {
  final UserLoginUsecase _userLoginUsecase;

  LoginViewModel(this._userLoginUsecase)
      : super(LoginState.initial()) {
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
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: serviceLocator<RegisterViewModel>()),
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
        showMySnackBar(
          context: event.context,
          message: 'Invalid credentials. Please try again.',
          color: Colors.red,
        );
      },
      (token) {
        emit(state.copyWith(isLoading: false, isSuccess: true));
        showMySnackBar(
          context: event.context,
          message: "Login Successful",
          color: Colors.green,
        );

        Navigator.pushReplacement(
          event.context,
          MaterialPageRoute(
            builder: (_) =>  DashboardScreen(),
          ),
        );

        // Optional: Navigate to Home after login
        // add(NavigateToHomeViewEvent(context: event.context));
      },
    );
  }
}