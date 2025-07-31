import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:studyspare_b/core/error/failure.dart';
import 'package:studyspare_b/feature/notes/domain/entity/note_entity.dart';
import 'package:studyspare_b/feature/notes/domain/repository/note_repository.dart';
import 'package:studyspare_b/feature/notes/domain/use_case/create_note_usecase.dart';

class MockINoteRepository extends Mock implements INoteRepository {}

void main() {
  late INoteRepository mockNoteRepository;
  late CreateNoteUsecase usecase;

  setUpAll(() {
    registerFallbackValue(const NoteEntity(title: '', content: '', userId: ''));
  });

  setUp(() {
    mockNoteRepository = MockINoteRepository();
    usecase = CreateNoteUsecase(noteRepository: mockNoteRepository);
  });

  const tParams = CreateNoteParams(
    title: 'Test Note',
    content: 'This is the content.',
    userId: 'user123',
  );

  const tNoteToCreate = NoteEntity(
    title: 'Test Note',
    content: 'This is the content.',
    userId: 'user123',
  );

  const tNoteCreated = NoteEntity(
    id: 'note1',
    title: 'Test Note',
    content: 'This is the content.',
    userId: 'user123',
  );

  group('CreateNoteUsecase', () {
    test(
      'should call createNote on the repository and return the created NoteEntity on success',
      () async {
        when(
          () => mockNoteRepository.createNote(any()),
        ).thenAnswer((_) async => const Right(tNoteCreated));

        final result = await usecase(tParams);

        expect(result, const Right(tNoteCreated));
        verify(() => mockNoteRepository.createNote(tNoteToCreate)).called(1);
        verifyNoMoreInteractions(mockNoteRepository);
      },
    );

    test(
      'should return a Failure from the repository when creation fails',
      () async {
        final tFailure = RemoteDatabaseFailure(
          message: 'Failed to create note',
        );
        when(
          () => mockNoteRepository.createNote(any()),
        ).thenAnswer((_) async => Left(tFailure));

        final result = await usecase(tParams);

        expect(result, Left(tFailure));
        verify(() => mockNoteRepository.createNote(tNoteToCreate)).called(1);
        verifyNoMoreInteractions(mockNoteRepository);
      },
    );
  });
}
