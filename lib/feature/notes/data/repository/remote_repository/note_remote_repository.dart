import 'package:dartz/dartz.dart';
import 'package:studyspare_b/core/error/failure.dart';
import 'package:studyspare_b/feature/notes/data/data_source/remote_datasource/note_remote_datasource.dart';
import 'package:studyspare_b/feature/notes/data/model/note_api_model.dart';
import 'package:studyspare_b/feature/notes/domain/entity/note_entity.dart';
import 'package:studyspare_b/feature/notes/domain/repository/note_repository.dart';

class NoteRemoteRepository implements INoteRepository {
  final NoteRemoteDatasource _noteRemoteDatasource;

  NoteRemoteRepository({required NoteRemoteDatasource noteRemoteDatasource})
    : _noteRemoteDatasource = noteRemoteDatasource;

  @override
  Future<Either<Failure, List<NoteEntity>>> getNotes() async {
    try {
      final result = await _noteRemoteDatasource.getNotes();
      final notes = result.map((note) => note.toEntity()).toList();
      return Right(notes);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, NoteEntity>> createNote(NoteEntity note) async {
    try {
      final noteApiModel = NoteApiModel.fromEntity(note);
      final result = await _noteRemoteDatasource.createNote(noteApiModel);
      return Right(result.toEntity());
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, NoteEntity>> updateNote(
    String noteId,
    NoteEntity note,
  ) async {
    try {
      final noteApiModel = NoteApiModel.fromEntity(note);
      final result = await _noteRemoteDatasource.updateNote(
        noteId,
        noteApiModel,
      );
      return Right(result.toEntity());
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteNote(String noteId) async {
    try {
      await _noteRemoteDatasource.deleteNote(noteId);
      return const Right(null);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }
}
