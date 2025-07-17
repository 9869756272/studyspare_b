import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:studyspare_b/app/usecase/usecase.dart';
import 'package:studyspare_b/core/error/failure.dart';
import 'package:studyspare_b/feature/notes/domain/entity/note_entity.dart';
import 'package:studyspare_b/feature/notes/domain/repository/note_repository.dart';

class CreateNoteParams extends Equatable {
  final String title;
  final String content;
  final String userId;

  const CreateNoteParams({
    required this.title,
    required this.content,
    required this.userId,
  });

  @override
  List<Object?> get props => [title, content, userId];
}

class CreateNoteUsecase
    implements UsecaseWithParams<NoteEntity, CreateNoteParams> {
  final INoteRepository _noteRepository;

  CreateNoteUsecase({required INoteRepository noteRepository})
    : _noteRepository = noteRepository;

  @override
  Future<Either<Failure, NoteEntity>> call(CreateNoteParams params) {
    final note = NoteEntity(
      title: params.title,
      content: params.content,
      userId: params.userId,
    );
    return _noteRepository.createNote(note);
  }
}
