import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:studyspare_b/app/service_locator/service_locator.dart';
import 'package:studyspare_b/core/error/failure.dart';
import 'package:studyspare_b/feature/auth/domain/use_case/user_register_usecase.dart';
import 'package:studyspare_b/feature/auth/presentation/view/loginpage.dart'
    show LoginPage;
import 'package:studyspare_b/feature/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:studyspare_b/feature/auth/presentation/view_model/register_view_model/register_event.dart';
import 'package:studyspare_b/feature/auth/presentation/view_model/register_view_model/register_state.dart';
import 'package:studyspare_b/feature/auth/presentation/view_model/register_view_model/register_view_model.dart';

// Mocks
class MockUserRegisterUsecase extends Mock implements UserRegisterUsecase {}

class MockLoginViewModel extends Mock implements LoginViewModel {}

class ServerFailure extends Failure {
  ServerFailure({required super.message});
}

void main() {
  late UserRegisterUsecase mockUserRegisterUsecase;
  late LoginViewModel mockLoginViewModel;

  setUpAll(() {
    registerFallbackValue(
      const RegisterUserParams(name: '', email: '', password: ''),
    );

    mockLoginViewModel = MockLoginViewModel();
    if (!serviceLocator.isRegistered<LoginViewModel>()) {
      serviceLocator.registerSingleton<LoginViewModel>(mockLoginViewModel);
    }
  });

  setUp(() {
    mockUserRegisterUsecase = MockUserRegisterUsecase();
  });

  group('RegisterViewModel Widget Test', () {
    const tName = 'test user';
    const tEmail = 'test@example.com';
    const tPassword = 'password123';

    final tFailure = ServerFailure(message: 'Email already in use');

    testWidgets(
      'emits [loading, success] and shows snackbar/navigates on successful registration',
      (WidgetTester tester) async {
        // ARRANGE: Set up the mock use case to return success
        when(
          () => mockUserRegisterUsecase(any()),
        ).thenAnswer((_) async => const Right(null));

        final registerViewModel = RegisterViewModel(
          registerUsecase: mockUserRegisterUsecase,
        );

        expectLater(
          registerViewModel.stream,
          emitsInOrder(<RegisterState>[
            const RegisterState(isLoading: true, isSuccess: false),
            const RegisterState(isLoading: false, isSuccess: true),
          ]),
        );

        // ACT: Pump a widget that provides the BLoC and a real BuildContext
        await tester.pumpWidget(
          BlocProvider.value(
            value: registerViewModel,
            child: MaterialApp(
              home: Scaffold(
                body: Builder(
                  builder: (context) {
                    registerViewModel.add(
                      RegisterUserEvent(
                        name: tName,
                        email: tEmail,
                        password: tPassword,
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

        verify(() => mockUserRegisterUsecase(any())).called(1);
        expect(find.text(' Registration successful!'), findsOneWidget);
        expect(find.byType(LoginPage), findsOneWidget);
      },
    );

    testWidgets(
      'emits [loading, failure] and shows error snackbar on failed registration',
      (WidgetTester tester) async {
        when(
          () => mockUserRegisterUsecase(any()),
        ).thenAnswer((_) async => Left(tFailure));

        final registerViewModel = RegisterViewModel(
          registerUsecase: mockUserRegisterUsecase,
        );

        expectLater(
          registerViewModel.stream,
          emitsInOrder(<RegisterState>[
            const RegisterState(isLoading: true, isSuccess: false),
            const RegisterState(isLoading: false, isSuccess: false),
          ]),
        );

        await tester.pumpWidget(
          BlocProvider.value(
            value: registerViewModel,
            child: MaterialApp(
              home: Scaffold(
                body: Builder(
                  builder: (context) {
                    registerViewModel.add(
                      RegisterUserEvent(
                        name: tName,
                        email: tEmail,
                        password: tPassword,
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

        // Let the UI rebuild to show the snackbar
        await tester.pumpAndSettle();

        // VERIFY
        verify(() => mockUserRegisterUsecase(any())).called(1);
        // Verify that the error snackbar appeared
        expect(
          find.text('Failed to register : Email already in use'),
          findsOneWidget,
        );
        // Verify that we DID NOT navigate
        expect(find.byType(LoginPage), findsNothing);
      },
    );
  });
}
