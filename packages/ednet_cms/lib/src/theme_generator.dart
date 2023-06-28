import 'package:flutter/material.dart';

enum Culture {
  Western,
  Eastern,
  // Add more cultures as needed
}

class ThemeGenerator {
  final Culture culture;
  final Color baseColor;

  ThemeGenerator({required this.culture, required this.baseColor});

  Color calculateComplementary(Color color) {
    HSLColor hslColor = HSLColor.fromColor(color);
    double oppositeHue = (hslColor.hue + 180.0) % 360.0;
    return HSLColor.fromAHSL(hslColor.alpha, oppositeHue, hslColor.saturation, hslColor.lightness).toColor();
  }

  List<Color> calculateAnalogous(Color color) {
    HSLColor hslColor = HSLColor.fromColor(color);
    double previousHue = (hslColor.hue - 30.0) % 360.0;
    double nextHue = (hslColor.hue + 30.0) % 360.0;
    return [
      HSLColor.fromAHSL(hslColor.alpha, previousHue, hslColor.saturation, hslColor.lightness).toColor(),
      color,
      HSLColor.fromAHSL(hslColor.alpha, nextHue, hslColor.saturation, hslColor.lightness).toColor(),
    ];
  }

  List<Color> calculateTriadic(Color color) {
    HSLColor hslColor = HSLColor.fromColor(color);
    double secondHue = (hslColor.hue + 120.0) % 360.0;
    double thirdHue = (hslColor.hue + 240.0) % 360.0;
    return [
      color,
      HSLColor.fromAHSL(hslColor.alpha, secondHue, hslColor.saturation, hslColor.lightness).toColor(),
      HSLColor.fromAHSL(hslColor.alpha, thirdHue, hslColor.saturation, hslColor.lightness).toColor(),
    ];
  }

  List<Color> calculateSplitComplementary(Color color) {
    HSLColor hslColor = HSLColor.fromColor(color);
    double secondHue = (hslColor.hue + 150.0) % 360.0;
    double thirdHue = (hslColor.hue + 210.0) % 360.0;
    return [
      color,
      HSLColor.fromAHSL(hslColor.alpha, secondHue, hslColor.saturation, hslColor.lightness).toColor(),
      HSLColor.fromAHSL(hslColor.alpha, thirdHue, hslColor.saturation, hslColor.lightness).toColor(),
    ];
  }

  List<Color> calculateTetradic(Color color) {
    HSLColor hslColor = HSLColor.fromColor(color);
    double secondHue = (hslColor.hue + 90.0) % 360.0;
    double thirdHue = (hslColor.hue + 180.0) % 360.0;
    double fourthHue = (hslColor.hue + 270.0) % 360.0;
    return [
      color,
      HSLColor.fromAHSL(hslColor.alpha, secondHue, hslColor.saturation, hslColor.lightness).toColor(),
      HSLColor.from```dart
AHSL(hslColor.alpha, thirdHue, hslColor.saturation, hslColor.lightness).toColor(),
      HSLColor.fromAHSL(hslColor.alpha, fourthHue, hslColor.saturation, hslColor.lightness).toColor(),
    ];
  }

  List<Color> calculateSquare(Color color) {
    HSLColor hslColor = HSLColor.fromColor(color);
    double secondHue = (hslColor.hue + 90.0) % 360.0;
    double thirdHue = (hslColor.hue + 180.0) % 360.0;
    double fourthHue = (hslColor.hue + 270.0) % 360.0;
    return [
      color,
      HSLColor.fromAHSL(hslColor.alpha, secondHue, hslColor.saturation, hslColor.lightness).toColor(),
      HSLColor.fromAHSL(hslColor.alpha, thirdHue, hslColor.saturation, hslColor.lightness).toColor(),
      HSLColor.fromAHSL(hslColor.alpha, fourthHue, hslColor.saturation, hslColor.lightness).toColor(),
    ];
  }

  ThemeData generateTheme() {
    // Calculate color schemes
    Color complementaryColor = calculateComplementary(baseColor);
    List<Color> analogousColors = calculateAnalogous(baseColor);
    List<Color> triadicColors = calculateTriadic(baseColor);
    List<Color> splitComplementaryColors = calculateSplitComplementary(baseColor);
    List<Color> tetradicColors = calculateTetradic(baseColor);
    List<Color> squareColors = calculateSquare(baseColor);

    // Create ThemeData for light theme
    ThemeData lightThemeData = ThemeData(
      brightness: Brightness.light,
      primaryColor: baseColor,
      accentColor: complementaryColor,
      buttonColor: analogousColors[1],
      canvasColor: triadicColors[1],
      cardColor: splitComplementaryColors[1],
      dividerColor: tetradicColors[1],
      highlightColor: squareColors[1],
      // Assign other colors as needed
    );

    // Create ThemeData for dark theme
    ThemeData darkThemeData = ThemeData(
      brightness: Brightness.dark,
      primaryColor: baseColor,
      accentColor: complementaryColor,
      buttonColor: analogousColors[2],
      canvasColor: triadicColors[2],
      cardColor: splitComplementaryColors[2],
      dividerColor: tetradicColors[2],
      highlightColor: squareColors[2],
      // Assign other colors as needed
    );

    // Return light or dark theme based on the system setting
    return WidgetsBinding.instance!.window.platformBrightness == Brightness.dark ? darkThemeData : lightThemeData;
  }
}

void main() {
  ThemeGenerator themeGenerator = ThemeGenerator(culture: Culture.Western, baseColor: Colors.blue);
  ThemeData themeData = themeGenerator.generateTheme();

  runApp(MaterialApp(
    theme: themeData,
    home: Scaffold(
      appBar: AppBar(
        title: Text('Theme Generator'),
      ),
      body: Center(
        child: Text('Hello, world!'),
      ),
    ),
  ));
}
