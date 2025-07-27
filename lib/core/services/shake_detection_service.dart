import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:studyspare_b/app/auth/auth_provider.dart';

class ShakeDetectionService {
  static const double _shakeThreshold =
      8.0; // Lower threshold for easier testing
  static const Duration _shakeTimeout = Duration(milliseconds: 500);

  final AuthProvider _authProvider;
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  DateTime? _lastShakeTime;
  bool _isListening = false;

  ShakeDetectionService({required AuthProvider authProvider})
    : _authProvider = authProvider;

  /// Start listening for shake events
  void startListening() {
    if (_isListening) return;

    print(
      'ShakeDetectionService: Starting to listen for accelerometer events...',
    );
    _isListening = true;

    try {
      _accelerometerSubscription = accelerometerEventStream().listen(
        (AccelerometerEvent event) {
          _handleAccelerometerEvent(event);
        },
        onError: (error) {
          print('ShakeDetectionService: Accelerometer error: $error');
        },
      );
      print(
        'ShakeDetectionService: Successfully listening for accelerometer events',
      );
    } catch (e) {
      print('ShakeDetectionService: Error starting accelerometer: $e');
    }
  }

  /// Stop listening for shake events
  void stopListening() {
    _isListening = false;
    _accelerometerSubscription?.cancel();
    _accelerometerSubscription = null;
  }

  /// Handle accelerometer events and detect shakes
  void _handleAccelerometerEvent(AccelerometerEvent event) {
    // Only detect shake if user is authenticated
    if (!_authProvider.isAuthenticated) return;

    final double acceleration = _calculateAcceleration(event);

    // Debug: Print acceleration values (remove in production)
    print('Acceleration: $acceleration, Threshold: $_shakeThreshold');

    if (acceleration > _shakeThreshold) {
      final now = DateTime.now();

      // Prevent multiple shakes within timeout period
      if (_lastShakeTime == null ||
          now.difference(_lastShakeTime!) > _shakeTimeout) {
        _lastShakeTime = now;
        print('Shake detected! Opening logout confirmation...');
        _onShakeDetected();
      }
    }
  }

  /// Calculate the magnitude of acceleration
  double _calculateAcceleration(AccelerometerEvent event) {
    final double x = event.x;
    final double y = event.y;
    final double z = event.z;

    // Calculate the magnitude of acceleration
    return sqrt(x * x + y * y + z * z);
  }

  /// Callback when shake is detected
  void _onShakeDetected() {
    // This will be overridden by the callback provided to the service
    if (_shakeCallback != null) {
      _shakeCallback!();
    }
  }

  /// Callback function to be called when shake is detected
  VoidCallback? _shakeCallback;

  /// Set the callback function for shake detection
  void setShakeCallback(VoidCallback callback) {
    _shakeCallback = callback;
  }

  /// Dispose the service
  void dispose() {
    stopListening();
  }

  /// Manual test method for debugging
  void triggerShakeManually() {
    print('ShakeDetectionService: Manual shake triggered');
    _onShakeDetected();
  }
}
