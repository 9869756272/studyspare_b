import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:studyspare_b/core/error/failure.dart';
import 'package:studyspare_b/feature/notes/domain/entity/note_entity.dart';
import 'package:studyspare_b/feature/notes/domain/use_case/create_note_usecase.dart';
import 'package:studyspare_b/feature/notes/domain/use_case/delete_note_usecase.dart';
import 'package:studyspare_b/feature/notes/domain/use_case/get_notes_usecase.dart';
import 'package:studyspare_b/feature/notes/domain/use_case/update_note_usecase.dart';
import 'package:studyspare_b/feature/notes/presentation/view_model/note_event.dart';
import 'package:studyspare_b/feature/notes/presentation/view_model/note_state.dart';
import 'package:studyspare_b/feature/notes/presentation/view_model/note_view_model.dart';

class MockGetNotesUsecase extends Mock implements GetNotesUsecase {}

class MockCreateNoteUsecase extends Mock implements CreateNoteUsecase {}

class MockUpdateNoteUsecase extends Mock implements UpdateNoteUsecase {}

class MockDeleteNoteUsecase extends Mock implements DeleteNoteUsecase {}

void main() {
  late GetNotesUsecase mockGetNotesUsecase;
  late CreateNoteUsecase mockCreateNoteUsecase;
  late UpdateNoteUsecase mockUpdateNoteUsecase;
  late DeleteNoteUsecase mockDeleteNoteUsecase;
  late NoteViewModel noteViewModel;

  setUpAll(() {
    registerFallbackValue(
      const CreateNoteParams(title: '', content: '', userId: ''),
    );
    registerFallbackValue(
      const UpdateNoteParams(noteId: '', title: '', content: '', userId: ''),
    );
    registerFallbackValue(const DeleteNoteParams(noteId: ''));
  });

  setUp(() {
    mockGetNotesUsecase = MockGetNotesUsecase();
    mockCreateNoteUsecase = MockCreateNoteUsecase();
    mockUpdateNoteUsecase = MockUpdateNoteUsecase();
    mockDeleteNoteUsecase = MockDeleteNoteUsecase();
    noteViewModel = NoteViewModel(
      getNotesUsecase: mockGetNotesUsecase,
      createNoteUsecase: mockCreateNoteUsecase,
      updateNoteUsecase: mockUpdateNoteUsecase,
      deleteNoteUsecase: mockDeleteNoteUsecase,
    );
  });

  tearDown(() {
    noteViewModel.close();
  });

  const tNotesList = [
    NoteEntity(id: '1', title: 'Note 1', content: 'Content 1', userId: 'user1'),
    NoteEntity(id: '2', title: 'Note 2', content: 'Content 2', userId: 'user1'),
  ];

  final tFailure = RemoteDatabaseFailure(message: 'An error occurred');

  test('initial state is NoteInitial', () {
    expect(noteViewModel.state, equals(NoteInitial()));
  });

  group('LoadNotes', () {
    blocTest<NoteViewModel, NoteState>(
      'emits [NoteLoading, NotesLoaded] when successful',
      setUp: () {
        when(
          () => mockGetNotesUsecase(),
        ).thenAnswer((_) async => const Right(tNotesList));
      },
      build: () => noteViewModel,
      act: (bloc) => bloc.add(const LoadNotes()),
      expect:
          () => <NoteState>[
            const NoteLoading(notes: []),
            const NotesLoaded(tNotesList),
          ],
      verify: (_) {
        verify(() => mockGetNotesUsecase()).called(1);
      },
    );

    blocTest<NoteViewModel, NoteState>(
      'emits [NoteLoading, NoteError] when unsuccessful',
      setUp: () {
        when(
          () => mockGetNotesUsecase(),
        ).thenAnswer((_) async => Left(tFailure));
      },
      build: () => noteViewModel,
      act: (bloc) => bloc.add(const LoadNotes()),
      expect:
          () => <NoteState>[
            const NoteLoading(notes: []),
            NoteError(tFailure.message),
          ],
    );
  });

  group('CreateNote', () {
    const tCreateEvent = CreateNote(
      title: 'New Note',
      content: 'New Content',
      userId: 'user1',
    );

    blocTest<NoteViewModel, NoteState>(
      'emits [NoteLoading, NoteCreated, NoteLoading, NotesLoaded] when successful',
      setUp: () {
        when(() => mockCreateNoteUsecase(any())).thenAnswer(
          (_) async => const Right(
            NoteEntity(
              id: 'new_note_id',
              title: 'New Note',
              content: 'New Content',
              userId: 'user1',
            ),
          ),
        );
        when(
          () => mockGetNotesUsecase(),
        ).thenAnswer((_) async => const Right(tNotesList));
      },
      build: () => noteViewModel,
      act: (bloc) => bloc.add(tCreateEvent),
      expect:
          () => <NoteState>[
            const NoteLoading(notes: []),
            NoteCreated(),
            const NoteLoading(notes: []),
            const NotesLoaded(tNotesList),
          ],
      verify: (_) {
        verify(() => mockCreateNoteUsecase(any())).called(1);
        verify(() => mockGetNotesUsecase()).called(1);
      },
    );

    blocTest<NoteViewModel, NoteState>(
      'emits [NoteLoading, NoteError] when unsuccessful',
      setUp: () {
        when(
          () => mockCreateNoteUsecase(any()),
        ).thenAnswer((_) async => Left(tFailure));
      },
      build: () => noteViewModel,
      act: (bloc) => bloc.add(tCreateEvent),
      expect:
          () => <NoteState>[
            const NoteLoading(notes: []),
            NoteError(tFailure.message),
          ],
    );
  });

  group('UpdateNote', () {
    const tUpdateEvent = UpdateNote(
      note: NoteEntity(
        id: '1',
        title: 'Updated Title',
        content: 'Updated Content',
        userId: 'user1',
      ),
    );

    blocTest<NoteViewModel, NoteState>(
      'emits [NoteLoading, NoteUpdated, NoteLoading, NotesLoaded] when successful',
      setUp: () {
        when(() => mockUpdateNoteUsecase(any())).thenAnswer(
          (_) async => const Right(
            NoteEntity(
              id: '1',
              title: 'Updated Title',
              content: 'Updated Content',
              userId: 'user1',
            ),
          ),
        );
        when(
          () => mockGetNotesUsecase(),
        ).thenAnswer((_) async => const Right(tNotesList));
      },
      seed: () => const NotesLoaded(tNotesList),
      build: () => noteViewModel,
      act: (bloc) => bloc.add(tUpdateEvent),
      expect:
          () => <NoteState>[
            const NoteLoading(notes: tNotesList),
            NoteUpdated(),
            const NoteLoading(notes: []),
            const NotesLoaded(tNotesList),
          ],
      verify: (_) {
        verify(() => mockUpdateNoteUsecase(any())).called(1);
        verify(() => mockGetNotesUsecase()).called(1);
      },
    );

    blocTest<NoteViewModel, NoteState>(
      'emits [NoteLoading, NoteError] when unsuccessful',
      setUp: () {
        when(
          () => mockUpdateNoteUsecase(any()),
        ).thenAnswer((_) async => Left(tFailure));
      },
      seed: () => const NotesLoaded(tNotesList),
      build: () => noteViewModel,
      act: (bloc) => bloc.add(tUpdateEvent),
      expect:
          () => <NoteState>[
            const NoteLoading(notes: tNotesList),
            NoteError(tFailure.message),
          ],
    );
  });

  group('DeleteNote', () {
    const tDeleteEvent = DeleteNote(noteId: '1');

    blocTest<NoteViewModel, NoteState>(
      'emits [NoteLoading, NoteDeleted] when successful',
      setUp: () {
        when(
          () => mockDeleteNoteUsecase(any()),
        ).thenAnswer((_) async => const Right(null));
      },
      seed: () => const NotesLoaded(tNotesList),
      build: () => noteViewModel,
      act: (bloc) => bloc.add(tDeleteEvent),
      expect:
          () => <NoteState>[
            const NoteLoading(notes: tNotesList),
            NoteDeleted(),
          ],
      verify: (_) {
        verify(() => mockDeleteNoteUsecase(any())).called(1);
        verifyNever(() => mockGetNotesUsecase());
      },
    );

    blocTest<NoteViewModel, NoteState>(
      'emits [NoteLoading, NoteError] when unsuccessful',
      setUp: () {
        when(
          () => mockDeleteNoteUsecase(any()),
        ).thenAnswer((_) async => Left(tFailure));
      },
      seed: () => const NotesLoaded(tNotesList),
      build: () => noteViewModel,
      act: (bloc) => bloc.add(tDeleteEvent),
      expect:
          () => <NoteState>[
            const NoteLoading(notes: tNotesList),
            NoteError(tFailure.message),
          ],
    );
  });
}
