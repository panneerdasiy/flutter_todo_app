import 'package:flutter/material.dart';

class MyMaterialApp extends StatelessWidget {
  final ElevatedButtonThemeData myElevatedButtonTheme = ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          minimumSize: const Size(64, 40),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))));
  final Map<String, WidgetBuilder> routes;

  MyMaterialApp({
    super.key,
    required this.routes,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(elevatedButtonTheme: myElevatedButtonTheme),
        darkTheme: ThemeData.dark()
            .copyWith(elevatedButtonTheme: myElevatedButtonTheme),
        routes: routes);
  }
}
