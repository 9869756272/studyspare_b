import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:studyspare_b/feature/profile/presentation/viewmodel/profile_cubit.dart';
import 'package:studyspare_b/feature/profile/presentation/viewmodel/profile_state.dart';

class MockProfileCubit extends Mock implements ProfileCubit {}

void main() {
  late MockProfileCubit profileCubit;

  setUp(() {
    profileCubit = MockProfileCubit();
  });

  test('should call loadUserProfile method', () {
    // Arrange
    when(() => profileCubit.loadUserProfile()).thenReturn(null);

    // Act
    profileCubit.loadUserProfile();

    // Assert
    verify(() => profileCubit.loadUserProfile()).called(1);
  });
}
