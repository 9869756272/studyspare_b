import 'package:studyspare_b/feature/notes/data/model/note_api_model.dart';

abstract interface class INoteDataSource {
  Future<List<NoteApiModel>> getNotes();
  Future<NoteApiModel> createNote(NoteApiModel note);
  Future<NoteApiModel> updateNote(String noteId, NoteApiModel note);
  Future<void> deleteNote(String noteId);
}
