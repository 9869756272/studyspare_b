import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:studyspare_b/feature/schedule/domain/entity/schedule_entity.dart';

part 'schedule_api_model.g.dart';

@JsonSerializable()
class ScheduleApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? id;
  final String title;
  final String? description;
  @JsonKey(name: 'eventDate')
  final DateTime? eventDate;
  @JsonKey(name: 'isCompleted')
  final bool isCompleted;
  @JsonKey(name: 'userId')
  final String userId;
  @JsonKey(name: 'createdAt')
  final DateTime? createdAt;
  @JsonKey(name: 'updatedAt')
  final DateTime? updatedAt;

  const ScheduleApiModel({
    this.id,
    required this.title,
    this.description,
    this.eventDate,
    this.isCompleted = false,
    required this.userId,
    this.createdAt,
    this.updatedAt,
  });

  factory ScheduleApiModel.fromJson(Map<String, dynamic> json) =>
      _$ScheduleApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduleApiModelToJson(this);

  factory ScheduleApiModel.fromEntity(ScheduleEntity entity) {
    return ScheduleApiModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      eventDate: entity.eventDate,
      isCompleted: entity.isCompleted,
      userId: entity.userId,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  ScheduleEntity toEntity() {
    return ScheduleEntity(
      id: id,
      title: title,
      description: description,
      eventDate: eventDate,
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
    eventDate,
    isCompleted,
    userId,
    createdAt,
    updatedAt,
  ];
}
