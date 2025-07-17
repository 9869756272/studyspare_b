import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:studyspare_b/feature/notes/presentation/view/note_view_page.dart';
import 'package:studyspare_b/feature/notes/presentation/view_model/note_view_model.dart';
import 'package:studyspare_b/feature/notes/presentation/view_model/note_event.dart';
import 'package:studyspare_b/feature/notes/presentation/view_model/note_state.dart';
import 'package:studyspare_b/feature/notes/domain/entity/note_entity.dart';
import 'package:studyspare_b/feature/notes/presentation/view/note_edit_view.dart';
import 'package:studyspare_b/app/auth/auth_provider.dart';

class NotesListView extends StatefulWidget {
  const NotesListView({super.key});

  @override
  State<NotesListView> createState() => _NotesListViewState();
}

class _NotesListViewState extends State<NotesListView> {
  @override
  void initState() {
    super.initState();
    context.read<NoteViewModel>().add(const LoadNotes());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocConsumer<NoteViewModel, NoteState>(
          listener: (context, state) {
            if (state is NoteDeleted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Note deleted successfully')),
              );
              context.read<NoteViewModel>().add(const LoadNotes());
            } else if (state is NoteError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${state.message}')),
              );
            }
          },
          builder: (context, state) {
            if (state is NoteLoading && state.notes.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            List<NoteEntity> notes = [];
            if (state is NotesLoaded) {
              notes = state.notes;
            } else if (state is NoteLoading) {
              notes = state.notes;
            }

            if (notes.isEmpty && state is! NoteLoading) {
              return const Center(child: Text('No notes yet. Tap + to add.'));
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<NoteViewModel>().add(const LoadNotes());
              },
              child: ListView.separated(
                itemCount: notes.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final note = notes[index];
                  return ListTile(
                    title: Text(
                      note.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(_createPreview(note.content)),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit') {
                          _navigateToEditNote(context, note);
                        } else if (value == 'delete') {
                          _showDeleteDialog(context, note);
                        }
                      },
                      itemBuilder:
                          (context) => [
                            const PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(Icons.edit, size: 18),
                                  SizedBox(width: 8),
                                  Text('Edit'),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.delete,
                                    size: 18,
                                    color: Colors.red,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                          ],
                    ),
                    onTap: () => _navigateToViewNote(context, note),
                  );
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddNote(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _navigateToAddNote(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => BlocProvider.value(
              value: context.read<NoteViewModel>(),
              child: NoteEditView(
                userId: context.read<AuthProvider>().state.user?.id ?? '',
                onSaved: () {
                  Navigator.pop(context);
                  context.read<NoteViewModel>().add(const LoadNotes());
                },
              ),
            ),
      ),
    );
  }

  void _navigateToEditNote(BuildContext context, NoteEntity note) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => BlocProvider.value(
              value: context.read<NoteViewModel>(),
              child: NoteEditView(
                note: note,
                userId: context.read<AuthProvider>().state.user?.id ?? '',
                onSaved: () {
                  Navigator.pop(context);
                  context.read<NoteViewModel>().add(const LoadNotes());
                },
              ),
            ),
      ),
    );
  }

  void _navigateToViewNote(BuildContext context, NoteEntity note) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => BlocProvider.value(
              value: context.read<NoteViewModel>(),
              child: NoteViewPage(note: note),
            ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, NoteEntity note) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: const Text('Delete Note'),
            content: Text('Are you sure you want to delete "${note.title}"?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                  context.read<NoteViewModel>().add(
                    DeleteNote(noteId: note.id!),
                  );
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }

  String _createPreview(String quillJson) {
    try {
      if (quillJson.isEmpty) return 'No content preview...';
      final decoded = jsonDecode(quillJson) as List<dynamic>;
      final doc = Document.fromJson(decoded);
      final text = doc.toPlainText().trim().replaceAll(RegExp(r'\s+'), ' ');
      if (text.isEmpty) return 'No content preview...';
      return text.length > 80 ? '${text.substring(0, 80)}...' : text;
    } catch (e) {
      return quillJson.length > 80
          ? '${quillJson.substring(0, 80)}...'
          : quillJson;
    }
  }
}
