import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:studyspare_b/app/auth/auth_provider.dart';
import 'package:studyspare_b/app/auth/user_model.dart';
import 'package:studyspare_b/app/service_locator/service_locator.dart';
import 'package:studyspare_b/core/error/failure.dart';
import 'package:studyspare_b/feature/auth/domain/entity/login_response.dart';
import 'package:studyspare_b/feature/auth/domain/use_case/user_login_usecase.dart';
import 'package:studyspare_b/feature/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:studyspare_b/feature/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:studyspare_b/feature/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:studyspare_b/feature/home/presentation/view/home_view.dart';
import 'package:studyspare_b/feature/home/presentation/view_model/home_view_model.dart';

class MockUserLoginUsecase extends Mock implements UserLoginUsecase {}

class MockAuthProvider extends Mock implements AuthProvider {}

class MockHomeViewModel extends Mock implements HomeViewModel {}

class ServerFailure extends Failure {
  ServerFailure({required super.message});
}

void main() {
  late UserLoginUsecase mockUserLoginUsecase;
  late AuthProvider mockAuthProvider;
  late HomeViewModel mockHomeViewModel;

  setUpAll(() {
    registerFallbackValue(const LoginUsecaseParams(username: '', password: ''));
    registerFallbackValue(
      const UserModel(id: '', name: '', email: '', password: '', role: ''),
    );

    mockAuthProvider = MockAuthProvider();
    if (!serviceLocator.isRegistered<AuthProvider>()) {
      serviceLocator.registerSingleton<AuthProvider>(mockAuthProvider);
    }

    mockHomeViewModel = MockHomeViewModel();
    if (!serviceLocator.isRegistered<HomeViewModel>()) {
      serviceLocator.registerSingleton<HomeViewModel>(mockHomeViewModel);
    }
  });

  setUp(() {
    mockUserLoginUsecase = MockUserLoginUsecase();
    when(() => mockAuthProvider.login(any(), any())).thenAnswer((_) async {});
  });

  group('LoginViewModel Widget Test', () {
    const tUsername = 'testuser';
    const tPassword = 'password';
    const tUser = UserModel(
      id: "1",
      name: tUsername,
      email: tUsername,
      role: "user",
      password: tUsername,
    );
    const tLoginResponse = LoginResponse(token: 'test_token', user: tUser);
    final tFailure = ServerFailure(message: 'Invalid credentials');

    // testWidgets('emits [loading, success] and navigates on successful login', (
    //   WidgetTester tester,
    // ) async {
    //   when(
    //     () => mockUserLoginUsecase(any()),
    //   ).thenAnswer((_) async => const Right(tLoginResponse));

    //   final loginViewModel = LoginViewModel(mockUserLoginUsecase);

    //   expectLater(
    //     loginViewModel.stream,
    //     emitsInOrder(<LoginState>[
    //       const LoginState(isLoading: true, isSuccess: false),
    //       const LoginState(isLoading: false, isSuccess: true),
    //     ]),
    //   );

    //   await tester.pumpWidget(
    //     BlocProvider.value(
    //       value: loginViewModel,
    //       child: MaterialApp(
    //         home: Scaffold(
    //           body: Builder(
    //             builder: (context) {
    //               loginViewModel.add(
    //                 LoginWithuserNameAndPasswordEvent(
    //                   username: tUsername,
    //                   password: tPassword,
    //                   context: context,
    //                 ),
    //               );
    //               return const SizedBox.shrink();
    //             },
    //           ),
    //         ),
    //       ),
    //     ),
    //   );

    //   await tester.pumpAndSettle();

    //   verify(
    //     () => mockUserLoginUsecase(
    //       const LoginUsecaseParams(username: tUsername, password: tPassword),
    //     ),
    //   ).called(1);
    //   verify(() => mockAuthProvider.login('test_token', tUser)).called(1);
    //   expect(find.text('Login Successful'), findsOneWidget);
    //   expect(find.byType(HomeView), findsOneWidget);
    // });

    testWidgets(
      'emits [loading, failure] and shows error snackbar on failed login',
      (WidgetTester tester) async {
        when(
          () => mockUserLoginUsecase(any()),
        ).thenAnswer((_) async => Left(tFailure));

        final loginViewModel = LoginViewModel(mockUserLoginUsecase);

        expectLater(
          loginViewModel.stream,
          emitsInOrder(<LoginState>[
            const LoginState(isLoading: true, isSuccess: false),
            const LoginState(isLoading: false, isSuccess: false),
          ]),
        );

        await tester.pumpWidget(
          BlocProvider.value(
            value: loginViewModel,
            child: MaterialApp(
              home: Scaffold(
                body: Builder(
                  builder: (context) {
                    loginViewModel.add(
                      LoginWithuserNameAndPasswordEvent(
                        username: tUsername,
                        password: 'wrong_password',
                        context: context,
                      ),
                    );
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        verify(
          () => mockUserLoginUsecase(
            const LoginUsecaseParams(
              username: tUsername,
              password: 'wrong_password',
            ),
          ),
        ).called(1);
        verifyNever(() => mockAuthProvider.login(any(), any()));
        expect(
          find.text(
            'Invalid credentials. Please check your username and password.',
          ),
          findsOneWidget,
        );
        expect(find.byType(HomeView), findsNothing);
      },
    );
  });
}
