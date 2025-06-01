//Material app
import 'package:flutter/material.dart';
import 'package:studyspare_b/theme/theme_data.dart';
import 'package:studyspare_b/view/splashscreeen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
   Widget build(BuildContext context) {
    return MaterialApp(
      home:  SplashScreen(),
      theme: getApplicationTheme(),
      debugShowCheckedModeBanner: false,
      );
   }
}



