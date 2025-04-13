  return Color.fromARGB(
    255,
    (color.r * (1 - t) + targetColor.r * t).round(),
    (color.g * (1 - t) + targetColor.g * t).round(),
    (color.b * (1 - t) + targetColor.b * t).round(),
  );
}

Color withOpacity(double opacity) {
  return color.withValues(alpha: opacity);
}

final brightness = (299 * background.r +
    587 * background.g +
    114 * background.b) /
    1000;

backgroundColor: Colors.black.withValues(alpha: (0.5 * 255).round()), 