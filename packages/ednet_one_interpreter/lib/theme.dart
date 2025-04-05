import 'package:flutter/material.dart';

/// A map of theme names to theme data for both light and dark modes.
final themes = {
  'light': {
    'Default': ThemeData.light().copyWith(
      primaryColor: Colors.blue,
      colorScheme: ColorScheme.light(
        primary: Colors.blue,
        secondary: Colors.blueAccent,
        background: Colors.grey[50]!,
        onBackground: Colors.black87,
      ),
    ),
    'Orange': ThemeData.light().copyWith(
      primaryColor: Colors.orange,
      colorScheme: ColorScheme.light(
        primary: Colors.orange,
        secondary: Colors.orangeAccent,
        tertiary: Colors.deepOrange,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      cardTheme: CardTheme(
        color: Colors.grey[50],
        shadowColor: Colors.orange.withOpacity(0.2),
      ),
      tabBarTheme: TabBarTheme(
        labelColor: Colors.orange,
        unselectedLabelColor: Colors.grey,
      ),
    ),
    'Green': ThemeData.light().copyWith(
      primaryColor: Colors.green,
      colorScheme: ColorScheme.light(
        primary: Colors.green,
        secondary: Colors.lightGreen,
        tertiary: Colors.teal,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      cardTheme: CardTheme(
        color: Colors.grey[50],
        shadowColor: Colors.green.withOpacity(0.2),
      ),
      tabBarTheme: TabBarTheme(
        labelColor: Colors.green,
        unselectedLabelColor: Colors.grey,
      ),
    ),
    'Purple': ThemeData.light().copyWith(
      primaryColor: Colors.purple,
      colorScheme: ColorScheme.light(
        primary: Colors.purple,
        secondary: Colors.purpleAccent,
        tertiary: Colors.deepPurple,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      cardTheme: CardTheme(
        color: Colors.grey[50],
        shadowColor: Colors.purple.withOpacity(0.2),
      ),
      tabBarTheme: TabBarTheme(
        labelColor: Colors.purple,
        unselectedLabelColor: Colors.grey,
      ),
    ),
  },
  'dark': {
    'Default': ThemeData.dark().copyWith(
      primaryColor: Colors.blue,
      colorScheme: ColorScheme.dark(
        primary: Colors.blue,
        secondary: Colors.lightBlue,
        background: Colors.grey[900]!,
        onBackground: Colors.white,
      ),
    ),
    'Orange': ThemeData.dark().copyWith(
      primaryColor: Colors.orange,
      colorScheme: ColorScheme.dark(
        primary: Colors.orange,
        secondary: Colors.amber,
        tertiary: Colors.deepOrange,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.orange,
      ),
      cardTheme: CardTheme(
        color: Colors.grey[850],
        shadowColor: Colors.orange.withOpacity(0.2),
      ),
      tabBarTheme: TabBarTheme(
        labelColor: Colors.orange,
        unselectedLabelColor: Colors.grey,
      ),
    ),
    'Green': ThemeData.dark().copyWith(
      primaryColor: Colors.green,
      colorScheme: ColorScheme.dark(
        primary: Colors.green,
        secondary: Colors.lightGreen,
        tertiary: Colors.teal,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.green,
      ),
      cardTheme: CardTheme(
        color: Colors.grey[850],
        shadowColor: Colors.green.withOpacity(0.2),
      ),
      tabBarTheme: TabBarTheme(
        labelColor: Colors.green,
        unselectedLabelColor: Colors.grey,
      ),
    ),
    'Purple': ThemeData.dark().copyWith(
      primaryColor: Colors.purple,
      colorScheme: ColorScheme.dark(
        primary: Colors.purple,
        secondary: Colors.purpleAccent,
        tertiary: Colors.deepPurple,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.purple,
      ),
      cardTheme: CardTheme(
        color: Colors.grey[850],
        shadowColor: Colors.purple.withOpacity(0.2),
      ),
      tabBarTheme: TabBarTheme(
        labelColor: Colors.purple,
        unselectedLabelColor: Colors.grey,
      ),
    ),
    // Theme optimized for domain model visualization
    'Domain Viz': ThemeData.dark().copyWith(
      primaryColor: const Color(0xFF33658A),
      scaffoldBackgroundColor: const Color(0xFF13151F),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF33658A),
        secondary: Color(0xFF79A9D1),
        tertiary: Color(0xFF55DDE0),
        surface: Color(0xFF232638),
        background: Color(0xFF13151F),
        onBackground: Color(0xFFEEF2F7),
        onSurface: Color(0xFFEEF2F7),
      ),
      cardTheme: const CardTheme(color: Color(0xFF232638), elevation: 4),
      listTileTheme: const ListTileThemeData(
        selectedColor: Color(0xFF55DDE0),
        selectedTileColor: Color(0xFF33658A),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFF344055),
        thickness: 1,
      ),
      tabBarTheme: const TabBarTheme(
        labelColor: Color(0xFF55DDE0),
        unselectedLabelColor: Color(0xFF79A9D1),
        indicatorColor: Color(0xFF55DDE0),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF232638),
        foregroundColor: Color(0xFFEEF2F7),
      ),
    ),
  },
};
