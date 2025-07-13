import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:studyspare_b/core/error/failure.dart';
import 'package:studyspare_b/feature/auth/domain/entity/user_entity.dart';
import 'package:studyspare_b/feature/auth/domain/repository/user_repositroy.dart';
import 'package:studyspare_b/feature/auth/domain/use_case/user_register_usecase.dart';


// Mock class
class MockUserRepository extends Mock implements IuserRepository {}

void main() {
  late MockUserRepository repository;
  late UserRegisterUsecase usecase;

  setUp(() {
    repository = MockUserRepository();
    usecase = UserRegisterUsecase(userReposiotry: repository);

    // Register fallback for UserEntity used internally in the use case
    registerFallbackValue(UserEntity.empty());
  });

  final params = const RegisterUserParams(
    username: 'Test User',
    email: 'test@email.com',
    password: 'securepassword',
  );

  final expectedUserEntity = UserEntity(
    username: params.username,
    email: params.email,
    password: params.password,
  );

  test('should call registerUser and return Right(null)', () async {
    // Arrange
    when(() => repository.registerUser(any()))
        .thenAnswer((_) async => const Right(null));

    // Act
    final result = await usecase(params);

    // Assert
    expect(result, const Right<Failure, void>(null));
    verify(() => repository.registerUser(expectedUserEntity)).called(1);
  });
}
