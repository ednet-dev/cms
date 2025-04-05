import 'package:flutter/material.dart';

/// Theme constants for EDNet One application
///
/// This file contains all theme-related constants that are used
/// throughout the application for consistent styling.

// Color constants
class ThemeColors {
  // Light mode colors
  static const Color lightPrimary = Colors.blueAccent;
  static const Color lightSecondary = Colors.lightBlue;
  static const Color lightBackground = Colors.white;
  static const Color lightSurface = Colors.white;
  static const Color lightOnBackground = Colors.black87;
  static const Color lightOnSurface = Colors.black87;
  static const Color lightError = Colors.redAccent;
  static const Color lightOnError = Colors.white;

  // Dark mode colors
  static const Color darkPrimary = Colors.greenAccent;
  static const Color darkSecondary = Colors.lightGreen;
  static const Color darkBackground = Colors.black;
  static const Color darkSurface = Colors.black;
  static const Color darkOnBackground = Colors.white70;
  static const Color darkOnSurface = Colors.white70;
  static const Color darkError = Colors.redAccent;
  static const Color darkOnError = Colors.black;

  // Cheerful theme colors
  static Color cheerfulDarkAccent = Colors.orange;
  static Color cheerfulDarkBackground = Colors.grey[850]!;
  static Color cheerfulLightAccent = Colors.blueAccent;
}

// Text style constants
class ThemeTextStyles {
  static TextStyle buildCliTextStyle(
    Color color,
    double fontSize, {
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return TextStyle(color: color, fontSize: fontSize, fontWeight: fontWeight);
  }
}

// Theme names
class ThemeNames {
  static const String cheerful = 'Cheerful';
  static const String minimalistic = 'Minimalistic';
  static const String cli = 'CLI';
}

// Theme modes
class ThemeModes {
  static const String light = 'light';
  static const String dark = 'dark';
}
