import 'package:flutter/material.dart';

// Define a cheerful light theme
final ThemeData cheerfulLightTheme = ThemeData(
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: Colors.yellow,
    accentColor: Colors.orange,
    backgroundColor: Colors.lightBlue[50]!,
  ).copyWith(
    surface: Colors.lightBlue[50],
  ),
  scaffoldBackgroundColor: Colors.lightBlue[50],
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.yellow[700],
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(color: Colors.white),
    actionsIconTheme: IconThemeData(color: Colors.white),
  ),
  textTheme: _buildTextTheme(Colors.black87),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.orange),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.orange[700]!),
    ),
    labelStyle: TextStyle(color: Colors.orange),
  ),
);

// Define a cheerful dark theme
final ThemeData cheerfulDarkTheme = ThemeData(
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: Colors.yellow,
    accentColor: Colors.orange,
    brightness: Brightness.dark,
    backgroundColor: Colors.grey[850]!,
  ).copyWith(
    surface: Colors.grey[850],
  ),
  scaffoldBackgroundColor: Colors.grey[850],
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.yellow[700],
    titleTextStyle: TextStyle(
      color: Colors.black87,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(color: Colors.black87),
    actionsIconTheme: IconThemeData(color: Colors.black87),
  ),
  textTheme: _buildTextTheme(Colors.white),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.orange),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.orange[700]!),
    ),
    labelStyle: TextStyle(color: Colors.orange),
  ),
);

TextTheme _buildTextTheme(Color color) {
  return TextTheme(
    displayLarge: TextStyle(color: color, fontSize: 24),
    displayMedium: TextStyle(color: color, fontSize: 22),
    displaySmall: TextStyle(color: color, fontSize: 20),
    headlineLarge: TextStyle(color: color, fontSize: 24),
    headlineMedium: TextStyle(color: color, fontSize: 22),
    headlineSmall: TextStyle(color: color, fontSize: 20),
    titleLarge: TextStyle(color: color, fontSize: 20),
    titleMedium: TextStyle(color: color, fontSize: 18),
    titleSmall: TextStyle(color: color, fontSize: 16),
    bodyLarge: TextStyle(color: color, fontSize: 16),
    bodyMedium: TextStyle(color: color, fontSize: 14),
    bodySmall: TextStyle(color: color, fontSize: 12),
    labelLarge: TextStyle(color: color, fontSize: 14),
    labelMedium: TextStyle(color: color, fontSize: 12),
    labelSmall: TextStyle(color: color, fontSize: 10),
  );
}
