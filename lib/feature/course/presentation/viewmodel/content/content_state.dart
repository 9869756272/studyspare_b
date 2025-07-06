import 'package:equatable/equatable.dart';
import 'package:studyspare_b/feature/course/domain/entities/content.dart';

enum ContentDetailStatus { initial, loading, success, failure }

class ContentDetailState extends Equatable {
  final ContentDetailStatus status;
  final Content? content;
  final String? errorMessage;

  const ContentDetailState({
    this.status = ContentDetailStatus.initial,
    this.content,
    this.errorMessage,
  });

  ContentDetailState copyWith({
    ContentDetailStatus? status,
    Content? content,
    String? errorMessage,
  }) {
    return ContentDetailState(
      status: status ?? this.status,
      content: content ?? this.content,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, content, errorMessage];
}
