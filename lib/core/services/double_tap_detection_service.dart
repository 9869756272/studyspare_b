import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:studyspare_b/app/auth/auth_provider.dart';

class DoubleTapDetectionService {
  static const Duration _doubleTapTimeout = Duration(milliseconds: 300);

  final AuthProvider _authProvider;
  DateTime? _lastTapTime;
  bool _isListening = false;
  VoidCallback? _doubleTapCallback;

  DoubleTapDetectionService({required AuthProvider authProvider})
    : _authProvider = authProvider;

  void setDoubleTapCallback(VoidCallback callback) {
    _doubleTapCallback = callback;
  }

  void startListening() {
    if (_isListening) return;
    print('DoubleTapDetectionService: Starting to listen for double taps...');
    _isListening = true;
  }

  void stopListening() {
    if (!_isListening) return;
    print('DoubleTapDetectionService: Stopping double tap detection...');
    _isListening = false;
  }

  void onTap() {
    if (!_isListening) return;
    if (!_authProvider.isAuthenticated) {
      print('DoubleTapDetectionService: User not authenticated, ignoring tap');
      return;
    }

    final now = DateTime.now();
    if (_lastTapTime == null ||
        now.difference(_lastTapTime!) > _doubleTapTimeout) {
      _lastTapTime = now;
      print(
        'DoubleTapDetectionService: First tap detected, waiting for second...',
      );
      return;
    }

    // Double tap detected!
    print(
      'DoubleTapDetectionService: Double tap detected! Opening note editor...',
    );
    _lastTapTime = null; // Reset for next double tap
    _doubleTapCallback?.call();
  }

  void triggerDoubleTapManually() {
    print('DoubleTapDetectionService: Manual double tap triggered');
    _doubleTapCallback?.call();
  }

  void dispose() {
    stopListening();
  }
}
