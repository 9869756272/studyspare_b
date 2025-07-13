import 'package:dartz/dartz.dart';
import 'package:studyspare_b/core/error/failure.dart';
import 'package:studyspare_b/feature/task/data/data_source/remote_datasource/task_remote_datasource.dart';
import 'package:studyspare_b/feature/task/data/model/task_api_model.dart';
import 'package:studyspare_b/feature/task/domain/entity/task_entity.dart';
import 'package:studyspare_b/feature/task/domain/repository/task_repository.dart';

class TaskRemoteRepository implements ITaskRepository {
  final TaskRemoteDatasource _taskRemoteDataSource;

  TaskRemoteRepository({required TaskRemoteDatasource taskRemoteDataSource})
    : _taskRemoteDataSource = taskRemoteDataSource;

  @override
  Future<Either<Failure, List<TaskEntity>>> getTasks() async {
    try {
      final result = await _taskRemoteDataSource.getTasks();
      final tasks = result.map((task) => task.toEntity()).toList();
      return Right(tasks);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, TaskEntity>> createTask(TaskEntity task) async {
    try {
      final taskApiModel = TaskApiModel.fromEntity(task);
      final result = await _taskRemoteDataSource.createTask(taskApiModel);
      return Right(result.toEntity());
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, TaskEntity>> updateTask(
    String taskId,
    TaskEntity task,
  ) async {
    try {
      final taskApiModel = TaskApiModel.fromEntity(task);
      final result = await _taskRemoteDataSource.updateTask(
        taskId,
        taskApiModel,
      );
      return Right(result.toEntity());
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTask(String taskId) async {
    try {
      await _taskRemoteDataSource.deleteTask(taskId);
      return const Right(null);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }
}
