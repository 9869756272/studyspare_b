import 'package:equatable/equatable.dart';
import 'package:studyspare_b/feature/course/domain/entities/content.dart';
import 'package:studyspare_b/feature/course/domain/entities/course.dart';
import 'package:studyspare_b/feature/course/domain/entities/module.dart';

enum CourseDetailStatus { initial, loading, success, failure }

class CourseDetailState extends Equatable {
  final CourseDetailStatus status;
  final Course? course;
  final List<Module> modules;
  final Map<String, List<Content>> contentMap;
  final Set<String> openModuleIds;

  final Set<String> loadingModuleIds;

  final String? errorMessage;

  const CourseDetailState({
    this.status = CourseDetailStatus.initial,
    this.course,
    this.modules = const [],
    this.contentMap = const {},
    this.openModuleIds = const {},
    this.loadingModuleIds = const {},
    this.errorMessage,
  });

  CourseDetailState copyWith({
    CourseDetailStatus? status,
    Course? course,
    List<Module>? modules,
    Map<String, List<Content>>? contentMap,
    Set<String>? openModuleIds,
    Set<String>? loadingModuleIds,
    String? errorMessage,
  }) {
    return CourseDetailState(
      status: status ?? this.status,
      course: course ?? this.course,
      modules: modules ?? this.modules,
      contentMap: contentMap ?? this.contentMap,
      openModuleIds: openModuleIds ?? this.openModuleIds,
      loadingModuleIds: loadingModuleIds ?? this.loadingModuleIds,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    course,
    modules,
    contentMap,
    openModuleIds,
    loadingModuleIds,
    errorMessage,
  ];
}
