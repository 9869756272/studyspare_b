import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studyspare_b/app/service_locator/service_locator.dart';
import 'package:studyspare_b/feature/course/domain/entities/content.dart'
    as entity;
import 'package:studyspare_b/feature/course/domain/entities/module.dart'
    as entity;
import 'package:studyspare_b/feature/course/presentation/view/content_detail_view.dart';
import 'package:studyspare_b/feature/course/presentation/viewmodel/content/content_detail_event.dart';
import 'package:studyspare_b/feature/course/presentation/viewmodel/content/content_view_model.dart';
import 'package:studyspare_b/feature/course/presentation/viewmodel/course_detail/course_detail_event.dart';
import 'package:studyspare_b/feature/course/presentation/viewmodel/course_detail/course_detail_state.dart';
import 'package:studyspare_b/feature/course/presentation/viewmodel/course_detail/course_detail_view_model.dart';

class CourseDetailView extends StatelessWidget {
  final String courseId;
  const CourseDetailView({super.key, required this.courseId});

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey.shade300,
      child: Image.network(
        'https://placehold.co/600x400/00A79D/white?text=StudySphere',
        fit: BoxFit.cover,
        color: Colors.black.withOpacity(0.4),
        colorBlendMode: BlendMode.darken,
      ),
    );
  }

  Widget _buildImageWidget(String? url) {
    if (url == null || url.trim().isEmpty) {
      return _buildPlaceholder();
    }
    final trimmedUrl = url.trim();
    if (trimmedUrl.startsWith('data:image')) {
      try {
        final uri = Uri.parse(trimmedUrl);
        if (uri.data != null) {
          final bytes = uri.data!.contentAsBytes();
          if (bytes.isNotEmpty) {
            return Image.memory(
              bytes,
              fit: BoxFit.cover,
              gaplessPlayback: true,
              color: Colors.black.withOpacity(0.4),
              colorBlendMode: BlendMode.darken,
            );
          }
        }
      } catch (e) {
        debugPrint("Failed to parse data URI: $e");
      }
    }
    final uri = Uri.tryParse(trimmedUrl);
    if (uri != null &&
        uri.hasScheme &&
        (uri.scheme == 'https' || uri.scheme == 'http')) {
      return Image.network(
        trimmedUrl,
        fit: BoxFit.cover,
        color: Colors.black.withOpacity(0.4),
        colorBlendMode: BlendMode.darken,
        errorBuilder: (context, error, stackTrace) {
          debugPrint("Failed to load network image: $error");
          return _buildPlaceholder();
        },
      );
    }
    return _buildPlaceholder();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              serviceLocator<CourseDetailViewModel>()
                ..add(LoadCourseDetails(courseId: courseId)),
      child: Scaffold(
        body: BlocConsumer<CourseDetailViewModel, CourseDetailState>(
          listener: (context, state) {
            if (state.status == CourseDetailStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.errorMessage ?? 'An unexpected error occurred',
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            switch (state.status) {
              case CourseDetailStatus.loading:
              case CourseDetailStatus.initial:
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              case CourseDetailStatus.failure:
                if (state.course == null) {
                  return Center(
                    child: Text(
                      state.errorMessage ?? 'Failed to load course details',
                    ),
                  );
                }
                continue success;
              success:
              case CourseDetailStatus.success:
                if (state.course == null) {
                  return const Center(child: Text('Course not found.'));
                }
                final course = state.course!;
                return CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      expandedHeight: 220.0,
                      pinned: true,
                      stretch: true,
                      flexibleSpace: FlexibleSpaceBar(
                        title: Text(
                          course.title,
                          style: const TextStyle(
                            shadows: [
                              Shadow(color: Colors.black, blurRadius: 4),
                            ],
                          ),
                        ),
                        background: _buildImageWidget(course.imageUrl),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              course.title,
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              course.description,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                const Icon(
                                  Icons.library_books_outlined,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text('${state.modules.length} Modules'),
                              ],
                            ),
                            const Divider(height: 32),
                            Text(
                              'Syllabus',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                    _buildModuleList(context, state),
                  ],
                );
            }
          },
        ),
      ),
    );
  }

  Widget _buildModuleList(BuildContext context, CourseDetailState state) {
    if (state.modules.isEmpty) {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Center(
            child: Text(
              "No modules in this course yet.",
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
      );
    }
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final module = state.modules[index];
        return _CustomModuleTile(
          module: module,
          isExpanded: state.openModuleIds.contains(module.id),
          content: state.contentMap[module.id],
          isLoadingContent: state.loadingModuleIds.contains(module.id),
          onTap:
              () => context.read<CourseDetailViewModel>().add(
                ToggleModule(moduleId: module.id),
              ),
        );
      }, childCount: state.modules.length),
    );
  }
}

class _CustomModuleTile extends StatelessWidget {
  final entity.Module module;
  final bool isExpanded;
  final VoidCallback onTap;
  final List<entity.Content>? content;
  final bool isLoadingContent;
  const _CustomModuleTile({
    required this.module,
    required this.isExpanded,
    required this.onTap,
    this.content,
    this.isLoadingContent = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          ListTile(
            onTap: onTap,
            leading: CircleAvatar(
              child: Text(module.order.toString().padLeft(2, '0')),
            ),
            title: Text(
              module.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: AnimatedRotation(
              turns: isExpanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 200),
              child: const Icon(Icons.expand_more),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.fastOutSlowIn,
            child: SizedBox(
              width: double.infinity,
              child:
                  isExpanded
                      ? _buildExpandableContent(context)
                      : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableContent(BuildContext context) {
    if (isLoadingContent) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(child: CircularProgressIndicator.adaptive()),
      );
    }
    if (content == null || content!.isEmpty) {
      return const ListTile(
        dense: true,
        title: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'No lessons in this module yet.',
              style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
            ),
          ),
        ),
      );
    }
    return Column(
      children:
          content!.map((item) {
            return ListTile(
              dense: true,
              leading: Icon(
                item.contentType == entity.ContentType.video
                    ? Icons.play_circle_outline
                    : Icons.article_outlined,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text(item.title),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder:
                        (_) => BlocProvider.value(
                          value:
                              serviceLocator<ContentViewModel>()
                                ..add(LoadContentDetail(contentId: item.id)),
                          child: ContentDetailView(contentId: item.id),
                        ),
                  ),
                );
              },
            );
          }).toList(),
    );
  }
}
