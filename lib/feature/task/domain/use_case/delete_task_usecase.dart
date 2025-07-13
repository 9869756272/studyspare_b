import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:studyspare_b/app/usecase/usecase.dart';
import 'package:studyspare_b/core/error/failure.dart';
import 'package:studyspare_b/feature/task/domain/repository/task_repository.dart';

class DeleteTaskParams extends Equatable {
  final String taskId;

  const DeleteTaskParams({required this.taskId});

  @override
  List<Object?> get props => [taskId];
}

class DeleteTaskUsecase implements UsecaseWithParams<void, DeleteTaskParams> {
  final ITaskRepository _taskRepository;

  DeleteTaskUsecase({required ITaskRepository taskRepository})
    : _taskRepository = taskRepository;

  @override
  Future<Either<Failure, void>> call(DeleteTaskParams params) {
    return _taskRepository.deleteTask(params.taskId);
  }
}
