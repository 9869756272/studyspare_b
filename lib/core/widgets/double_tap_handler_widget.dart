import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studyspare_b/app/auth/auth_provider.dart';
import 'package:studyspare_b/app/service_locator/service_locator.dart';
import 'package:studyspare_b/core/services/double_tap_detection_service.dart';
import 'package:studyspare_b/feature/notes/presentation/view/note_edit_view.dart';
import 'package:studyspare_b/feature/notes/presentation/view_model/note_view_model.dart';
import 'package:studyspare_b/feature/notes/presentation/view/note_edit_view.dart';
import 'package:studyspare_b/feature/notes/presentation/view_model/note_view_model.dart';
import 'package:studyspare_b/feature/notes/presentation/view_model/note_event.dart';
import 'package:studyspare_b/app.dart';

class DoubleTapHandlerWidget extends StatefulWidget {
  final Widget child;

  const DoubleTapHandlerWidget({super.key, required this.child});

  @override
  State<DoubleTapHandlerWidget> createState() => _DoubleTapHandlerWidgetState();
}

class _DoubleTapHandlerWidgetState extends State<DoubleTapHandlerWidget> {
  late DoubleTapDetectionService _doubleTapDetectionService;
  late AuthProvider _authProvider;

  @override
  void initState() {
    super.initState();
    print('DoubleTapHandlerWidget: Initializing...');
    try {
      _doubleTapDetectionService = serviceLocator<DoubleTapDetectionService>();
      _authProvider = serviceLocator<AuthProvider>();
      print('DoubleTapHandlerWidget: Services initialized successfully');
      print(
        'DoubleTapHandlerWidget: User authenticated: ${_authProvider.isAuthenticated}',
      );
      _doubleTapDetectionService.setDoubleTapCallback(_onDoubleTapDetected);
      _doubleTapDetectionService.startListening();
      print('DoubleTapHandlerWidget: Double tap detection started');
    } catch (e) {
      print('DoubleTapHandlerWidget: Error initializing: $e');
    }
  }

  @override
  void dispose() {
    _doubleTapDetectionService.dispose();
    super.dispose();
  }

  void _onDoubleTapDetected() {
    if (!_authProvider.isAuthenticated) {
      print(
        'DoubleTapHandlerWidget: User not authenticated, ignoring double tap',
      );
      return;
    }

    if (!mounted) {
      print('DoubleTapHandlerWidget: Widget not mounted, ignoring double tap');
      return;
    }

    final currentUser = _authProvider.currentUser;
    if (currentUser == null) {
      print('DoubleTapHandlerWidget: No current user, ignoring double tap');
      return;
    }

    print('DoubleTapHandlerWidget: Processing double tap detection...');

    // Show a simple overlay message to indicate double tap was detected
    try {
      final overlay = Overlay.of(context);
      final overlayEntry = OverlayEntry(
        builder:
            (context) => Positioned(
              top: 100,
              left: 20,
              right: 20,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Text(
                    'Double tap detected! Opening note editor...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
      );

      overlay.insert(overlayEntry);
      Timer(const Duration(seconds: 2), () {
        overlayEntry.remove();
      });
    } catch (e) {
      print('DoubleTapHandlerWidget: Could not show overlay: $e');
      print('Double tap detected! Opening scheduler...');
    }

    // Navigate to note creation screen using global navigator key
    try {
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder:
              (context) => BlocProvider.value(
                value: serviceLocator<NoteViewModel>(),
                child: NoteEditView(
                  userId: currentUser.id,
                  onSaved: () {
                    navigatorKey.currentState?.pop();
                    // Refresh notes list if we're on the notes screen
                    serviceLocator<NoteViewModel>().add(const LoadNotes());
                  },
                ),
              ),
        ),
      );
    } catch (e) {
      print('DoubleTapHandlerWidget: Could not navigate to note editor: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _doubleTapDetectionService.onTap();
      },
      child: widget.child,
    );
  }
}
