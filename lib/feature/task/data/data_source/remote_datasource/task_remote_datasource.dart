import 'package:dio/dio.dart';
import 'package:studyspare_b/app/constant/api_endpoints.dart';
import 'package:studyspare_b/core/network/api_service.dart';
import 'package:studyspare_b/feature/task/data/data_source/task_data_source.dart';
import 'package:studyspare_b/feature/task/data/model/task_api_model.dart';

class TaskRemoteDatasource implements ITaskDataSource {
  final ApiService _apiService;

  TaskRemoteDatasource({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<List<TaskApiModel>> getTasks() async {
    try {
      print('Fetching tasks...');
      print('API endpoint: ${ApiEndpoints.baseUrl}/tasks');

      final response = await _apiService.dio.get(ApiEndpoints.tasks);

      print('Response status code: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode == 200) {
        final List<dynamic> tasksData = response.data;
        final tasks =
            tasksData
                .map((taskData) => TaskApiModel.fromJson(taskData))
                .toList();

        print('Tasks fetched successfully: ${tasks.length} tasks');
        return tasks;
      } else {
        throw Exception('Failed to fetch tasks: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      print('DioException caught: ${e.type}');
      print('DioException message: ${e.message}');
      print('DioException response: ${e.response?.data}');
      print('DioException status code: ${e.response?.statusCode}');

      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception(
          'Connection timeout. Please check your internet connection and try again.',
        );
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception(
          'Connection error. Please check if the server is running.',
        );
      } else if (e.response?.statusCode == 401) {
        throw Exception('Unauthorized. Please login again.');
      } else if (e.response?.statusCode == 404) {
        throw Exception('Tasks endpoint not found.');
      } else {
        throw Exception('Failed to fetch tasks: ${e.message}');
      }
    } catch (e) {
      print('General exception caught: $e');
      throw Exception('Failed to fetch tasks: $e');
    }
  }

  @override
  Future<TaskApiModel> createTask(TaskApiModel task) async {
    try {
      print('Creating task: ${task.title}');
      print('API endpoint: ${ApiEndpoints.baseUrl}/tasks');

      final response = await _apiService.dio.post(
        ApiEndpoints.tasks,
        data: task.toJson(),
      );

      print('Response status code: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final createdTask = TaskApiModel.fromJson(response.data);
        print('Task created successfully: ${createdTask.title}');
        return createdTask;
      } else {
        throw Exception('Failed to create task: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      print('DioException caught: ${e.type}');
      print('DioException message: ${e.message}');
      print('DioException response: ${e.response?.data}');
      print('DioException status code: ${e.response?.statusCode}');

      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception(
          'Connection timeout. Please check your internet connection and try again.',
        );
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception(
          'Connection error. Please check if the server is running.',
        );
      } else if (e.response?.statusCode == 401) {
        throw Exception('Unauthorized. Please login again.');
      } else if (e.response?.statusCode == 400) {
        throw Exception('Invalid task data. Please check your input.');
      } else {
        throw Exception('Failed to create task: ${e.message}');
      }
    } catch (e) {
      print('General exception caught: $e');
      throw Exception('Failed to create task: $e');
    }
  }

  @override
  Future<TaskApiModel> updateTask(String taskId, TaskApiModel task) async {
    try {
      print('Updating task: $taskId');
      print('API endpoint: ${ApiEndpoints.baseUrl}/tasks/$taskId');

      final response = await _apiService.dio.put(
        '${ApiEndpoints.tasks}/$taskId',
        data: task.toJson(),
      );

      print('Response status code: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode == 200) {
        final updatedTask = TaskApiModel.fromJson(response.data);
        print('Task updated successfully: ${updatedTask.title}');
        return updatedTask;
      } else {
        throw Exception('Failed to update task: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      print('DioException caught: ${e.type}');
      print('DioException message: ${e.message}');
      print('DioException response: ${e.response?.data}');
      print('DioException status code: ${e.response?.statusCode}');

      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception(
          'Connection timeout. Please check your internet connection and try again.',
        );
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception(
          'Connection error. Please check if the server is running.',
        );
      } else if (e.response?.statusCode == 401) {
        throw Exception('Unauthorized. Please login again.');
      } else if (e.response?.statusCode == 404) {
        throw Exception('Task not found.');
      } else if (e.response?.statusCode == 400) {
        throw Exception('Invalid task data. Please check your input.');
      } else {
        throw Exception('Failed to update task: ${e.message}');
      }
    } catch (e) {
      print('General exception caught: $e');
      throw Exception('Failed to update task: $e');
    }
  }

  @override
  Future<void> deleteTask(String taskId) async {
    try {
      print('Deleting task: $taskId');
      print('API endpoint: ${ApiEndpoints.baseUrl}/tasks/$taskId');

      final response = await _apiService.dio.delete(
        '${ApiEndpoints.tasks}/$taskId',
      );

      print('Response status code: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode == 200) {
        print('Task deleted successfully: $taskId');
        return;
      } else {
        throw Exception('Failed to delete task: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      print('DioException caught: ${e.type}');
      print('DioException message: ${e.message}');
      print('DioException response: ${e.response?.data}');
      print('DioException status code: ${e.response?.statusCode}');

      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception(
          'Connection timeout. Please check your internet connection and try again.',
        );
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception(
          'Connection error. Please check if the server is running.',
        );
      } else if (e.response?.statusCode == 401) {
        throw Exception('Unauthorized. Please login again.');
      } else if (e.response?.statusCode == 404) {
        throw Exception('Task not found.');
      } else {
        throw Exception('Failed to delete task: ${e.message}');
      }
    } catch (e) {
      print('General exception caught: $e');
      throw Exception('Failed to delete task: $e');
    }
  }
}
