import 'package:flutter/material.dart';

final ThemeData cliDarkTheme = ThemeData(
  colorScheme: ColorScheme.dark(
    primary: Colors.greenAccent,
    secondary: Colors.lightGreen,
    surface: Colors.black,
    onSurface: Colors.white70,
    background: Colors.black,
    onBackground: Colors.white70,
    error: Colors.redAccent,
    onError: Colors.black,
  ),
  scaffoldBackgroundColor: Colors.black,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.black,
    titleTextStyle: TextStyle(
      color: Colors.greenAccent,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(color: Colors.greenAccent),
    actionsIconTheme: IconThemeData(color: Colors.greenAccent),
    elevation: 0,
  ),
  textTheme: _buildCliTextTheme(Colors.greenAccent),
  inputDecorationTheme: InputDecorationTheme(
    border: InputBorder.none,
    enabledBorder: InputBorder.none,
    focusedBorder: InputBorder.none,
    labelStyle: TextStyle(color: Colors.greenAccent),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.greenAccent,
      foregroundColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      elevation: 0,
    ),
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: Colors.greenAccent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.zero,
    ),
  ),
  iconTheme: IconThemeData(color: Colors.greenAccent),
  visualDensity: VisualDensity.compact,
  useMaterial3: true,
);

final ThemeData cliLightTheme = ThemeData(
  colorScheme: ColorScheme.light(
    primary: Colors.blueAccent,
    secondary: Colors.lightBlue,
    surface: Colors.white,
    onSurface: Colors.black87,
    background: Colors.white,
    onBackground: Colors.black87,
    error: Colors.redAccent,
    onError: Colors.white,
  ),
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white,
    titleTextStyle: TextStyle(
      color: Colors.blueAccent,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(color: Colors.blueAccent),
    actionsIconTheme: IconThemeData(color: Colors.blueAccent),
    elevation: 0,
  ),
  textTheme: _buildCliTextTheme(Colors.blueAccent),
  inputDecorationTheme: InputDecorationTheme(
    border: InputBorder.none,
    enabledBorder: InputBorder.none,
    focusedBorder: InputBorder.none,
    labelStyle: TextStyle(color: Colors.blueAccent),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blueAccent,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      elevation: 0,
    ),
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: Colors.blueAccent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.zero,
    ),
  ),
  iconTheme: IconThemeData(color: Colors.blueAccent),
  visualDensity: VisualDensity.compact,
  useMaterial3: true,
);

TextTheme _buildCliTextTheme(Color color) {
  return TextTheme(
    displayLarge:
        TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.bold),
    displayMedium:
        TextStyle(color: color, fontSize: 22, fontWeight: FontWeight.bold),
    displaySmall:
        TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold),
    headlineLarge:
        TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.bold),
    headlineMedium:
        TextStyle(color: color, fontSize: 22, fontWeight: FontWeight.bold),
    headlineSmall:
        TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold),
    titleLarge:
        TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold),
    titleMedium:
        TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold),
    titleSmall:
        TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.bold),
    bodyLarge: TextStyle(color: color, fontSize: 16),
    bodyMedium: TextStyle(color: color, fontSize: 14),
    bodySmall: TextStyle(color: color, fontSize: 12),
    labelLarge: TextStyle(color: color, fontSize: 14),
    labelMedium: TextStyle(color: color, fontSize: 12),
    labelSmall: TextStyle(color: color, fontSize: 10),
  );
}

// Define the cheerful themes
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

final ThemeData cheerfulLightTheme = ThemeData(
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: Colors.blue,
    accentColor: Colors.blueAccent,
    brightness: Brightness.light,
    backgroundColor: Colors.white,
  ).copyWith(
    surface: Colors.white,
  ),
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.blue[700],
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(color: Colors.white),
    actionsIconTheme: IconThemeData(color: Colors.white),
  ),
  textTheme: _buildTextTheme(Colors.black),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blue),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blue[700]!),
    ),
    labelStyle: TextStyle(color: Colors.blue),
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

// Define the minimalistic CLI themes
final ThemeData minimalisticDarkTheme = ThemeData(
  colorScheme: ColorScheme.dark(
    primary: Colors.greenAccent,
    secondary: Colors.lightGreen,
    surface: Colors.black,
    onSurface: Colors.white70,
  ),
  scaffoldBackgroundColor: Colors.black,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.black,
    titleTextStyle: TextStyle(
      color: Colors.greenAccent,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(color: Colors.greenAccent),
    actionsIconTheme: IconThemeData(color: Colors.greenAccent),
  ),
  textTheme: _buildMinimalisticTextTheme(Colors.greenAccent),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.greenAccent),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.lightGreen),
    ),
    labelStyle: TextStyle(color: Colors.greenAccent),
  ),
);

final ThemeData minimalisticLightTheme = ThemeData(
  colorScheme: ColorScheme.light(
    primary: Colors.blueAccent,
    secondary: Colors.lightBlue,
    background: Colors.white,
    surface: Colors.white,
    onBackground: Colors.black87,
    onSurface: Colors.black87,
  ),
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white,
    titleTextStyle: TextStyle(
      color: Colors.blueAccent,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(color: Colors.blueAccent),
    actionsIconTheme: IconThemeData(color: Colors.blueAccent),
  ),
  textTheme: _buildMinimalisticTextTheme(Colors.blueAccent),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blueAccent),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.lightBlue),
    ),
    labelStyle: TextStyle(color: Colors.blueAccent),
  ),
);

TextTheme _buildMinimalisticTextTheme(Color color) {
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

final Map<String, Map<String, ThemeData>> themes = {
  'light': {
    'Cheerful': cheerfulLightTheme,
    'Minimalistic': minimalisticLightTheme,
    'CLI': cliLightTheme,
  },
  'dark': {
    'Cheerful': cheerfulDarkTheme,
    'Minimalistic': minimalisticDarkTheme,
    'CLI': cliDarkTheme,
  },
};
