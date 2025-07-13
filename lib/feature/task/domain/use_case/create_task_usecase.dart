import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:studyspare_b/app/usecase/usecase.dart';
import 'package:studyspare_b/core/error/failure.dart';
import 'package:studyspare_b/feature/task/domain/entity/task_entity.dart';
import 'package:studyspare_b/feature/task/domain/repository/task_repository.dart';

class CreateTaskParams extends Equatable {
  final String title;
  final String? description;
  final DateTime? dueDate;
  final String userId;

  const CreateTaskParams({
    required this.title,
    this.description,
    this.dueDate,
    required this.userId,
  });

  @override
  List<Object?> get props => [title, description, dueDate, userId];
}

class CreateTaskUsecase
    implements UsecaseWithParams<TaskEntity, CreateTaskParams> {
  final ITaskRepository _taskRepository;

  CreateTaskUsecase({required ITaskRepository taskRepository})
    : _taskRepository = taskRepository;

  @override
  Future<Either<Failure, TaskEntity>> call(CreateTaskParams params) {
    final task = TaskEntity(
      title: params.title,
      description: params.description,
      dueDate: params.dueDate,
      userId: params.userId,
    );
    return _taskRepository.createTask(task);
  }
}
