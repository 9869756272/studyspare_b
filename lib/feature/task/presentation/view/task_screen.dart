import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studyspare_b/core/common/snackbar.dart';
import 'package:studyspare_b/feature/task/domain/entity/task_entity.dart';
import 'package:studyspare_b/feature/task/presentation/view_model/task_event.dart';
import 'package:studyspare_b/feature/task/presentation/view_model/task_state.dart';
import 'package:studyspare_b/feature/task/presentation/view_model/task_view_model.dart';
import 'package:studyspare_b/feature/task/presentation/widgets/task_form.dart';
import 'package:studyspare_b/feature/task/presentation/widgets/task_item.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TaskViewModel>().add(const LoadTasks());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<TaskViewModel, TaskState>(
        listener: (context, state) {
          if (state is TaskError) {
            showMySnackBar(
              context: context,
              message: state.message,
              color: Colors.red,
            );
          } else if (state is TaskCreated) {
            showMySnackBar(
              context: context,
              message: 'Task created successfully!',
              color: Colors.green,
            );
          } else if (state is TaskUpdated) {
            showMySnackBar(
              context: context,
              message: 'Task updated successfully!',
              color: Colors.green,
            );
          } else if (state is TaskDeleted) {
            showMySnackBar(
              context: context,
              message: 'Task deleted successfully!',
              color: Colors.green,
            );
          }
        },
        child: BlocBuilder<TaskViewModel, TaskState>(
          builder: (context, state) {
            if (state is TaskLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is TasksLoaded) {
              return _buildTaskList(state);
            }

            if (state is TaskError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${state.message}',
                      style: const TextStyle(fontSize: 16, color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<TaskViewModel>().add(const LoadTasks());
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            return const Center(child: Text('No tasks found'));
          },
        ),
      ),
    );
  }

  Widget _buildTaskList(TasksLoaded state) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'My Task Tracker',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Manage your assignments and stay on top of your studies.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // Task Form
            const TaskForm(),
            const SizedBox(height: 32),

            // Pending Tasks Section
            _buildTaskSection(
              title: 'To-Do',
              icon: Icons.list_alt,
              tasks: state.pendingTasks,
              emptyMessage: 'All tasks completed!',
              emptySubMessage: 'Ready to add a new one?',
              iconColor: Colors.teal,
            ),

            const SizedBox(height: 24),

            // Completed Tasks Section
            if (state.completedTasks.isNotEmpty)
              _buildTaskSection(
                title: 'Completed',
                icon: Icons.check_circle_outline,
                tasks: state.completedTasks,
                emptyMessage: 'No completed tasks yet',
                emptySubMessage: 'Complete some tasks to see them here',
                iconColor: Colors.grey,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskSection({
    required String title,
    required IconData icon,
    required List<TaskEntity> tasks,
    required String emptyMessage,
    required String emptySubMessage,
    required Color iconColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: iconColor, size: 24),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (tasks.isEmpty)
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: 48,
                  color: Colors.green.withOpacity(0.6),
                ),
                const SizedBox(height: 16),
                Text(
                  emptyMessage,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  emptySubMessage,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: tasks.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final task = tasks[index];
              return TaskItem(
                task: task,
                onToggleComplete: () {
                  context.read<TaskViewModel>().add(
                    ToggleTaskComplete(task: task),
                  );
                },
                onDelete: () {
                  _showDeleteConfirmation(task);
                },
              );
            },
          ),
      ],
    );
  }

  void _showDeleteConfirmation(TaskEntity task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Task'),
          content: Text(
            'Are you sure you want to delete this task: "${task.title}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<TaskViewModel>().add(DeleteTask(taskId: task.id!));
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
