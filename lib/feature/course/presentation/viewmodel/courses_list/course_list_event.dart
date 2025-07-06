import 'package:equatable/equatable.dart';

abstract class CoursesListEvent extends Equatable {
  const CoursesListEvent();

  @override
  List<Object> get props => [];
}

class LoadCourses extends CoursesListEvent {
  const LoadCourses();
}
