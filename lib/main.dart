
import 'package:flutter/widgets.dart';
import 'package:studyspare_b/app.dart';
import 'package:studyspare_b/app/service_locator/service_locator.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependencies and HiveService together
  await initDependencies();

  runApp(MyApp());
}