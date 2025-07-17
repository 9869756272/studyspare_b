import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:studyspare_b/feature/notes/domain/entity/note_entity.dart';

part 'note_api_model.g.dart';

@JsonSerializable()
class NoteApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? id;
  final String title;
  final String content;
  @JsonKey(name: 'userId')
  final String userId;
  @JsonKey(name: 'createdAt')
  final DateTime? createdAt;
  @JsonKey(name: 'updatedAt')
  final DateTime? updatedAt;

  const NoteApiModel({
    this.id,
    required this.title,
    required this.content,
    required this.userId,
    this.createdAt,
    this.updatedAt,
  });

  factory NoteApiModel.fromJson(Map<String, dynamic> json) =>
      _$NoteApiModelFromJson(json);
  Map<String, dynamic> toJson() => _$NoteApiModelToJson(this);

  factory NoteApiModel.fromEntity(NoteEntity entity) {
    return NoteApiModel(
      id: entity.id,
      title: entity.title,
      content: entity.content,
      userId: entity.userId,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  NoteEntity toEntity() {
    return NoteEntity(
      id: id,
      title: title,
      content: content,
      userId: userId,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  @override
  List<Object?> get props => [id, title, content, userId, createdAt, updatedAt];
}
