
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studyspare_b/app/service_locator/service_locator.dart';
import 'package:studyspare_b/feature/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:studyspare_b/feature/auth/presentation/view_model/register_view_model/register_view_model.dart';
import 'package:studyspare_b/theme/theme_data.dart';
import 'package:studyspare_b/view/splashscreeen.dart';


class MyApp extends StatelessWidget{
  const MyApp({super.key});
  @override
   Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RegisterViewModel>.value(
          value: serviceLocator<RegisterViewModel>(),
        ),
        BlocProvider<LoginViewModel>.value(
          value: serviceLocator<LoginViewModel>(),
        ),
      ],
      child: MaterialApp(
       
        debugShowCheckedModeBanner: false,
        theme: getApplicationTheme(),
        home: SplashScreen(), 
      ),
    );
  }
}