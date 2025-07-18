
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:studyspare_b/feature/auth/presentation/view/sign_up.dart';
import 'package:studyspare_b/feature/auth/presentation/view_model/register_view_model/register_view_model.dart';

class MockRegisterViewModel extends Mock implements RegisterViewModel {}

void main() {
  late RegisterViewModel mockRegisterViewModel;

  setUp(() {
    mockRegisterViewModel = MockRegisterViewModel();
  });

  Widget loadRegisterView() {
    return MaterialApp(
      home: Scaffold(
        body: BlocProvider<RegisterViewModel>(
          create: (_) => mockRegisterViewModel,
          child: const SignupScreen(),
        ),
      ),
    );
  }

 testWidgets('Show validation errors on empty form submission', (tester) async {
  await tester.pumpWidget(loadRegisterView());
  await tester.pumpAndSettle();

  // Find the Register button
  final registerButton = find.widgetWithText(ElevatedButton, 'Sign up');
  expect(registerButton, findsOneWidget);

  // Ensure it's visible before tapping
  await tester.ensureVisible(registerButton);
  await tester.tap(registerButton);
  await tester.pumpAndSettle();

  // Validate error messages appear
  expect(find.text('Username is required'), findsOneWidget);
  expect(find.text('Email is required'), findsOneWidget);
  expect(find.text('Password must be at least 6 characters'), findsOneWidget);
});





testWidgets('Form fills successfully with valid input', (tester) async {
  await tester.pumpWidget(loadRegisterView());
  await tester.pumpAndSettle();

  await tester.enterText(find.byType(TextFormField).at(0), 'rahul');
  await tester.enterText(find.byType(TextFormField).at(1), 'rahul@example.com');
  await tester.enterText(find.byType(TextFormField).at(2), 'password123');

  final signUpButton = find.widgetWithText(ElevatedButton, 'Sign up');
  expect(signUpButton, findsOneWidget);

  await tester.tap(signUpButton);
  await tester.pumpAndSettle();

  expect(find.textContaining('required'), findsNothing);
  expect(find.textContaining('valid'), findsNothing);
});

  
}
