import 'package:equatable/equatable.dart';
import 'package:studyspare_b/feature/course/domain/entities/course.dart';

enum CoursesListStatus { initial, loading, success, failure }

class CoursesListState extends Equatable {
  final CoursesListStatus status;
  final List<Course> courses;
  final String? errorMessage;

  const CoursesListState({
    this.status = CoursesListStatus.initial,
    this.courses = const [],
    this.errorMessage,
  });

  //initial state
  factory CoursesListState.initial() {
    return const CoursesListState();
  }

  CoursesListState copyWith({
    CoursesListStatus? status,
    List<Course>? courses,
    String? errorMessage,
  }) {
    return CoursesListState(
      status: status ?? this.status,
      courses: courses ?? this.courses,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, courses, errorMessage];
}
