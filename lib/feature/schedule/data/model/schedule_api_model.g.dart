// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScheduleApiModel _$ScheduleApiModelFromJson(Map<String, dynamic> json) =>
    ScheduleApiModel(
      id: json['_id'] as String?,
      title: json['title'] as String,
      description: json['description'] as String?,
      eventDate: json['eventDate'] == null
          ? null
          : DateTime.parse(json['eventDate'] as String),
      isCompleted: json['isCompleted'] as bool? ?? false,
      userId: json['userId'] as String,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ScheduleApiModelToJson(ScheduleApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'eventDate': instance.eventDate?.toIso8601String(),
      'isCompleted': instance.isCompleted,
      'userId': instance.userId,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
