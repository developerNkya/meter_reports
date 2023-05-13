import 'package:flutter/material.dart';
import 'package:grocery_app/splash_screen/splash_screen.dart';
import 'package:grocery_app/styles/theme.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: themeData,
      home: SplashScreen(),
    );
  }
}
