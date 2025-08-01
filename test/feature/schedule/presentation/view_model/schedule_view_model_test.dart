import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:studyspare_b/core/error/failure.dart';
import 'package:studyspare_b/feature/schedule/domain/entity/schedule_entity.dart';
import 'package:studyspare_b/feature/schedule/domain/repository/schedule_repository.dart';
import 'package:studyspare_b/feature/schedule/domain/use_case/create_schedule_usecase.dart';

class MockScheduleRepository extends Mock implements IScheduleRepository {}

class FakeScheduleEntity extends Fake implements ScheduleEntity {}

void main() {
  late MockScheduleRepository repository;
  late CreateScheduleUsecase usecase;

  setUpAll(() {
    registerFallbackValue(FakeScheduleEntity());
  });

  setUp(() {
    repository = MockScheduleRepository();
    usecase = CreateScheduleUsecase(repository);
  });

  final tScheduleEntity = ScheduleEntity(
    id: "schedule123",
    title: "Test Schedule",
    description: "Test Description",
    eventDate: DateTime.parse("2025-07-30T10:00:00Z"),
    userId: "user123",
  );

  final tParams = CreateScheduleParams(
    title: "Test Schedule",
    description: "Test Description",
    eventDate: DateTime.parse("2025-07-30T10:00:00Z"),
    userId: "user123",
  );

  test(
    'should call createSchedule on the repository and return the created entity on success',
    () async {
      // Arrange
      when(
        () => repository.createSchedule(any()),
      ).thenAnswer((_) async => Right(tScheduleEntity));

      // Act
      final result = await usecase(tParams);

      // Assert
      expect(result, Right<Failure, ScheduleEntity>(tScheduleEntity));

      verify(() => repository.createSchedule(any())).called(1);
    },
  );
}
