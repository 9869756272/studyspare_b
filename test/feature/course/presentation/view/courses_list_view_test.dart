import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:studyspare_b/core/error/failure.dart';
import 'package:studyspare_b/feature/course/data/model/course_data_model.dart';
import 'package:studyspare_b/feature/course/domain/usecase/get_all_courses_usecase.dart';
import 'package:studyspare_b/feature/course/presentation/view/courses_list_view.dart';
import 'package:studyspare_b/feature/course/presentation/viewmodel/courses_list/course_list_event.dart';
import 'package:studyspare_b/feature/course/presentation/viewmodel/courses_list/courses_list_state.dart';
import 'package:studyspare_b/feature/course/presentation/viewmodel/courses_list/courses_list_view_model.dart';

class MockGetAllCoursesUsecase extends Mock implements GetAllCoursesUsecase {}

class MockCoursesListViewModel
    extends MockBloc<CoursesListEvent, CoursesListState>
    implements CoursesListViewModel {}

class ServerFailure extends Failure {
  ServerFailure({required super.message});
}

void main() {
  group('CoursesListViewModel Tests', () {
    late GetAllCoursesUsecase mockGetAllCoursesUsecase;
    late CoursesListViewModel viewModel;

    setUp(() {
      mockGetAllCoursesUsecase = MockGetAllCoursesUsecase();
      viewModel = CoursesListViewModel(
        getAllCoursesUsecase: mockGetAllCoursesUsecase,
      );
    });

    tearDown(() {
      viewModel.close();
    });

    final tCourses = [
      const CourseModel(
        id: "id 1",
        title: "title 1",
        description: "description 1",
      ),
      const CourseModel(
        id: "id 2",
        title: "title 1",
        description: "description 1",
      ),
    ];
    final tFailure = ServerFailure(message: 'Failed to load courses');

    test('initial state is correct', () {
      expect(viewModel.state, const CoursesListState());
    });

    blocTest<CoursesListViewModel, CoursesListState>(
      'emits [loading, success] when LoadCourses is added and usecase succeeds',
      setUp: () {
        when(
          () => mockGetAllCoursesUsecase(),
        ).thenAnswer((_) async => Right(tCourses));
      },
      build: () => viewModel,
      act: (bloc) => bloc.add(const LoadCourses()),
      expect:
          () => <CoursesListState>[
            const CoursesListState(status: CoursesListStatus.loading),
            CoursesListState(
              status: CoursesListStatus.success,
              courses: tCourses,
            ),
          ],
      verify: (_) {
        verify(() => mockGetAllCoursesUsecase()).called(1);
      },
    );

    blocTest<CoursesListViewModel, CoursesListState>(
      'emits [loading, failure] when LoadCourses is added and usecase fails',
      setUp: () {
        when(
          () => mockGetAllCoursesUsecase(),
        ).thenAnswer((_) async => Left(tFailure));
      },
      build: () => viewModel,
      act: (bloc) => bloc.add(const LoadCourses()),
      expect:
          () => <CoursesListState>[
            const CoursesListState(status: CoursesListStatus.loading),
            CoursesListState(
              status: CoursesListStatus.failure,
              errorMessage: tFailure.message,
            ),
          ],
      verify: (_) {
        verify(() => mockGetAllCoursesUsecase()).called(1);
      },
    );
  });
}
