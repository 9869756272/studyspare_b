import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:studyspare_b/core/error/failure.dart';
import 'package:studyspare_b/feature/auth/domain/entity/user_entity.dart';
import 'package:studyspare_b/feature/auth/domain/repository/user_repositroy.dart';
import 'package:studyspare_b/feature/auth/domain/use_case/user_register_usecase.dart';

class MockIuserRepository extends Mock implements IuserRepository {}

class ServerFailure extends Failure {
  ServerFailure({required super.message});
}

void main() {
  late IuserRepository mockRepository;
  late UserRegisterUsecase usecase;

  setUpAll(() {
    registerFallbackValue(const UserEntity(name: '', email: '', password: ''));
  });

  setUp(() {
    mockRepository = MockIuserRepository();
    usecase = UserRegisterUsecase(userReposiotry: mockRepository);
  });

  const tParams = RegisterUserParams(
    name: 'Test User',
    email: 'test@example.com',
    password: 'password123',
  );

  const tUserEntity = UserEntity(
    name: 'Test User',
    email: 'test@example.com',
    password: 'password123',
  );

  group('UserRegisterUsecase', () {
    test(
      'should call registerUser on the repository and return Right(null) on success',
      () async {
        when(
          () => mockRepository.registerUser(any()),
        ).thenAnswer((_) async => const Right(null));

        final result = await usecase(tParams);

        expect(result, const Right(null));
        verify(() => mockRepository.registerUser(tUserEntity)).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test('should return a Failure from the repository on failure', () async {
      final tFailure = ServerFailure(message: 'Registration Failed');
      when(
        () => mockRepository.registerUser(any()),
      ).thenAnswer((_) async => Left(tFailure));

      final result = await usecase(tParams);

      expect(result, Left(tFailure));
      verify(() => mockRepository.registerUser(tUserEntity)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
