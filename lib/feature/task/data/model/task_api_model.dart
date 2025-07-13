import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:studyspare_b/feature/task/domain/entity/task_entity.dart';

part 'task_api_model.g.dart';

@JsonSerializable()
class TaskApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? id;
  final String title;
  final String? description;
  @JsonKey(name: 'dueDate')
  final DateTime? dueDate;
  @JsonKey(name: 'isCompleted')
  final bool isCompleted;
  @JsonKey(name: 'userId')
  final String userId;
  @JsonKey(name: 'createdAt')
  final DateTime? createdAt;
  @JsonKey(name: 'updatedAt')
  final DateTime? updatedAt;

  const TaskApiModel({
    this.id,
    required this.title,
    this.description,
    this.dueDate,
    this.isCompleted = false,
    required this.userId,
    this.createdAt,
    this.updatedAt,
  });

  factory TaskApiModel.fromJson(Map<String, dynamic> json) =>
      _$TaskApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$TaskApiModelToJson(this);

  factory TaskApiModel.fromEntity(TaskEntity entity) {
    return TaskApiModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      dueDate: entity.dueDate,
      isCompleted: entity.isCompleted,
      userId: entity.userId,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  TaskEntity toEntity() {
    return TaskEntity(
      id: id,
      title: title,
      description: description,
      dueDate: dueDate,
      isCompleted: isCompleted,
      userId: userId,
      createdAt: createdAt,
      updatedAt: updatedAt,
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
