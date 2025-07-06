import 'package:equatable/equatable.dart';

class Course extends Equatable {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;

  const Course({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [id, title, description, imageUrl];
}
