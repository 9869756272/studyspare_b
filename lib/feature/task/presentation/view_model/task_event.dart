import 'package:equatable/equatable.dart';
import 'package:studyspare_b/feature/task/domain/entity/task_entity.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class LoadTasks extends TaskEvent {
  const LoadTasks();
}

class CreateTask extends TaskEvent {
  final String title;
  final String? description;
  final DateTime? dueDate;
  final String userId;

  const CreateTask({
    required this.title,
    this.description,
    this.dueDate,
    required this.userId,
  });

  @override
  List<Object?> get props => [title, description, dueDate, userId];
}

class UpdateTask extends TaskEvent {
  final TaskEntity task;
  final bool isCompleted;

  const UpdateTask({required this.task, required this.isCompleted});

  @override
  List<Object?> get props => [task, isCompleted];
}

class DeleteTask extends TaskEvent {
  final String taskId;

  const DeleteTask({required this.taskId});

  @override
  List<Object?> get props => [taskId];
}

class ToggleTaskComplete extends TaskEvent {
  final TaskEntity task;

  const ToggleTaskComplete({required this.task});

  @override
  List<Object?> get props => [task];
}
