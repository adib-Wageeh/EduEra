import 'package:education_app/core/res/fonts.dart';
import 'package:flutter/material.dart';

import 'core/res/colours.dart';
import 'core/services/router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          color: Colors.transparent,
        ),
        fontFamily: Fonts.poppins,
        colorScheme: ColorScheme.fromSwatch(accentColor: Colours.primaryColour),
      ),
      onGenerateRoute: generateFunction,
    );
  }
}
