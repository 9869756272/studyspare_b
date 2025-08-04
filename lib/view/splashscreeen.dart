import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studyspare_b/app/auth/auth_provider.dart';
import 'package:studyspare_b/app/service_locator/service_locator.dart';
import 'package:studyspare_b/feature/auth/presentation/view/loginpage.dart';
import 'package:studyspare_b/feature/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:studyspare_b/feature/home/presentation/view/home_view.dart';
import 'package:studyspare_b/feature/home/presentation/view_model/home_view_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    // Check authentication status
    await serviceLocator<AuthProvider>().checkAuthStatus();
  }

  void _navigateBasedOnAuthState(AuthState state) {
    if (_hasNavigated) return;

    _hasNavigated = true;

    if (state.isAuthenticated) {
      // User is authenticated, navigate to home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) => BlocProvider.value(
                value: serviceLocator<HomeViewModel>(),
                child: const HomeView(),
              ),
        ),
      );
    } else {
      // User is not authenticated, navigate to login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) => BlocProvider.value(
                value: serviceLocator<LoginViewModel>(),
                child: const LoginPage(),
              ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthProvider, AuthState>(
      listener: (context, state) {
        // Only navigate when loading is false (auth check is complete)
        if (!state.isLoading) {
          _navigateBasedOnAuthState(state);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'StudySphere',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),
                  Image.asset('assets/images/logo.png', height: 200),
                  const SizedBox(height: 30),
                  const Text(
                    'Upgrade your Coding Skills\nWith Studysphere',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 40),
                  const CircularProgressIndicator(color: Colors.red),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
