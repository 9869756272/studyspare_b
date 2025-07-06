import 'package:equatable/equatable.dart';

class ScheduleEntity extends Equatable {
  final String? id;
  final String title;
  final String? description;
  final DateTime? eventDate;
  final bool isCompleted;
  final String userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ScheduleEntity({
    this.id,
    required this.title,
    this.description,
    this.eventDate,
    this.isCompleted = false,
    required this.userId,
    this.createdAt,
    this.updatedAt,
  });

  ScheduleEntity copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? eventDate,
    bool? isCompleted,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ScheduleEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      eventDate: eventDate ?? this.eventDate,
      isCompleted: isCompleted ?? this.isCompleted,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    eventDate,
    isCompleted,
    userId,
    createdAt,
    updatedAt,
  ];
}
