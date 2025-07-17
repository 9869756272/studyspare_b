import 'package:dartz/dartz.dart';
import 'package:studyspare_b/app/usecase/usecase.dart';
import 'package:studyspare_b/core/error/failure.dart';
import 'package:studyspare_b/feature/notes/domain/entity/note_entity.dart';
import 'package:studyspare_b/feature/notes/domain/repository/note_repository.dart';

class GetNotesUsecase implements UsecaseWithoutParams<List<NoteEntity>> {
  final INoteRepository _noteRepository;

  GetNotesUsecase({required INoteRepository noteRepository})
    : _noteRepository = noteRepository;

  @override
  Future<Either<Failure, List<NoteEntity>>> call() {
    return _noteRepository.getNotes();
  }
}
