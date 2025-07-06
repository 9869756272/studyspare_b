import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studyspare_b/feature/course/domain/usecase/get_all_courses_usecase.dart';
import 'package:studyspare_b/feature/course/presentation/viewmodel/courses_list/course_list_event.dart';
import 'package:studyspare_b/feature/course/presentation/viewmodel/courses_list/courses_list_state.dart';

class CoursesListViewModel extends Bloc<CoursesListEvent, CoursesListState> {
  final GetAllCoursesUsecase _getAllCoursesUsecase;

  CoursesListViewModel({required GetAllCoursesUsecase getAllCoursesUsecase})
    : _getAllCoursesUsecase = getAllCoursesUsecase,
      super(const CoursesListState()) {
    on<LoadCourses>(_onLoadCourses);
  }

  Future<void> _onLoadCourses(
    LoadCourses event,
    Emitter<CoursesListState> emit,
  ) async {
    emit(state.copyWith(status: CoursesListStatus.loading));
    final result = await _getAllCoursesUsecase();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: CoursesListStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (courses) => emit(
        state.copyWith(status: CoursesListStatus.success, courses: courses),
      ),
    );
  }
}
