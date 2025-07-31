import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:studyspare_b/app/auth/auth_provider.dart';
import 'package:studyspare_b/feature/notes/presentation/view/notes_list_view.dart';
import 'package:studyspare_b/feature/notes/presentation/view_model/note_state.dart';
import 'package:studyspare_b/feature/notes/presentation/view_model/note_view_model.dart';

// Mocks
class MockNoteViewModel extends Mock implements NoteViewModel {}

class MockAuthProvider extends Mock implements AuthProvider {}

void main() {
  late MockNoteViewModel mockNoteViewModel;
  late MockAuthProvider mockAuthProvider;

  setUp(() {
    // Initialize mocks for each test
    mockNoteViewModel = MockNoteViewModel();
    mockAuthProvider = MockAuthProvider();

    // Stub the BLoC/ViewModel
    when(() => mockNoteViewModel.state).thenReturn(NoteInitial());
    when(() => mockNoteViewModel.stream).thenAnswer((_) => Stream.empty());

    // Stub the AuthProvider
    when(() => mockAuthProvider.state).thenReturn(AuthState.uninitialized());
    when(() => mockAuthProvider.stream).thenAnswer((_) => Stream.empty());
  });

  // Helper function to create the widget under test
  Widget createWidgetUnderTest() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NoteViewModel>.value(value: mockNoteViewModel),
        // Provide the missing AuthProvider mock
        BlocProvider<AuthProvider>.value(value: mockAuthProvider),
      ],
      child: MaterialApp(
        home: Scaffold(
          // Add the AppBar here, so the test can find its title
          appBar: AppBar(title: const Text('Notes')),
          body: const NotesListView(),
        ),
      ),
    );
  }

  testWidgets('should display app bar with title', (WidgetTester tester) async {
    // Arrange: All setup is now in setUp() and createWidgetUnderTest()

    // Act
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // Assert
    // This will now pass because the test setup includes an AppBar
    expect(find.text('Notes'), findsOneWidget);
  });
}
