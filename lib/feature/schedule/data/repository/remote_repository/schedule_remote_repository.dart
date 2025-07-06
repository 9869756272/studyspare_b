import 'package:dartz/dartz.dart';
import 'package:studyspare_b/core/error/failure.dart';
import 'package:studyspare_b/feature/schedule/data/data_source/remote_datasource/schedule_remote_datasource.dart';
import 'package:studyspare_b/feature/schedule/data/model/schedule_api_model.dart';
import 'package:studyspare_b/feature/schedule/domain/entity/schedule_entity.dart';
import 'package:studyspare_b/feature/schedule/domain/repository/schedule_repository.dart';

class ScheduleRemoteRepository implements IScheduleRepository {
  final ScheduleRemoteDatasource _scheduleRemoteDataSource;

  ScheduleRemoteRepository({
    required ScheduleRemoteDatasource scheduleRemoteDataSource,
  }) : _scheduleRemoteDataSource = scheduleRemoteDataSource;

  @override
  Future<Either<Failure, List<ScheduleEntity>>> getSchedules() async {
    try {
      final result = await _scheduleRemoteDataSource.getSchedules();
      final schedules = result.map((e) => e.toEntity()).toList();
      return Right(schedules);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ScheduleEntity>> createSchedule(
    ScheduleEntity schedule,
  ) async {
    try {
      final apiModel = ScheduleApiModel.fromEntity(schedule);
      final result = await _scheduleRemoteDataSource.createSchedule(apiModel);
      return Right(result.toEntity());
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ScheduleEntity>> updateSchedule(
    String scheduleId,
    ScheduleEntity schedule,
  ) async {
    try {
      final apiModel = ScheduleApiModel.fromEntity(schedule);
      final result = await _scheduleRemoteDataSource.updateSchedule(
        scheduleId,
        apiModel,
      );
      return Right(result.toEntity());
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteSchedule(String scheduleId) async {
    try {
      await _scheduleRemoteDataSource.deleteSchedule(scheduleId);
      return const Right(null);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }
}
