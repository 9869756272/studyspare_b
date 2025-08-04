import 'package:bloc_test/bloc_test.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:studyspare_b/feature/auth/presentation/view/loginpage.dart';
import 'package:studyspare_b/feature/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:studyspare_b/feature/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:studyspare_b/feature/auth/presentation/view_model/login_view_model/login_view_model.dart';

class MockLoginBloc extends MockBloc<LoginEvent, LoginState>
    implements LoginViewModel {}

void main() {
  late MockLoginBloc loginViewModel;

  setUp(() {
    loginViewModel = MockLoginBloc();
  });

  Widget loadLoginView() {
    return BlocProvider<LoginViewModel>(
      create: (context) => loginViewModel,
      child: MaterialApp(home: LoginPage()),
    );
  }

  testWidgets('Check for the text in login UI', (tester) async {
    await tester.pumpWidget(loadLoginView());
    await tester.pumpAndSettle();

    // Find the ElevatedButton with the text 'Sign In'
    final result = find.widgetWithText(ElevatedButton, 'Sign in');

    // Assert it exists
    expect(result, findsOneWidget);
  });

  testWidgets('Check for the email and password', (tester) async {
    await tester.pumpWidget(loadLoginView());
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(0), 'rahul');
    await tester.enterText(find.byType(TextField).at(1), 'password');
    await tester.tap(find.byType(ElevatedButton).first);

    await tester.pumpAndSettle();
    expect(find.text('rahul'), findsOneWidget);
    expect(find.text('password'), findsOneWidget);
  });

  testWidgets('Login success', (tester) async {
    // Arrange - Mock the state
    when(
      () => loginViewModel.state,
    ).thenReturn(LoginState(isLoading: false, isSuccess: true));

    // Act - Render the widget
    await tester.pumpWidget(loadLoginView());
    await tester.pumpAndSettle();

    // Enter valid email and password
    await tester.enterText(find.byType(TextField).at(0), 'rahul');
    await tester.enterText(find.byType(TextField).at(1), 'rahul123');

    // Tap the login button
    await tester.tap(find.byType(ElevatedButton).first);
    await tester.pumpAndSettle();

    // Assert - Ensure login was successful
    expect(loginViewModel.state.isSuccess, true);
  });
}
