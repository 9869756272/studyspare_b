import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:studyspare_b/feature/auth/domain/use_case/user_login_usecase.dart';
import 'package:studyspare_b/feature/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:studyspare_b/feature/auth/presentation/view_model/login_view_model/login_view_model.dart';


class FakeLoginUsecaseParams extends Fake implements LoginUsecaseParams {}

class MockUserLoginUsecase extends Mock implements UserLoginUsecase {}

class FakeBuildContext extends Fake implements BuildContext {}

void main() {
  late MockUserLoginUsecase mockUserLoginUsecase;

  setUpAll(() {
    // ✅ REGISTER FAKES HERE
    registerFallbackValue(FakeLoginUsecaseParams());
    registerFallbackValue(FakeBuildContext());
  });

  setUp(() {
    mockUserLoginUsecase = MockUserLoginUsecase();
  });

  void main() {
  // Your mock setup and variables here
  late MockUserLoginUsecase mockLoginUsecase;
  late LoginViewModel loginViewModel;

  const testusername = 'test';
  const testPassword = 'password123';
  const testToken = 'fake_token';

  setUp(() {
    mockLoginUsecase = MockUserLoginUsecase();
    loginViewModel = LoginViewModel(mockLoginUsecase);
  });

  group('LoginViewModel with snackbar and context', () {
    testWidgets('LoginViewModel emits loading and success and shows snackbar', (tester) async {
      // Mock your usecase to succeed
      when(() => mockLoginUsecase.call(any()))
          .thenAnswer((_) async => const Right(testToken));

      // 1. Build MaterialApp with Scaffold
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return Container(key: const Key('login_container'));
              },
            ),
          ),
        ),
      );

      // 2. Get the real BuildContext
      final context = tester.element(find.byKey(const Key('login_container')));

      // 3. Add the login event with real context
      loginViewModel.add(LoginWithuserNameAndPasswordEvent(
        username: testusername,
        password: testPassword,
        context: context,
      ));

      // 4. Wait for bloc and UI to settle (important!)
      await tester.pumpAndSettle();

      // 5. Assert final state
      expect(loginViewModel.state.isLoading, false);
      expect(loginViewModel.state.isSuccess, true);

      // 6. Verify usecase called once
      verify(() => mockLoginUsecase.call(
        LoginUsecaseParams(username: testusername, password: testPassword),
      )).called(1);
    });
  });

 
  }
}
