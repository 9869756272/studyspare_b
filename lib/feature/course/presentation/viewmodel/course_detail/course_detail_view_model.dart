import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studyspare_b/feature/course/domain/entities/content.dart';
import 'package:studyspare_b/feature/course/domain/usecase/get_content_for_module_usecase.dart';
import 'package:studyspare_b/feature/course/domain/usecase/get_course_by_id_usecase.dart';
import 'package:studyspare_b/feature/course/domain/usecase/get_modules_for_course_usecase.dart';
import 'package:studyspare_b/feature/course/presentation/viewmodel/course_detail/course_detail_event.dart';
import 'package:studyspare_b/feature/course/presentation/viewmodel/course_detail/course_detail_state.dart';

class CourseDetailViewModel extends Bloc<CourseDetailEvent, CourseDetailState> {
  final GetCourseByIdUsecase _getCourseByIdUsecase;
  final GetModulesForCourseUsecase _getModulesForCourseUsecase;
  final GetContentForModuleUsecase _getContentForModuleUsecase;

  CourseDetailViewModel({
    required GetCourseByIdUsecase getCourseByIdUsecase,
    required GetModulesForCourseUsecase getModulesForCourseUsecase,
    required GetContentForModuleUsecase getContentForModuleUsecase,
  }) : _getCourseByIdUsecase = getCourseByIdUsecase,
       _getModulesForCourseUsecase = getModulesForCourseUsecase,
       _getContentForModuleUsecase = getContentForModuleUsecase,
       super(const CourseDetailState()) {
    on<LoadCourseDetails>(_onLoadCourseDetails);
    on<ToggleModule>(_onToggleModule);
  }

  Future<void> _onLoadCourseDetails(
    LoadCourseDetails event,
    Emitter<CourseDetailState> emit,
  ) async {
    emit(state.copyWith(status: CourseDetailStatus.loading));

    final courseResult = await _getCourseByIdUsecase(
      GetCourseByIdParams(courseId: event.courseId),
    );

    if (courseResult.isLeft()) {
      final failure = courseResult.fold((l) => l, (r) => null)!;
      emit(
        state.copyWith(
          status: CourseDetailStatus.failure,
          errorMessage: failure.message,
        ),
      );
      return;
    }
    final course = courseResult.fold((l) => null, (r) => r)!;

    final modulesResult = await _getModulesForCourseUsecase(
      GetModulesForCourseParams(courseId: event.courseId),
    );

    modulesResult.fold(
      (failure) {
        emit(
          state.copyWith(
            status: CourseDetailStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (modules) {
        emit(
          state.copyWith(
            status: CourseDetailStatus.success,
            course: course,
            modules: modules,
          ),
        );
      },
    );
  }

  Future<void> _onToggleModule(
    ToggleModule event,
    Emitter<CourseDetailState> emit,
  ) async {
    final moduleId = event.moduleId;
    final newOpenModuleIds = Set<String>.from(state.openModuleIds);
    final isOpening = !newOpenModuleIds.contains(moduleId);

    if (isOpening) {
      newOpenModuleIds.add(moduleId);
    } else {
      newOpenModuleIds.remove(moduleId);
    }

    // Immediately update the UI to show the module as open/closed
    emit(state.copyWith(openModuleIds: newOpenModuleIds));

    // If we are opening the module and its content hasn't been fetched yet
    if (isOpening && !state.contentMap.containsKey(moduleId)) {
      await _fetchContentForModule(moduleId, emit);
    }
  }

  /// Private helper to fetch and update state for a single module's content.
  Future<void> _fetchContentForModule(
    String moduleId,
    Emitter<CourseDetailState> emit,
  ) async {
    // Mark this specific module as loading
    final loadingIds = Set<String>.from(state.loadingModuleIds)..add(moduleId);
    emit(state.copyWith(loadingModuleIds: loadingIds));

    final result = await _getContentForModuleUsecase(
      GetContentForModuleParams(moduleId: moduleId),
    );

    // When done, update the final state in a single emit call
    final finalLoadingIds = Set<String>.from(state.loadingModuleIds)
      ..remove(moduleId);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            loadingModuleIds: finalLoadingIds,
            // Use a more specific error message if desired
            errorMessage: "Failed to load lessons for module.",
          ),
        );
      },
      (contentList) {
        final newContentMap = Map<String, List<Content>>.from(state.contentMap)
          ..[moduleId] = contentList;

        emit(
          state.copyWith(
            contentMap: newContentMap,
            loadingModuleIds: finalLoadingIds,
          ),
        );
      },
    );
  }
}
