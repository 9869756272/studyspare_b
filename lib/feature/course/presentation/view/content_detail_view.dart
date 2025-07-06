import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:studyspare_b/app/service_locator/service_locator.dart';
import 'package:studyspare_b/feature/course/domain/entities/content.dart'
    as ContentEntity;
import 'package:studyspare_b/feature/course/presentation/viewmodel/content/content_detail_event.dart';
import 'package:studyspare_b/feature/course/presentation/viewmodel/content/content_state.dart';
import 'package:studyspare_b/feature/course/presentation/viewmodel/content/content_view_model.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ContentDetailView extends StatelessWidget {
  final String contentId;
  const ContentDetailView({super.key, required this.contentId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              serviceLocator<ContentViewModel>()
                ..add(LoadContentDetail(contentId: contentId)),
      child: BlocBuilder<ContentViewModel, ContentDetailState>(
        builder: (context, state) {
          final appBarTitle =
              state.status == ContentDetailStatus.success &&
                      state.content != null
                  ? state.content!.title
                  : 'Loading Content...';

          return Scaffold(
            appBar: AppBar(title: Text(appBarTitle)),
            body: _buildBody(context, state),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, ContentDetailState state) {
    switch (state.status) {
      case ContentDetailStatus.initial:
      case ContentDetailStatus.loading:
        return const Center(child: CircularProgressIndicator.adaptive());

      case ContentDetailStatus.failure:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              state.errorMessage ?? 'Failed to load content. Please try again.',
              textAlign: TextAlign.center,
            ),
          ),
        );

      case ContentDetailStatus.success:
        if (state.content == null) {
          return const Center(child: Text('Content not found.'));
        }
        return _ContentViewer(content: state.content!);
    }
  }
}

class _ContentViewer extends StatelessWidget {
  final ContentEntity.Content content;
  const _ContentViewer({required this.content});

  @override
  Widget build(BuildContext context) {
    switch (content.contentType) {
      case ContentEntity.ContentType.video:
        return _VideoPlayerWidget(videoUrl: content.contentData);
      case ContentEntity.ContentType.text:
        return _HtmlContentWidget(htmlData: content.contentData);
      default:
        return const Center(child: Text('Unsupported content type.'));
    }
  }
}

class _HtmlContentWidget extends StatelessWidget {
  final String? htmlData;
  const _HtmlContentWidget({this.htmlData});

  @override
  Widget build(BuildContext context) {
    if (htmlData == null || htmlData!.trim().isEmpty) {
      return const Center(child: Text('This article is empty.'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Html(
        data: htmlData!,
        style: {
          "body": Style(
            fontSize: FontSize(16.0),
            lineHeight: const LineHeight(1.5),
          ),
          "p": Style(
            fontSize: FontSize(16.0),
            lineHeight: const LineHeight(1.5),
          ),
          "h1": Style(fontSize: FontSize(24.0), fontWeight: FontWeight.bold),
          "h2": Style(fontSize: FontSize(20.0), fontWeight: FontWeight.w600),
          "a": Style(
            color: Theme.of(context).colorScheme.primary,
            textDecoration: TextDecoration.none,
          ),
        },
      ),
    );
  }
}

class _VideoPlayerWidget extends StatefulWidget {
  final String? videoUrl;
  const _VideoPlayerWidget({this.videoUrl});

  @override
  State<_VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<_VideoPlayerWidget> {
  late final YoutubePlayerController _controller;
  bool _isPlayerReady = false;

  @override
  void initState() {
    super.initState();
    final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl ?? '');

    if (videoId != null) {
      _controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          forceHD: false,
        ),
      )..addListener(() {
        if (mounted && !_isPlayerReady) {
          setState(() {
            _isPlayerReady = true;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    if (YoutubePlayer.convertUrlToId(widget.videoUrl ?? '') != null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl ?? '');
    if (videoId == null) {
      return const Center(
        child: Text(
          'Invalid or unsupported video URL.',
          style: TextStyle(color: Colors.red),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
