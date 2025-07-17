import 'package:dio/dio.dart';
import 'package:studyspare_b/app/constant/api_endpoints.dart';
import 'package:studyspare_b/core/network/api_service.dart';
import 'package:studyspare_b/feature/notes/data/data_source/note_data_source.dart';
import 'package:studyspare_b/feature/notes/data/model/note_api_model.dart';

class NoteRemoteDatasource implements INoteDataSource {
  final ApiService _apiService;

  NoteRemoteDatasource({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<List<NoteApiModel>> getNotes() async {
    try {
      final response = await _apiService.dio.get(ApiEndpoints.notes);
      if (response.statusCode == 200) {
        final List<dynamic> notesData = response.data;
        return notesData
            .map((noteData) => NoteApiModel.fromJson(noteData))
            .toList();
      } else {
        throw Exception('Failed to fetch notes: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to fetch notes: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch notes: $e');
    }
  }

  @override
  Future<NoteApiModel> createNote(NoteApiModel note) async {
    try {
      final response = await _apiService.dio.post(
        ApiEndpoints.notes,
        data: note.toJson(),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        return NoteApiModel.fromJson(response.data);
      } else {
        throw Exception('Failed to create note: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to create note: ${e.message}');
    } catch (e) {
      throw Exception('Failed to create note: $e');
    }
  }

  @override
  Future<NoteApiModel> updateNote(String noteId, NoteApiModel note) async {
    try {
      final response = await _apiService.dio.put(
        "${ApiEndpoints.notes}/$noteId",
        data: note.toJson(),
      );
      if (response.statusCode == 200) {
        return NoteApiModel.fromJson(response.data);
      } else {
        throw Exception('Failed to update note: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to update note: ${e.message}');
    } catch (e) {
      throw Exception('Failed to update note: $e');
    }
  }

  @override
  Future<void> deleteNote(String noteId) async {
    try {
      final response = await _apiService.dio.delete(
        "${ApiEndpoints.notes}/$noteId",
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to delete note: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to delete note: ${e.message}');
    } catch (e) {
      throw Exception('Failed to delete note: $e');
    }
  }
}
