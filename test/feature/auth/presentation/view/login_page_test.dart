import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:studyspare_b/feature/auth/presentation/view/loginpage.dart';

void main() {
  testWidgets('should display login form with email and password fields', (
    WidgetTester tester,
  ) async {
    // Arrange
    await tester.pumpWidget(MaterialApp(home: LoginPage()));

    // Act
    await tester.pumpAndSettle();

    // Assert
    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.text('Sign in'), findsOneWidget);
  });
}
