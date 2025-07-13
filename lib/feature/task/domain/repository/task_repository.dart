import 'package:dartz/dartz.dart';
import 'package:studyspare_b/core/error/failure.dart';
import 'package:studyspare_b/feature/task/domain/entity/task_entity.dart';

abstract interface class ITaskRepository {
  Future<Either<Failure, List<TaskEntity>>> getTasks();
  Future<Either<Failure, TaskEntity>> createTask(TaskEntity task);
  Future<Either<Failure, TaskEntity>> updateTask(
    String taskId,
    TaskEntity task,
  );
  Future<Either<Failure, void>> deleteTask(String taskId);
}
