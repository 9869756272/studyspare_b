//Material app
import 'package:flutter/material.dart';
import 'package:studyspare_b/view/dashboard.dart';
import 'package:studyspare_b/view/loginpage.dart';
import 'package:studyspare_b/view/sign_up.dart';
import 'package:studyspare_b/view/splashscreeen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
   Widget build(BuildContext context) {
    return MaterialApp(
      home:  SplashScreen(),
      debugShowCheckedModeBanner: false,
      );
   }
}



