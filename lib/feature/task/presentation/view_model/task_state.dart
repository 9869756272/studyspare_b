import 'package:equatable/equatable.dart';
import 'package:studyspare_b/feature/task/domain/entity/task_entity.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object?> get props => [];
}

class TaskInitial extends TaskState {
  const TaskInitial();
}

class TaskLoading extends TaskState {
  const TaskLoading();
}

class TasksLoaded extends TaskState {
  final List<TaskEntity> tasks;
  final List<TaskEntity> pendingTasks;
  final List<TaskEntity> completedTasks;

  const TasksLoaded({
    required this.tasks,
    required this.pendingTasks,
    required this.completedTasks,
  });

  @override
  List<Object?> get props => [tasks, pendingTasks, completedTasks];
}

class TaskCreated extends TaskState {
  final TaskEntity task;

  const TaskCreated({required this.task});

  @override
  List<Object?> get props => [task];
}

class TaskUpdated extends TaskState {
  final TaskEntity task;

  const TaskUpdated({required this.task});

  @override
  List<Object?> get props => [task];
}

class TaskDeleted extends TaskState {
  final String taskId;

  const TaskDeleted({required this.taskId});

  @override
  List<Object?> get props => [taskId];
}

class TaskError extends TaskState {
  final String message;

  const TaskError({required this.message});

  @override
  List<Object?> get props => [message];
}
