import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:studyspare_b/feature/notes/domain/entity/note_entity.dart';
import 'package:studyspare_b/feature/notes/presentation/view_model/note_event.dart';
import 'package:studyspare_b/feature/notes/presentation/view_model/note_state.dart';
import 'package:studyspare_b/feature/notes/presentation/view_model/note_view_model.dart';

class NoteEditView extends StatefulWidget {
  final NoteEntity? note;
  final String userId;
  final void Function()? onSaved;

  const NoteEditView({
    super.key,
    this.note,
    required this.userId,
    this.onSaved,
  });

  @override
  State<NoteEditView> createState() => _NoteEditViewState();
}

class _NoteEditViewState extends State<NoteEditView> {
  late final TextEditingController _titleController;
  late final QuillController _quillController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');

    if (widget.note != null && widget.note!.content.isNotEmpty) {
      try {
        final json = jsonDecode(widget.note!.content);
        _quillController = QuillController(
          document: Document.fromJson(json),
          selection: const TextSelection.collapsed(offset: 0),
        );
      } catch (e) {
        _quillController = QuillController.basic();
      }
    } else {
      _quillController = QuillController.basic();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _quillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NoteViewModel, NoteState>(
      listener: (context, state) {
        if (state is NoteCreated || state is NoteUpdated) {
          widget.onSaved?.call();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        // -----------------------------------------
        appBar: AppBar(
          title: Text(widget.note == null ? 'New Note' : 'Edit Note'),
          backgroundColor: Colors.blue,
          actions: [
            BlocBuilder<NoteViewModel, NoteState>(
              builder: (context, state) {
                return IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: state is NoteLoading ? null : _onSave,
                  tooltip: 'Save',
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            QuillSimpleToolbar(controller: _quillController),
            const Divider(height: 1),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: QuillEditor.basic(controller: _quillController),
              ),
            ),
            BlocBuilder<NoteViewModel, NoteState>(
              builder: (context, state) {
                if (state is NoteError) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _onSave() {
    final title = _titleController.text.trim();
    final contentJson = jsonEncode(
      _quillController.document.toDelta().toJson(),
    );

    if (title.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Title cannot be empty.')));
      return;
    }

    final viewModel = context.read<NoteViewModel>();
    if (widget.note == null) {
      viewModel.add(
        CreateNote(title: title, content: contentJson, userId: widget.userId),
      );
    } else {
      final updatedNote = widget.note!.copyWith(
        title: title,
        content: contentJson,
      );
      viewModel.add(UpdateNote(note: updatedNote));
    }
  }
}
