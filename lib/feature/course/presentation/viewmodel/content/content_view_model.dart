import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studyspare_b/feature/course/domain/usecase/get_content_by_id_usecase.dart';
import 'package:studyspare_b/feature/course/presentation/viewmodel/content/content_detail_event.dart';
import 'package:studyspare_b/feature/course/presentation/viewmodel/content/content_state.dart';

class ContentViewModel extends Bloc<ContentDetailEvent, ContentDetailState> {
  final GetContentByIdUsecase _getContentByIdUsecase;

  ContentViewModel({required GetContentByIdUsecase getContentByIdUsecase})
    : _getContentByIdUsecase = getContentByIdUsecase,
      super(const ContentDetailState()) {
    on<LoadContentDetail>(_onLoadContentDetail);
  }

  Future<void> _onLoadContentDetail(
    LoadContentDetail event,
    Emitter<ContentDetailState> emit,
  ) async {
    emit(state.copyWith(status: ContentDetailStatus.loading));

    final result = await _getContentByIdUsecase(
      GetContentByIdParams(contentId: event.contentId),
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: ContentDetailStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (content) {
        emit(
          state.copyWith(status: ContentDetailStatus.success, content: content),
        );
      },
    );
  }
}
