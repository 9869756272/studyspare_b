// lib/feature/notes/presentation/view_model/note_state.dart

import 'package:equatable/equatable.dart';
import 'package:studyspare_b/feature/notes/domain/entity/note_entity.dart';

abstract class NoteState extends Equatable {
  const NoteState();

  @override
  List<Object> get props => [];
}

class NoteInitial extends NoteState {}

class NoteLoading extends NoteState {
  final List<NoteEntity> notes;
  const NoteLoading({this.notes = const <NoteEntity>[]});

  @override
  List<Object> get props => [notes];
}

class NotesLoaded extends NoteState {
  final List<NoteEntity> notes;
  const NotesLoaded(this.notes);

  @override
  List<Object> get props => [notes];
}

class NoteCreated extends NoteState {}

class NoteUpdated extends NoteState {}

class NoteDeleted extends NoteState {}

class NoteError extends NoteState {
  final String message;
  const NoteError(this.message);

  @override
  List<Object> get props => [message];
}
