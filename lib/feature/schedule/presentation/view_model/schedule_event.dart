import 'package:equatable/equatable.dart';
import 'package:studyspare_b/feature/schedule/domain/entity/schedule_entity.dart';

abstract class ScheduleEvent extends Equatable {
  const ScheduleEvent();

  @override
  List<Object?> get props => [];
}

class LoadSchedules extends ScheduleEvent {
  const LoadSchedules();
}

class CreateSchedule extends ScheduleEvent {
  final String title;
  final String? description;
  final DateTime? eventDate;
  final String userId;

  const CreateSchedule({
    required this.title,
    this.description,
    this.eventDate,
    required this.userId,
  });

  @override
  List<Object?> get props => [title, description, eventDate, userId];
}

class UpdateSchedule extends ScheduleEvent {
  final ScheduleEntity schedule;
  final bool isCompleted;

  const UpdateSchedule({required this.schedule, required this.isCompleted});

  @override
  List<Object?> get props => [schedule, isCompleted];
}

class DeleteSchedule extends ScheduleEvent {
  final String scheduleId;

  const DeleteSchedule({required this.scheduleId});

  @override
  List<Object?> get props => [scheduleId];
}

class ToggleScheduleComplete extends ScheduleEvent {
  final ScheduleEntity schedule;

  const ToggleScheduleComplete({required this.schedule});

  @override
  List<Object?> get props => [schedule];
}
