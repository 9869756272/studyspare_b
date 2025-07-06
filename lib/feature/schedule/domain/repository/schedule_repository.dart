import 'package:dartz/dartz.dart';
import 'package:studyspare_b/core/error/failure.dart';
import 'package:studyspare_b/feature/schedule/domain/entity/schedule_entity.dart';

abstract interface class IScheduleRepository {
  Future<Either<Failure, List<ScheduleEntity>>> getSchedules();
  Future<Either<Failure, ScheduleEntity>> createSchedule(
    ScheduleEntity schedule,
  );
  Future<Either<Failure, ScheduleEntity>> updateSchedule(
    String scheduleId,
    ScheduleEntity schedule,
  );
  Future<Either<Failure, void>> deleteSchedule(String scheduleId);
}
