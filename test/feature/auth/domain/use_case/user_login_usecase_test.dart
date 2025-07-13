
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:studyspare_b/core/error/failure.dart';
import 'package:studyspare_b/feature/auth/domain/repository/user_repositroy.dart';
import 'package:studyspare_b/feature/auth/domain/use_case/user_login_usecase.dart';



class MockUserRepository extends Mock implements IuserRepository {}

void main() {
  late MockUserRepository repository;
  late UserLoginUsecase usecase;

  setUp(() {
    repository = MockUserRepository();
    usecase = UserLoginUsecase(userRepository: repository);
  });

  const params = LoginUsecaseParams(username: "rahul", password: "123456");

  test('should call loginUser and return Right with token string', () async {
    // Arrange
    const expectedToken = "fake_token_123";
    when(() => repository.loginUser(params.username, params.password))
        .thenAnswer((_) async => const Right(expectedToken));

    // Act
    final result = await usecase(params);

    // Assert
    expect(result, const Right<Failure, String>(expectedToken));
    verify(() => repository.loginUser(params.username, params.password)).called(1);
  });
}

