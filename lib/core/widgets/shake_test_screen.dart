import 'package:flutter/material.dart';
import 'package:studyspare_b/app/service_locator/service_locator.dart';
import 'package:studyspare_b/core/services/shake_detection_service.dart';

class ShakeTestScreen extends StatelessWidget {
  const ShakeTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shake Test Screen'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Shake Detection Test',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'This screen is for testing the shake detection feature.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                try {
                  final shakeService = serviceLocator<ShakeDetectionService>();
                  shakeService.triggerShakeManually();
                } catch (e) {
                  print('Error triggering manual shake: $e');
                }
              },
              child: const Text('Test Shake Detection'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Instructions:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('1. Make sure you are logged in'),
                  Text('2. Tap the "Test Shake Detection" button above'),
                  Text('3. Or shake your device (if on real device)'),
                  Text('4. Check the console for debug messages'),
                  Text('5. You should see a confirmation dialog to logout'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
