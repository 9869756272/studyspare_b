import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:studyspare_b/app/usecase/usecase.dart';
import 'package:studyspare_b/core/error/failure.dart';
import 'package:studyspare_b/feature/notes/domain/entity/note_entity.dart';
import 'package:studyspare_b/feature/notes/domain/repository/note_repository.dart';

class UpdateNoteParams extends Equatable {
  final String noteId;
  final String title;
  final String content;
  final String userId;

  const UpdateNoteParams({
    required this.noteId,
    required this.title,
    required this.content,
    required this.userId,
  });

  @override
  List<Object?> get props => [noteId, title, content, userId];
}

class UpdateNoteUsecase
    implements UsecaseWithParams<NoteEntity, UpdateNoteParams> {
  final INoteRepository _noteRepository;

  UpdateNoteUsecase({required INoteRepository noteRepository})
    : _noteRepository = noteRepository;

  @override
  Future<Either<Failure, NoteEntity>> call(UpdateNoteParams params) {
    final note = NoteEntity(
      id: params.noteId,
      title: params.title,
      content: params.content,
      userId: params.userId,
    );
    return _noteRepository.updateNote(params.noteId, note);
  }
}
