import 'package:equatable/equatable.dart';
import 'package:studyspare_b/feature/schedule/domain/entity/schedule_entity.dart';

abstract class ScheduleState extends Equatable {
  const ScheduleState();

  @override
  List<Object?> get props => [];
}

class ScheduleInitial extends ScheduleState {
  const ScheduleInitial();
}

class ScheduleLoading extends ScheduleState {
  const ScheduleLoading();
}

class SchedulesLoaded extends ScheduleState {
  final List<ScheduleEntity> schedules;
  final List<ScheduleEntity> upcomingSchedules;
  final List<ScheduleEntity> pastSchedules;

  const SchedulesLoaded({
    required this.schedules,
    required this.upcomingSchedules,
    required this.pastSchedules,
  });

  @override
  List<Object?> get props => [schedules, upcomingSchedules, pastSchedules];
}

class ScheduleCreated extends ScheduleState {
  final ScheduleEntity schedule;

  const ScheduleCreated({required this.schedule});

  @override
  List<Object?> get props => [schedule];
}

class ScheduleUpdated extends ScheduleState {
  final ScheduleEntity schedule;

  const ScheduleUpdated({required this.schedule});

  @override
  List<Object?> get props => [schedule];
}

class ScheduleDeleted extends ScheduleState {
  final String scheduleId;

  const ScheduleDeleted({required this.scheduleId});

  @override
  List<Object?> get props => [scheduleId];
}

class ScheduleError extends ScheduleState {
  final String message;

  const ScheduleError({required this.message});

  @override
  List<Object?> get props => [message];
}
