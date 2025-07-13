import 'package:dartz/dartz.dart';
import 'package:studyspare_b/app/usecase/usecase.dart';
import 'package:studyspare_b/core/error/failure.dart';
import 'package:studyspare_b/feature/task/domain/entity/task_entity.dart';
import 'package:studyspare_b/feature/task/domain/repository/task_repository.dart';

class GetTasksUsecase implements UsecaseWithoutParams<List<TaskEntity>> {
  final ITaskRepository _taskRepository;

  GetTasksUsecase({required ITaskRepository taskRepository})
    : _taskRepository = taskRepository;

  @override
  Future<Either<Failure, List<TaskEntity>>> call() {
    return _taskRepository.getTasks();
  }
}
