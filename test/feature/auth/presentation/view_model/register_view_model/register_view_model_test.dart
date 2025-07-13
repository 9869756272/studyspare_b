import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:studyspare_b/feature/auth/domain/use_case/user_register_usecase.dart';
import 'package:studyspare_b/feature/auth/presentation/view_model/register_view_model/register_event.dart';
import 'package:studyspare_b/feature/auth/presentation/view_model/register_view_model/register_view_model.dart';

class MockRegisterUseCase extends Mock implements UserRegisterUsecase {}

class FakeRegisterUserParams extends Fake implements RegisterUserParams {}

void main() {
  late MockRegisterUseCase mockUseCase;

  setUpAll(() {
    registerFallbackValue(FakeRegisterUserParams());
  });

  setUp(() {
    mockUseCase = MockRegisterUseCase();
  });

  testWidgets('RegisterViewModel emits loading and success and shows snackbar', (tester) async {
    when(() => mockUseCase.call(any()))
        .thenAnswer((_) async => const Right(true));

    final viewModel = RegisterViewModel(registerUsecase: mockUseCase);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider.value(
            value: viewModel,
            child: Builder(
              builder: (context) {
                return Center(
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<RegisterViewModel>().add(
                            RegisterUserEvent(
                              username: 'rahul',
                              email: 'rahul@example.com',
                              password: 'password123',
                              context: context,
                            ),
                          );
                    },
                    child: const Text('Register'),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Register'));
    await tester.pump(); 
    await tester.pump(const Duration(seconds: 1));

  
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text(' Registered successful!'), findsOneWidget);
  });
}
