import 'package:equatable/equatable.dart';

abstract class ContentDetailEvent extends Equatable {
  const ContentDetailEvent();

  @override
  List<Object> get props => [];
}

class LoadContentDetail extends ContentDetailEvent {
  final String contentId;

  const LoadContentDetail({required this.contentId});

  @override
  List<Object> get props => [contentId];
}
