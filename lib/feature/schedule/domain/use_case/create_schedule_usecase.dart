import 'package:dartz/dartz.dart';
import 'package:studyspare_b/core/error/failure.dart';
import 'package:studyspare_b/feature/schedule/domain/entity/schedule_entity.dart';
import 'package:studyspare_b/feature/schedule/domain/repository/schedule_repository.dart';

class CreateScheduleParams {
  final String title;
  final String? description;
  final DateTime? eventDate;
  final String userId;

  CreateScheduleParams({
    required this.title,
    this.description,
    this.eventDate,
    required this.userId,
  });
}

class CreateScheduleUsecase {
  final IScheduleRepository repository;
  CreateScheduleUsecase(this.repository);

  Future<Either<Failure, ScheduleEntity>> call(
    CreateScheduleParams params,
  ) async {
    final schedule = ScheduleEntity(
      title: params.title,
      description: params.description,
      eventDate: params.eventDate,
      userId: params.userId,
    );
    return await repository.createSchedule(schedule);
  }
}
