import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:studyspare_b/core/error/failure.dart';
import 'package:studyspare_b/feature/schedule/domain/entity/schedule_entity.dart';
import 'package:studyspare_b/feature/schedule/domain/repository/schedule_repository.dart';
import 'package:studyspare_b/feature/schedule/domain/use_case/create_schedule_usecase.dart';

class MockIScheduleRepository extends Mock implements IScheduleRepository {}

void main() {
  late IScheduleRepository mockRepository;
  late CreateScheduleUsecase usecase;

  setUpAll(() {
    registerFallbackValue(
      ScheduleEntity(title: '', userId: '', eventDate: DateTime(2023)),
    );
  });

  setUp(() {
    mockRepository = MockIScheduleRepository();
    usecase = CreateScheduleUsecase(mockRepository);
  });

  final tEventDate = DateTime(2024, 10, 20);
  final tParams = CreateScheduleParams(
    title: 'Team Meeting',
    description: 'Discuss project milestones',
    eventDate: tEventDate,
    userId: 'user123',
  );

  final tScheduleToCreate = ScheduleEntity(
    title: 'Team Meeting',
    description: 'Discuss project milestones',
    eventDate: tEventDate,
    userId: 'user123',
  );

  final tCreatedSchedule = ScheduleEntity(
    id: 'schedule_1',
    title: 'Team Meeting',
    description: 'Discuss project milestones',
    eventDate: tEventDate,
    userId: 'user123',
  );

  group('CreateScheduleUsecase', () {
    test(
      'should call createSchedule on the repository and return the created ScheduleEntity on success',
      () async {
        when(
          () => mockRepository.createSchedule(any()),
        ).thenAnswer((_) async => Right(tCreatedSchedule));

        final result = await usecase(tParams);

        expect(result, Right(tCreatedSchedule));
        verify(
          () => mockRepository.createSchedule(tScheduleToCreate),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'should return a Failure from the repository when creation fails',
      () async {
        final tFailure = RemoteDatabaseFailure(
          message: 'Failed to create schedule',
        );
        when(
          () => mockRepository.createSchedule(any()),
        ).thenAnswer((_) async => Left(tFailure));

        final result = await usecase(tParams);

        expect(result, Left(tFailure));
        verify(
          () => mockRepository.createSchedule(tScheduleToCreate),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );
  });
}
