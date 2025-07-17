import 'package:equatable/equatable.dart';
import 'package:studyspare_b/feature/notes/domain/entity/note_entity.dart';

abstract class NoteEvent extends Equatable {
  const NoteEvent();

  @override
  List<Object?> get props => [];
}

class LoadNotes extends NoteEvent {
  const LoadNotes();
}

class CreateNote extends NoteEvent {
  final String title;
  final String content;
  final String userId;

  const CreateNote({
    required this.title,
    required this.content,
    required this.userId,
  });

  @override
  List<Object?> get props => [title, content, userId];
}

class UpdateNote extends NoteEvent {
  final NoteEntity note;

  const UpdateNote({required this.note});

  @override
  List<Object?> get props => [note];
}

class DeleteNote extends NoteEvent {
  final String noteId;

  const DeleteNote({required this.noteId});

  @override
  List<Object?> get props => [noteId];
}
