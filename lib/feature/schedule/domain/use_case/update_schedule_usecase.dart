import 'package:dartz/dartz.dart';
import 'package:studyspare_b/core/error/failure.dart';
import 'package:studyspare_b/feature/schedule/domain/entity/schedule_entity.dart';
import 'package:studyspare_b/feature/schedule/domain/repository/schedule_repository.dart';

class UpdateScheduleParams {
  final String scheduleId;
  final String title;
  final String? description;
  final DateTime? eventDate;
  final bool isCompleted;
  final String userId;

  UpdateScheduleParams({
    required this.scheduleId,
    required this.title,
    this.description,
    this.eventDate,
    required this.isCompleted,
    required this.userId,
  });
}

class UpdateScheduleUsecase {
  final IScheduleRepository repository;
  UpdateScheduleUsecase(this.repository);

  Future<Either<Failure, ScheduleEntity>> call(
    UpdateScheduleParams params,
  ) async {
    final schedule = ScheduleEntity(
      id: params.scheduleId,
      title: params.title,
      description: params.description,
      eventDate: params.eventDate,
      isCompleted: params.isCompleted,
      userId: params.userId,
    );
    return await repository.updateSchedule(params.scheduleId, schedule);
  }
}
