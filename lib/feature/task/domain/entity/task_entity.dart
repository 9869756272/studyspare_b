import 'package:equatable/equatable.dart';

class TaskEntity extends Equatable {
  final String? id;
  final String title;
  final String? description;
  final DateTime? dueDate;
  final bool isCompleted;
  final String userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const TaskEntity({
    this.id,
    required this.title,
    this.description,
    this.dueDate,
    this.isCompleted = false,
    required this.userId,
    this.createdAt,
    this.updatedAt,
  });

  TaskEntity copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    bool? isCompleted,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TaskEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
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
    dueDate,
    isCompleted,
    userId,
    createdAt,
    updatedAt,
  ];
}
