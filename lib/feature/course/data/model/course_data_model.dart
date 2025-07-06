import 'package:studyspare_b/feature/course/domain/entities/content.dart';
import 'package:studyspare_b/feature/course/domain/entities/course.dart';
import 'package:studyspare_b/feature/course/domain/entities/module.dart';

class CourseModel extends Course {
  const CourseModel({
    required super.id,
    required super.title,
    required super.description,
    super.imageUrl,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
    );
  }
}

class ModuleModel extends Module {
  const ModuleModel({
    required super.id,
    required super.title,
    required super.order,
    required super.courseId,
  });

  factory ModuleModel.fromJson(Map<String, dynamic> json) {
    return ModuleModel(
      id: json['_id'],
      title: json['title'],
      order: json['order'],
      courseId: json['courseId'], // Assuming 'course' field holds the course ID
    );
  }
}

class ContentModel extends Content {
  const ContentModel({
    required super.id,
    required super.title,
    required super.contentType,
    required super.contentData,
    required super.moduleId,
  });

  static ContentType _contentTypeFromString(String type) {
    if (type == 'VIDEO_URL') return ContentType.video;
    if (type == 'TEXT') return ContentType.text;
    return ContentType.unknown;
  }

  factory ContentModel.fromJson(Map<String, dynamic> json) {
    return ContentModel(
      id: json['_id'],
      title: json['title'],
      contentType: _contentTypeFromString(json['contentType']),
      contentData:
          json['contentData'], // Assuming this holds the URL or text data
      moduleId: json['moduleId'], // Assuming 'module' field holds the module ID
    );
  }
}
