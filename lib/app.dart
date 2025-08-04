import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:studyspare_b/app/auth/auth_provider.dart';
import 'package:studyspare_b/app/service_locator/service_locator.dart';
import 'package:studyspare_b/feature/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:studyspare_b/feature/auth/presentation/view_model/register_view_model/register_view_model.dart';
import 'package:studyspare_b/theme/theme_data.dart';
import 'package:studyspare_b/view/splashscreeen.dart';
import 'package:studyspare_b/core/widgets/shake_handler_widget.dart';
import 'package:studyspare_b/core/widgets/double_tap_handler_widget.dart';

// Global navigator key for shake detection
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // AuthProvider at root level
        BlocProvider<AuthProvider>.value(value: serviceLocator<AuthProvider>()),
        BlocProvider<RegisterViewModel>.value(
          value: serviceLocator<RegisterViewModel>(),
        ),
        BlocProvider<LoginViewModel>.value(
          value: serviceLocator<LoginViewModel>(),
        ),
      ],
      child: DoubleTapHandlerWidget(
        child: MaterialApp(
          title: 'StudySpare',
          navigatorKey: navigatorKey,
          localizationsDelegates: const [FlutterQuillLocalizations.delegate],
          supportedLocales: const [
            // Add all the locales you want to support
            Locale('en'),
          ],
          debugShowCheckedModeBanner: false,
          theme: getApplicationTheme(),
          home: SplashScreen(),
        ),
      ),
    );
  }
}
