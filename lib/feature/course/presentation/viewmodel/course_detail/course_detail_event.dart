import 'package:equatable/equatable.dart';

abstract class CourseDetailEvent extends Equatable {
  const CourseDetailEvent();

  @override
  List<Object> get props => [];
}

class LoadCourseDetails extends CourseDetailEvent {
  final String courseId;

  const LoadCourseDetails({required this.courseId});

  @override
  List<Object> get props => [courseId];
}

class ToggleModule extends CourseDetailEvent {
  final String moduleId;

  const ToggleModule({required this.moduleId});

  @override
  List<Object> get props => [moduleId];
}
