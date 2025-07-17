import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studyspare_b/feature/notes/domain/entity/note_entity.dart';
import 'package:studyspare_b/feature/notes/domain/use_case/create_note_usecase.dart';
import 'package:studyspare_b/feature/notes/domain/use_case/delete_note_usecase.dart';
import 'package:studyspare_b/feature/notes/domain/use_case/get_notes_usecase.dart';
import 'package:studyspare_b/feature/notes/domain/use_case/update_note_usecase.dart';
import 'package:studyspare_b/feature/notes/presentation/view_model/note_event.dart';
import 'package:studyspare_b/feature/notes/presentation/view_model/note_state.dart';

class NoteViewModel extends Bloc<NoteEvent, NoteState> {
  final GetNotesUsecase _getNotesUsecase;
  final CreateNoteUsecase _createNoteUsecase;
  final UpdateNoteUsecase _updateNoteUsecase;
  final DeleteNoteUsecase _deleteNoteUsecase;

  NoteViewModel({
    required GetNotesUsecase getNotesUsecase,
    required CreateNoteUsecase createNoteUsecase,
    required UpdateNoteUsecase updateNoteUsecase,
    required DeleteNoteUsecase deleteNoteUsecase,
  }) : _getNotesUsecase = getNotesUsecase,
       _createNoteUsecase = createNoteUsecase,
       _updateNoteUsecase = updateNoteUsecase,
       _deleteNoteUsecase = deleteNoteUsecase,
       // The initial state has no notes
       super(NoteInitial()) {
    on<LoadNotes>(_onLoadNotes);
    on<CreateNote>(_onCreateNote);
    on<UpdateNote>(_onUpdateNote);
    on<DeleteNote>(_onDeleteNote);
  }

  // Helper to get current notes from the state if they exist
  List<NoteEntity> get _currentNotes {
    final currentState = state;
    if (currentState is NotesLoaded) {
      return currentState.notes;
    } else if (currentState is NoteLoading) {
      return currentState.notes;
    }
    return []; // Return empty list for any other state
  }

  Future<void> _onLoadNotes(LoadNotes event, Emitter<NoteState> emit) async {
    // --- FIX: Pass the current notes to the loading state ---
    emit(NoteLoading(notes: _currentNotes));
    final result = await _getNotesUsecase();
    result.fold(
      (failure) => emit(NoteError(failure.message)),
      (notes) => emit(NotesLoaded(notes)),
    );
  }

  Future<void> _onCreateNote(CreateNote event, Emitter<NoteState> emit) async {
    // --- FIX: Pass the current notes to the loading state ---
    emit(NoteLoading(notes: _currentNotes));
    final result = await _createNoteUsecase(
      CreateNoteParams(
        title: event.title,
        content: event.content,
        userId: event.userId,
      ),
    );
    result.fold((failure) => emit(NoteError(failure.message)), (_) {
      // --- FIX: Emit simple state, as data is not needed ---
      emit(NoteCreated());
      // The list view will be refreshed by this subsequent event
      add(const LoadNotes());
    });
  }

  Future<void> _onUpdateNote(UpdateNote event, Emitter<NoteState> emit) async {
    // --- FIX: Pass the current notes to the loading state ---
    emit(NoteLoading(notes: _currentNotes));
    final result = await _updateNoteUsecase(
      UpdateNoteParams(
        noteId: event.note.id!,
        title: event.note.title,
        content: event.note.content,
        userId: event.note.userId,
      ),
    );
    result.fold((failure) => emit(NoteError(failure.message)), (_) {
      // --- FIX: Emit simple state ---
      emit(NoteUpdated());
      add(const LoadNotes());
    });
  }

  Future<void> _onDeleteNote(DeleteNote event, Emitter<NoteState> emit) async {
    // --- FIX: Pass the current notes to the loading state ---
    emit(NoteLoading(notes: _currentNotes));
    final result = await _deleteNoteUsecase(
      DeleteNoteParams(noteId: event.noteId),
    );
    result.fold((failure) => emit(NoteError(failure.message)), (_) {
      // --- FIX: Emit simple state ---
      emit(NoteDeleted());
      // The list view will listen for NoteDeleted and then call LoadNotes
      // so we don't strictly need to call it here, but it's safer to do so.
      // The listener in the UI can be used for showing SnackBars.
    });
  }
}
