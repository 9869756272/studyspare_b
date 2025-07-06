import 'package:dartz/dartz.dart';
import 'package:studyspare_b/core/error/failure.dart';
import 'package:studyspare_b/feature/schedule/domain/repository/schedule_repository.dart';

class DeleteScheduleParams {
  final String scheduleId;
  DeleteScheduleParams({required this.scheduleId});
}

class DeleteScheduleUsecase {
  final IScheduleRepository repository;
  DeleteScheduleUsecase(this.repository);

  Future<Either<Failure, void>> call(DeleteScheduleParams params) async {
    return await repository.deleteSchedule(params.scheduleId);
  }
}
