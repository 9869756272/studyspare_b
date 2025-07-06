import 'package:equatable/equatable.dart';

enum ContentType { video, text, unknown }

class Content extends Equatable {
  final String id;
  final String title;
  final ContentType contentType;
  final String contentData; // Assuming URL is used for video content
  final String moduleId;

  const Content({
    required this.id,
    required this.title,
    required this.contentType,
    required this.contentData,
    required this.moduleId,
  });

  @override
  List<Object?> get props => [id, title, contentType, contentData, moduleId];
}
