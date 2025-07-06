import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studyspare_b/core/common/snackbar.dart';
import 'package:studyspare_b/feature/schedule/domain/entity/schedule_entity.dart';
import 'package:studyspare_b/feature/schedule/presentation/view_model/schedule_view_model.dart';
import 'package:studyspare_b/feature/schedule/presentation/view_model/schedule_event.dart';
import 'package:studyspare_b/feature/schedule/presentation/view_model/schedule_state.dart';
import 'package:studyspare_b/feature/schedule/presentation/widgets/schedule_form.dart';
import 'package:studyspare_b/feature/schedule/presentation/widgets/schedule_item.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ScheduleViewModel>().add(const LoadSchedules());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<ScheduleViewModel, ScheduleState>(
        listener: (context, state) {
          if (state is ScheduleError) {
            showMySnackBar(
              context: context,
              message: state.message,
              color: Colors.red,
            );
          } else if (state is ScheduleCreated) {
            showMySnackBar(
              context: context,
              message: 'Event created successfully!',
              color: Colors.green,
            );
          } else if (state is ScheduleUpdated) {
            showMySnackBar(
              context: context,
              message: 'Event updated successfully!',
              color: Colors.green,
            );
          } else if (state is ScheduleDeleted) {
            showMySnackBar(
              context: context,
              message: 'Event deleted successfully!',
              color: Colors.green,
            );
          }
        },
        child: BlocBuilder<ScheduleViewModel, ScheduleState>(
          builder: (context, state) {
            if (state is ScheduleLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is SchedulesLoaded) {
              return _buildScheduleList(state);
            }
            if (state is ScheduleError) {
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
                        context.read<ScheduleViewModel>().add(
                          const LoadSchedules(),
                        );
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            return const Center(child: Text('No events found'));
          },
        ),
      ),
    );
  }

  Widget _buildScheduleList(SchedulesLoaded state) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'My Scheduler',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Plan your study sessions and track important dates.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            const ScheduleForm(),
            const SizedBox(height: 32),
            _buildScheduleSection(
              title: 'Upcoming Events',
              icon: Icons.event,
              schedules: state.upcomingSchedules,
              emptyMessage: 'No upcoming events',
              emptySubMessage: 'Click "Add" to schedule a new event.',
              iconColor: Colors.blue,
            ),
            const SizedBox(height: 24),
            if (state.pastSchedules.isNotEmpty)
              _buildScheduleSection(
                title: 'Past Events',
                icon: Icons.history,
                schedules: state.pastSchedules,
                emptyMessage: 'No past events yet',
                emptySubMessage: 'Events you complete or miss will show here.',
                iconColor: Colors.grey,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleSection({
    required String title,
    required IconData icon,
    required List<ScheduleEntity> schedules,
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
        if (schedules.isEmpty)
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
                Icon(icon, size: 48, color: iconColor.withOpacity(0.6)),
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
            itemCount: schedules.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final schedule = schedules[index];
              return ScheduleItem(
                schedule: schedule,
                onToggleComplete: () {
                  context.read<ScheduleViewModel>().add(
                    ToggleScheduleComplete(schedule: schedule),
                  );
                },
                onDelete: () {
                  _showDeleteConfirmation(schedule);
                },
              );
            },
          ),
      ],
    );
  }

  void _showDeleteConfirmation(ScheduleEntity schedule) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Event'),
          content: Text(
            'Are you sure you want to delete this event: "${schedule.title}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<ScheduleViewModel>().add(
                  DeleteSchedule(scheduleId: schedule.id!),
                );
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
