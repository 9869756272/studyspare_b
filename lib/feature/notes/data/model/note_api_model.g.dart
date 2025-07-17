// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoteApiModel _$NoteApiModelFromJson(Map<String, dynamic> json) => NoteApiModel(
      id: json['_id'] as String?,
      title: json['title'] as String,
      content: json['content'] as String,
      userId: json['userId'] as String,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$NoteApiModelToJson(NoteApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'userId': instance.userId,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
