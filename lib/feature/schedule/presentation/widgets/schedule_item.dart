import 'package:flutter/material.dart';
import 'package:studyspare_b/feature/schedule/domain/entity/schedule_entity.dart';

class ScheduleItem extends StatelessWidget {
  final ScheduleEntity schedule;
  final VoidCallback onToggleComplete;
  final VoidCallback onDelete;

  const ScheduleItem({
    super.key,
    required this.schedule,
    required this.onToggleComplete,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final hasEventDate = schedule.eventDate != null;
    final isOverdue =
        hasEventDate &&
        !schedule.isCompleted &&
        schedule.eventDate!.isBefore(DateTime.now());

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: schedule.isCompleted ? Colors.grey.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color:
              schedule.isCompleted ? Colors.blue.shade200 : Colors.transparent,
        ),
      ),
      child: Row(
        children: [
          // Checkbox
          GestureDetector(
            onTap: onToggleComplete,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color:
                      schedule.isCompleted ? Colors.blue : Colors.grey.shade400,
                  width: 2,
                ),
                color: schedule.isCompleted ? Colors.blue : Colors.transparent,
              ),
              child:
                  schedule.isCompleted
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : null,
            ),
          ),
          const SizedBox(width: 16),

          // Schedule content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  schedule.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color:
                        schedule.isCompleted
                            ? Colors.grey.shade600
                            : Colors.black87,
                    decoration:
                        schedule.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                  ),
                ),
                if (schedule.description != null &&
                    schedule.description!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    schedule.description!,
                    style: TextStyle(
                      fontSize: 14,
                      color:
                          schedule.isCompleted
                              ? Colors.grey.shade500
                              : Colors.grey.shade600,
                      decoration:
                          schedule.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (hasEventDate) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        size: 14,
                        color: isOverdue ? Colors.red : Colors.grey.shade500,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Event: ${_formatDate(schedule.eventDate!)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: isOverdue ? Colors.red : Colors.grey.shade500,
                          fontWeight:
                              isOverdue ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          // Delete button
          IconButton(
            onPressed: onDelete,
            icon: Icon(
              Icons.delete_outline,
              color: Colors.grey.shade400,
              size: 20,
            ),
            tooltip: 'Delete event',
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final eventDate = DateTime(date.year, date.month, date.day);

    if (eventDate == today) {
      return 'Today';
    } else if (eventDate == tomorrow) {
      return 'Tomorrow';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
