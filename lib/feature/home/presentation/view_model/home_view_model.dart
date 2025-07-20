import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studyspare_b/app/auth/auth_provider.dart';
import 'package:studyspare_b/app/service_locator/service_locator.dart';
import 'package:studyspare_b/feature/auth/presentation/view/loginpage.dart';
import 'package:studyspare_b/feature/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:studyspare_b/feature/home/presentation/view_model/home_state.dart';

class HomeViewModel extends Cubit<HomeState> {
  final AuthProvider _authProvider;

  HomeViewModel()
    : _authProvider = serviceLocator<AuthProvider>(),
      super(HomeState.initial());

  void onTabTapped(int index) {
    emit(state.copyWith(selectedIndex: index));
  }

  Future<void> logout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(dialogContext).pop(false),
            ),
            TextButton(
              child: const Text('Logout'),
              onPressed: () => Navigator.of(dialogContext).pop(true),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    // Clear token and update auth state
    await _authProvider.logout();

    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder:
              (context) => BlocProvider.value(
                value: serviceLocator<LoginViewModel>(),
                child: LoginPage(),
              ),
        ),
        (route) => false,
      );
    }
  }
}

class SessionCubit {}
