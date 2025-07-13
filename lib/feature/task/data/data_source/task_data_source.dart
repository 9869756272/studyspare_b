import 'package:studyspare_b/feature/task/data/model/task_api_model.dart';

abstract interface class ITaskDataSource {
  Future<List<TaskApiModel>> getTasks();
  Future<TaskApiModel> createTask(TaskApiModel task);
  Future<TaskApiModel> updateTask(String taskId, TaskApiModel task);
  Future<void> deleteTask(String taskId);
}
