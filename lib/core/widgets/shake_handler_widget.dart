import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studyspare_b/app/auth/auth_provider.dart';
import 'package:studyspare_b/app/service_locator/service_locator.dart';
import 'package:studyspare_b/core/services/shake_detection_service.dart';
import 'package:studyspare_b/feature/home/presentation/view_model/home_view_model.dart';
import 'package:studyspare_b/app.dart';

class ShakeHandlerWidget extends StatefulWidget {
  final Widget child;

  const ShakeHandlerWidget({super.key, required this.child});

  @override
  State<ShakeHandlerWidget> createState() => _ShakeHandlerWidgetState();
}

class _ShakeHandlerWidgetState extends State<ShakeHandlerWidget> {
  late ShakeDetectionService _shakeDetectionService;
  late AuthProvider _authProvider;

  @override
  void initState() {
    super.initState();
    print('ShakeHandlerWidget: Initializing...');

    try {
      _shakeDetectionService = serviceLocator<ShakeDetectionService>();
      _authProvider = serviceLocator<AuthProvider>();

      print('ShakeHandlerWidget: Services initialized successfully');
      print(
        'ShakeHandlerWidget: User authenticated: ${_authProvider.isAuthenticated}',
      );

      // Set up shake callback
      _shakeDetectionService.setShakeCallback(_onShakeDetected);

      // Start listening for shakes
      _shakeDetectionService.startListening();
      print('ShakeHandlerWidget: Shake detection started');
    } catch (e) {
      print('ShakeHandlerWidget: Error initializing: $e');
    }
  }

  @override
  void dispose() {
    _shakeDetectionService.stopListening();
    super.dispose();
  }

  void _onShakeDetected() {
    // Only proceed if user is authenticated
    if (!_authProvider.isAuthenticated) {
      print('ShakeHandlerWidget: User not authenticated, ignoring shake');
      return;
    }

    final currentUser = _authProvider.currentUser;
    if (currentUser == null) {
      print('ShakeHandlerWidget: No current user, ignoring shake');
      return;
    }

    print('ShakeHandlerWidget: Processing shake detection...');

    // Show a simple overlay message to indicate shake was detected
    try {
      if (mounted) {
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
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Shake detected! Opening logout confirmation...',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
        );

        overlay.insert(overlayEntry);

        // Remove the overlay after 2 seconds
        Future.delayed(const Duration(seconds: 2), () {
          overlayEntry.remove();
        });
      }
    } catch (e) {
      print('ShakeHandlerWidget: Could not show overlay: $e');
      // Fallback: just print to console
      print('Shake detected! Logging out...');
    }

    // Show confirmation dialog before logout
    try {
      if (mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirm Logout'),
              content: const Text('Are you sure you want to logout?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                    // Perform logout using HomeViewModel
                    try {
                      final homeViewModel = serviceLocator<HomeViewModel>();
                      homeViewModel.logout(context);
                      print(
                        'ShakeHandlerWidget: Logout performed successfully',
                      );
                    } catch (e) {
                      print('ShakeHandlerWidget: Could not perform logout: $e');
                    }
                  },
                  child: const Text('Logout'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print('ShakeHandlerWidget: Could not show confirmation dialog: $e');
      // Fallback: perform logout directly
      try {
        final homeViewModel = serviceLocator<HomeViewModel>();
        homeViewModel.logout(context);
        print('ShakeHandlerWidget: Logout performed successfully (fallback)');
      } catch (e) {
        print('ShakeHandlerWidget: Could not perform logout: $e');
      }
    }
  }

  // Manual test method for debugging
  void _manualTestShake() {
    print('ShakeHandlerWidget: Manual test triggered');
    _onShakeDetected();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
