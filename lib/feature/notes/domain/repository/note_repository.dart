import 'package:dartz/dartz.dart';
import 'package:studyspare_b/core/error/failure.dart';
import 'package:studyspare_b/feature/notes/domain/entity/note_entity.dart';

abstract interface class INoteRepository {
  Future<Either<Failure, List<NoteEntity>>> getNotes();
  Future<Either<Failure, NoteEntity>> createNote(NoteEntity note);
  Future<Either<Failure, NoteEntity>> updateNote(
    String noteId,
    NoteEntity note,
  );
  Future<Either<Failure, void>> deleteNote(String noteId);
}
