import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:studyspare_b/app/usecase/usecase.dart';
import 'package:studyspare_b/core/error/failure.dart';
import 'package:studyspare_b/feature/task/domain/entity/task_entity.dart';
import 'package:studyspare_b/feature/task/domain/repository/task_repository.dart';

class UpdateTaskParams extends Equatable {
  final String taskId;
  final String title;
  final String? description;
  final DateTime? dueDate;
  final bool isCompleted;
  final String userId;

  const UpdateTaskParams({
    required this.taskId,
    required this.title,
    this.description,
    this.dueDate,
    required this.isCompleted,
    required this.userId,
  });

  @override
  List<Object?> get props => [
    taskId,
    title,
    description,
    dueDate,
    isCompleted,
    userId,
  ];
}

class UpdateTaskUsecase
    implements UsecaseWithParams<TaskEntity, UpdateTaskParams> {
  final ITaskRepository _taskRepository;

  UpdateTaskUsecase({required ITaskRepository taskRepository})
    : _taskRepository = taskRepository;

  @override
  Future<Either<Failure, TaskEntity>> call(UpdateTaskParams params) {
    final task = TaskEntity(
      id: params.taskId,
      title: params.title,
      description: params.description,
      dueDate: params.dueDate,
      isCompleted: params.isCompleted,
      userId: params.userId,
    );
    return _taskRepository.updateTask(params.taskId, task);
  }
}
