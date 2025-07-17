import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:studyspare_b/app/usecase/usecase.dart';
import 'package:studyspare_b/core/error/failure.dart';
import 'package:studyspare_b/feature/notes/domain/repository/note_repository.dart';

class DeleteNoteParams extends Equatable {
  final String noteId;

  const DeleteNoteParams({required this.noteId});

  @override
  List<Object?> get props => [noteId];
}

class DeleteNoteUsecase implements UsecaseWithParams<void, DeleteNoteParams> {
  final INoteRepository _noteRepository;

  DeleteNoteUsecase({required INoteRepository noteRepository})
    : _noteRepository = noteRepository;

  @override
  Future<Either<Failure, void>> call(DeleteNoteParams params) {
    return _noteRepository.deleteNote(params.noteId);
  }
}
