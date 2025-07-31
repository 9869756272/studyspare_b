import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:studyspare_b/core/error/failure.dart';
import 'package:studyspare_b/feature/notes/domain/entity/note_entity.dart';
import 'package:studyspare_b/feature/notes/domain/repository/note_repository.dart';
import 'package:studyspare_b/feature/notes/domain/use_case/get_notes_usecase.dart';

class MockINoteRepository extends Mock implements INoteRepository {}

void main() {
  late INoteRepository mockNoteRepository;
  late GetNotesUsecase usecase;

  setUp(() {
    mockNoteRepository = MockINoteRepository();
    usecase = GetNotesUsecase(noteRepository: mockNoteRepository);
  });

  const tNotesList = [
    NoteEntity(id: '1', title: 'Note 1', content: 'Content 1', userId: 'user1'),
    NoteEntity(id: '2', title: 'Note 2', content: 'Content 2', userId: 'user1'),
  ];

  group('GetNotesUsecase', () {
    test(
      'should call getNotes on the repository and return a list of NoteEntity on success',
      () async {
        when(
          () => mockNoteRepository.getNotes(),
        ).thenAnswer((_) async => const Right(tNotesList));

        final result = await usecase();

        expect(result, const Right(tNotesList));
        verify(() => mockNoteRepository.getNotes()).called(1);
        verifyNoMoreInteractions(mockNoteRepository);
      },
    );

    test(
      'should return a Failure from the repository when fetching fails',
      () async {
        final tFailure = RemoteDatabaseFailure(
          message: 'Failed to fetch notes',
        );
        when(
          () => mockNoteRepository.getNotes(),
        ).thenAnswer((_) async => Left(tFailure));

        final result = await usecase();

        expect(result, Left(tFailure));
        verify(() => mockNoteRepository.getNotes()).called(1);
        verifyNoMoreInteractions(mockNoteRepository);
      },
    );
  });
}
