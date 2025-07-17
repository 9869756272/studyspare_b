import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:studyspare_b/app/auth/auth_provider.dart';
import 'package:studyspare_b/feature/notes/domain/entity/note_entity.dart';
import 'package:studyspare_b/feature/notes/presentation/view/note_edit_view.dart';
import 'package:studyspare_b/feature/notes/presentation/view_model/note_event.dart';
import 'package:studyspare_b/feature/notes/presentation/view_model/note_view_model.dart';

class NoteViewPage extends StatefulWidget {
  final NoteEntity note;

  const NoteViewPage({super.key, required this.note});

  @override
  State<NoteViewPage> createState() => _NoteViewPageState();
}

class _NoteViewPageState extends State<NoteViewPage> {
  late final QuillController _quillController;

  @override
  void initState() {
    super.initState();
    // This part is already correct! You are successfully creating a
    // document from the saved JSON content.
    _quillController = QuillController(
      document: _tryDocument(widget.note.content),
      selection: const TextSelection.collapsed(offset: 0),
    );
  }

  @override
  void dispose() {
    _quillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Note View"),
        actions: [
          IconButton(
            onPressed: () => _navigateToEditNote(context, widget.note),
            icon: const Icon(Icons.edit),
          ),
        ],
        // You can add an edit button here later to navigate to the edit page
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title section
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                widget.note.title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(),

            Expanded(child: QuillEditor.basic(controller: _quillController)),
          ],
        ),
      ),
    );
  }

  Document _tryDocument(String content) {
    try {
      if (content.isEmpty) {
        return Document()..insert(0, 'No content available.');
      }

      final decoded = jsonDecode(content);
      if (decoded is List<dynamic>) {
        return Document.fromJson(decoded);
      }
      return Document()..insert(0, content);
    } catch (e) {
      return Document()..insert(0, content);
    }
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
}
