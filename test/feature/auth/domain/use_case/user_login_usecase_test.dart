import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:studyspare_b/app/auth/user_model.dart';
import 'package:studyspare_b/core/error/failure.dart';
import 'package:studyspare_b/feature/auth/domain/entity/login_response.dart';
import 'package:studyspare_b/feature/auth/domain/repository/user_repositroy.dart';
import 'package:studyspare_b/feature/auth/domain/use_case/user_login_usecase.dart';

class MockIuserRepository extends Mock implements IuserRepository {}

class ServerFailure extends Failure {
  ServerFailure({required super.message});
}

void main() {
  late IuserRepository mockRepository;
  late UserLoginUsecase usecase;

  setUp(() {
    mockRepository = MockIuserRepository();
    usecase = UserLoginUsecase(userRepository: mockRepository);
  });

  const tParams = LoginUsecaseParams(
    username: 'test@example.com',
    password: 'password123',
  );

  const tLoginResponse = LoginResponse(
    token: 'test_token',
    user: UserModel(
      name: 'Test User',
      email: 'test@example.com',
      password: 'password123',
      id: '',
      role: '',
    ),
  );

  group('UserLoginUsecase', () {
    test(
      'should call loginUser on the repository and return LoginResponse on success',
      () async {
        when(
          () => mockRepository.loginUser(any(), any()),
        ).thenAnswer((_) async => const Right(tLoginResponse));

        final result = await usecase(tParams);

        expect(result, const Right(tLoginResponse));
        verify(
          () => mockRepository.loginUser(tParams.username, tParams.password),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'should return a Failure from the repository when login fails',
      () async {
        final tFailure = ServerFailure(message: 'Invalid Credentials');
        when(
          () => mockRepository.loginUser(any(), any()),
        ).thenAnswer((_) async => Left(tFailure));

        final result = await usecase(tParams);

        expect(result, Left(tFailure));
        verify(
          () => mockRepository.loginUser(tParams.username, tParams.password),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );
  });
}
