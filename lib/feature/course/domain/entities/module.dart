import 'package:equatable/equatable.dart';

class Module extends Equatable {
  final String id;
  final String title;
  final int order;
  final String courseId;

  const Module({
    required this.id,
    required this.title,
    required this.order,
    required this.courseId,
  });

  @override
  List<Object?> get props => [id, title, order, courseId];
}
