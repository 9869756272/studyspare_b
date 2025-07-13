import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studyspare_b/feature/task/domain/use_case/create_task_usecase.dart';
import 'package:studyspare_b/feature/task/domain/use_case/delete_task_usecase.dart';
import 'package:studyspare_b/feature/task/domain/use_case/get_tasks_usecase.dart';
import 'package:studyspare_b/feature/task/domain/use_case/update_task_usecase.dart';
import 'package:studyspare_b/feature/task/presentation/view_model/task_event.dart';
import 'package:studyspare_b/feature/task/presentation/view_model/task_state.dart';

class TaskViewModel extends Bloc<TaskEvent, TaskState> {
  final GetTasksUsecase _getTasksUsecase;
  final CreateTaskUsecase _createTaskUsecase;
  final UpdateTaskUsecase _updateTaskUsecase;
  final DeleteTaskUsecase _deleteTaskUsecase;

  TaskViewModel({
    required GetTasksUsecase getTasksUsecase,
    required CreateTaskUsecase createTaskUsecase,
    required UpdateTaskUsecase updateTaskUsecase,
    required DeleteTaskUsecase deleteTaskUsecase,
  }) : _getTasksUsecase = getTasksUsecase,
       _createTaskUsecase = createTaskUsecase,
       _updateTaskUsecase = updateTaskUsecase,
       _deleteTaskUsecase = deleteTaskUsecase,
       super(const TaskInitial()) {
    on<LoadTasks>(_onLoadTasks);
    on<CreateTask>(_onCreateTask);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
    on<ToggleTaskComplete>(_onToggleTaskComplete);
  }

  Future<void> _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) async {
    emit(const TaskLoading());

    final result = await _getTasksUsecase();

    result.fold((failure) => emit(TaskError(message: failure.message)), (
      tasks,
    ) {
      final pendingTasks = tasks.where((task) => !task.isCompleted).toList();
      final completedTasks = tasks.where((task) => task.isCompleted).toList();

      emit(
        TasksLoaded(
          tasks: tasks,
          pendingTasks: pendingTasks,
          completedTasks: completedTasks,
        ),
      );
    });
  }

  Future<void> _onCreateTask(CreateTask event, Emitter<TaskState> emit) async {
    emit(const TaskLoading());

    final result = await _createTaskUsecase(
      CreateTaskParams(
        title: event.title,
        description: event.description,
        dueDate: event.dueDate,
        userId: event.userId,
      ),
    );

    result.fold((failure) => emit(TaskError(message: failure.message)), (task) {
      emit(TaskCreated(task: task));
      add(const LoadTasks());
    });
  }

  Future<void> _onUpdateTask(UpdateTask event, Emitter<TaskState> emit) async {
    emit(const TaskLoading());

    final result = await _updateTaskUsecase(
      UpdateTaskParams(
        taskId: event.task.id!,
        title: event.task.title,
        description: event.task.description,
        dueDate: event.task.dueDate,
        isCompleted: event.isCompleted,
        userId: event.task.userId,
      ),
    );

    result.fold((failure) => emit(TaskError(message: failure.message)), (task) {
      emit(TaskUpdated(task: task));
      add(const LoadTasks());
    });
  }

  Future<void> _onDeleteTask(DeleteTask event, Emitter<TaskState> emit) async {
    emit(const TaskLoading());

    final result = await _deleteTaskUsecase(
      DeleteTaskParams(taskId: event.taskId),
    );

    result.fold((failure) => emit(TaskError(message: failure.message)), (_) {
      emit(TaskDeleted(taskId: event.taskId));
      add(const LoadTasks());
    });
  }

  Future<void> _onToggleTaskComplete(
    ToggleTaskComplete event,
    Emitter<TaskState> emit,
  ) async {
    emit(const TaskLoading());

    final result = await _updateTaskUsecase(
      UpdateTaskParams(
        taskId: event.task.id!,
        title: event.task.title,
        description: event.task.description,
        dueDate: event.task.dueDate,
        isCompleted: !event.task.isCompleted,
        userId: event.task.userId,
      ),
    );

    result.fold((failure) => emit(TaskError(message: failure.message)), (task) {
      emit(TaskUpdated(task: task));
      add(const LoadTasks());
    });
  }
}
