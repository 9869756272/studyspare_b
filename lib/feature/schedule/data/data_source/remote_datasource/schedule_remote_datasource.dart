import 'package:dio/dio.dart';
import 'package:studyspare_b/app/constant/api_endpoints.dart';
import 'package:studyspare_b/core/network/api_service.dart';
import 'package:studyspare_b/feature/schedule/data/model/schedule_api_model.dart';

class ScheduleRemoteDatasource {
  final ApiService _apiService;

  ScheduleRemoteDatasource({required ApiService apiService})
    : _apiService = apiService;

  Future<List<ScheduleApiModel>> getSchedules() async {
    try {
      final response = await _apiService.dio.get(ApiEndpoints.schedules);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((e) => ScheduleApiModel.fromJson(e)).toList();
      } else {
        throw Exception('Failed to fetch schedules: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to fetch schedules: ${e.message}');
    }
  }

  Future<ScheduleApiModel> createSchedule(ScheduleApiModel schedule) async {
    try {
      final response = await _apiService.dio.post(
        ApiEndpoints.schedules,
        data: schedule.toJson(),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        return ScheduleApiModel.fromJson(response.data);
      } else {
        throw Exception('Failed to create schedule: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to create schedule: ${e.message}');
    }
  }

  Future<ScheduleApiModel> updateSchedule(
    String scheduleId,
    ScheduleApiModel schedule,
  ) async {
    try {
      final response = await _apiService.dio.put(
        '${ApiEndpoints.schedules}/$scheduleId',
        data: schedule.toJson(),
      );
      if (response.statusCode == 200) {
        return ScheduleApiModel.fromJson(response.data);
      } else {
        throw Exception('Failed to update schedule: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to update schedule: ${e.message}');
    }
  }

  Future<void> deleteSchedule(String scheduleId) async {
    try {
      final response = await _apiService.dio.delete(
        '${ApiEndpoints.schedules}/$scheduleId',
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to delete schedule: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to delete schedule: ${e.message}');
    }
  }
}
