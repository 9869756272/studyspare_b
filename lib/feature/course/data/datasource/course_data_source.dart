import 'package:studyspare_b/feature/course/data/model/course_data_model.dart';

abstract class ICourseDataSource {
  Future<List<CourseModel>> getAllCourses({required String token});
  Future<CourseModel> getCourseById({
    required String token,
    required String courseId,
  });
  Future<List<ModuleModel>> getModulesForCourse({
    required String token,
    required String courseId,
  });
  Future<List<ContentModel>> getContentForModule({
    required String token,
    required String moduleId,
  });
  Future<ContentModel> getContentById({
    required String token,
    required String contentId,
  });
}
