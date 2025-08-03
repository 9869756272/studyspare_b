import 'package:flutter/material.dart';
import 'package:studyspare_b/app/service_locator/service_locator.dart';
import 'package:studyspare_b/core/services/double_tap_detection_service.dart';

class DoubleTapTestScreen extends StatelessWidget {
  const DoubleTapTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Double Tap to Add Note Test Screen'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Double Tap Detection Test',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Double tap anywhere on this screen to open the note editor.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () {
                try {
                  final doubleTapService =
                      serviceLocator<DoubleTapDetectionService>();
                  doubleTapService.triggerDoubleTapManually();
                } catch (e) {
                  print('Error triggering manual double tap: $e');
                }
              },
              icon: const Icon(Icons.touch_app),
              label: const Text('Test Double Tap Detection'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Or double tap anywhere on this screen!',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
