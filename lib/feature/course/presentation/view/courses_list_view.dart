import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studyspare_b/app/service_locator/service_locator.dart';
import 'package:studyspare_b/feature/course/domain/entities/course.dart';
import 'package:studyspare_b/feature/course/presentation/view/course_detail_view.dart';
import 'package:studyspare_b/feature/course/presentation/viewmodel/courses_list/course_list_event.dart';
import 'package:studyspare_b/feature/course/presentation/viewmodel/courses_list/courses_list_state.dart';
import 'package:studyspare_b/feature/course/presentation/viewmodel/courses_list/courses_list_view_model.dart';

class CoursesListView extends StatelessWidget {
  const CoursesListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              serviceLocator<CoursesListViewModel>()..add(const LoadCourses()),
      child: Scaffold(
        body: BlocBuilder<CoursesListViewModel, CoursesListState>(
          builder: (context, state) {
            switch (state.status) {
              case CoursesListStatus.loading:
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              case CoursesListStatus.failure:
                return Center(
                  child: Text(state.errorMessage ?? 'Failed to load courses'),
                );
              case CoursesListStatus.success:
                if (state.courses.isEmpty) {
                  return const Center(child: Text('No courses available yet.'));
                }
                return RefreshIndicator(
                  // ✨ DISPATCH AN EVENT on refresh.
                  onRefresh: () async {
                    context.read<CoursesListViewModel>().add(
                      const LoadCourses(),
                    );
                  },
                  child: Column(
                    // ... The rest of the UI is identical
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          "Available Courses",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: GridView.builder(
                          padding: const EdgeInsets.all(12),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.8,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                              ),
                          itemCount: state.courses.length,
                          itemBuilder: (context, index) {
                            final course = state.courses[index];
                            return _CourseCard(course: course);
                          },
                        ),
                      ),
                    ],
                  ),
                );
              case CoursesListStatus.initial:
                return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}

class _CourseCard extends StatelessWidget {
  final Course course;
  const _CourseCard({required this.course});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => CourseDetailView(courseId: course.id),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: Image.network(
                course.imageUrl ??
                    'https://placehold.co/600x400/00A79D/white?text=StudySphere',
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) =>
                        const Icon(Icons.school, size: 50, color: Colors.grey),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.title,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      course.description,
                      style: textTheme.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              color: colorScheme.primary,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Start Learning',
                    style: textTheme.labelLarge?.copyWith(
                      color: colorScheme.onSecondaryContainer,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward,
                    size: 16,
                    color: colorScheme.onSecondaryContainer,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
