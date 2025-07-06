import 'package:dartz/dartz.dart';
import 'package:studyspare_b/core/error/failure.dart';
import 'package:studyspare_b/feature/schedule/domain/entity/schedule_entity.dart';
import 'package:studyspare_b/feature/schedule/domain/repository/schedule_repository.dart';

class GetSchedulesUsecase {
  final IScheduleRepository repository;
  GetSchedulesUsecase(this.repository);

  Future<Either<Failure, List<ScheduleEntity>>> call() async {
    return await repository.getSchedules();
  }
}
