import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studyspare_b/feature/schedule/domain/use_case/get_schedules_usecase.dart';
import 'package:studyspare_b/feature/schedule/domain/use_case/create_schedule_usecase.dart';
import 'package:studyspare_b/feature/schedule/domain/use_case/update_schedule_usecase.dart';
import 'package:studyspare_b/feature/schedule/domain/use_case/delete_schedule_usecase.dart';
import 'package:studyspare_b/feature/schedule/presentation/view_model/schedule_event.dart';
import 'package:studyspare_b/feature/schedule/presentation/view_model/schedule_state.dart';

class ScheduleViewModel extends Bloc<ScheduleEvent, ScheduleState> {
  final GetSchedulesUsecase _getSchedulesUsecase;
  final CreateScheduleUsecase _createScheduleUsecase;
  final UpdateScheduleUsecase _updateScheduleUsecase;
  final DeleteScheduleUsecase _deleteScheduleUsecase;

  ScheduleViewModel({
    required GetSchedulesUsecase getSchedulesUsecase,
    required CreateScheduleUsecase createScheduleUsecase,
    required UpdateScheduleUsecase updateScheduleUsecase,
    required DeleteScheduleUsecase deleteScheduleUsecase,
  }) : _getSchedulesUsecase = getSchedulesUsecase,
       _createScheduleUsecase = createScheduleUsecase,
       _updateScheduleUsecase = updateScheduleUsecase,
       _deleteScheduleUsecase = deleteScheduleUsecase,
       super(const ScheduleInitial()) {
    on<LoadSchedules>(_onLoadSchedules);
    on<CreateSchedule>(_onCreateSchedule);
    on<UpdateSchedule>(_onUpdateSchedule);
    on<DeleteSchedule>(_onDeleteSchedule);
    on<ToggleScheduleComplete>(_onToggleScheduleComplete);
  }

  Future<void> _onLoadSchedules(
    LoadSchedules event,
    Emitter<ScheduleState> emit,
  ) async {
    emit(const ScheduleLoading());
    final result = await _getSchedulesUsecase();
    result.fold((failure) => emit(ScheduleError(message: failure.message)), (
      schedules,
    ) {
      final now = DateTime.now();
      final upcoming =
          schedules
              .where(
                (e) =>
                    e.eventDate != null &&
                    (e.eventDate!.isAfter(now) || _isToday(e.eventDate!, now)),
              )
              .toList();
      final past =
          schedules
              .where(
                (e) =>
                    e.eventDate != null &&
                    e.eventDate!.isBefore(now) &&
                    !_isToday(e.eventDate!, now),
              )
              .toList();
      emit(
        SchedulesLoaded(
          schedules: schedules,
          upcomingSchedules: upcoming,
          pastSchedules: past,
        ),
      );
    });
  }

  Future<void> _onCreateSchedule(
    CreateSchedule event,
    Emitter<ScheduleState> emit,
  ) async {
    emit(const ScheduleLoading());
    final result = await _createScheduleUsecase(
      CreateScheduleParams(
        title: event.title,
        description: event.description,
        eventDate: event.eventDate,
        userId: event.userId,
      ),
    );
    result.fold((failure) => emit(ScheduleError(message: failure.message)), (
      schedule,
    ) {
      emit(ScheduleCreated(schedule: schedule));
      add(const LoadSchedules());
    });
  }

  Future<void> _onUpdateSchedule(
    UpdateSchedule event,
    Emitter<ScheduleState> emit,
  ) async {
    emit(const ScheduleLoading());
    final result = await _updateScheduleUsecase(
      UpdateScheduleParams(
        scheduleId: event.schedule.id!,
        title: event.schedule.title,
        description: event.schedule.description,
        eventDate: event.schedule.eventDate,
        isCompleted: event.isCompleted,
        userId: event.schedule.userId,
      ),
    );
    result.fold((failure) => emit(ScheduleError(message: failure.message)), (
      schedule,
    ) {
      emit(ScheduleUpdated(schedule: schedule));
      add(const LoadSchedules());
    });
  }

  Future<void> _onDeleteSchedule(
    DeleteSchedule event,
    Emitter<ScheduleState> emit,
  ) async {
    emit(const ScheduleLoading());
    final result = await _deleteScheduleUsecase(
      DeleteScheduleParams(scheduleId: event.scheduleId),
    );
    result.fold((failure) => emit(ScheduleError(message: failure.message)), (
      _,
    ) {
      emit(ScheduleDeleted(scheduleId: event.scheduleId));
      add(const LoadSchedules());
    });
  }

  Future<void> _onToggleScheduleComplete(
    ToggleScheduleComplete event,
    Emitter<ScheduleState> emit,
  ) async {
    emit(const ScheduleLoading());
    final result = await _updateScheduleUsecase(
      UpdateScheduleParams(
        scheduleId: event.schedule.id!,
        title: event.schedule.title,
        description: event.schedule.description,
        eventDate: event.schedule.eventDate,
        isCompleted: !event.schedule.isCompleted,
        userId: event.schedule.userId,
      ),
    );
    result.fold((failure) => emit(ScheduleError(message: failure.message)), (
      schedule,
    ) {
      emit(ScheduleUpdated(schedule: schedule));
      add(const LoadSchedules());
    });
  }

  bool _isToday(DateTime date, DateTime now) {
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}
