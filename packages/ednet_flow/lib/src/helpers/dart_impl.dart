// This file is part of the EDNetFlow library.
// File updated with proper imports by update_imports.dart script.

part of ednet_flow;









class Offset {
  final double dx;
  final double dy;

  const Offset(this.dx, this.dy);

  static const Offset zero = Offset(0, 0);

  double get distance => sqrt(dx * dx + dy * dy);

  /// Creates an offset from a direction and distance
  static Offset fromDirection(double direction, double distance) {
    return Offset(cos(direction) * distance, sin(direction) * distance);
  }

  /// Returns a normalized version of this offset (distance of 1)
  Offset normalized() {
    final d = distance;
    if (d == 0.0) return zero;
    return this / d;
  }

  Offset operator -(Offset other) => Offset(dx - other.dx, dy - other.dy);
  Offset operator +(Offset other) => Offset(dx + other.dx, dy + other.dy);
  Offset operator *(double operand) => Offset(dx * operand, dy * operand);
  Offset operator /(double operand) => Offset(dx / operand, dy / operand);
}

class Size {
  final double width;
  final double height;

  const Size(this.width, this.height);
}

class Color {
  final int value;

  const Color(this.value);

  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);

  Color withOpacity(double opacity) => this;
}

class Colors {
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black54 = Color(0x8A000000);
  static const Color black45 = Color(0x73000000);
  static const Color black26 = Color(0x42000000);
  static const Color black12 = Color(0x1F000000);

  static ColorSwatch<int> get blue => _makeColorSwatch(0xFF2196F3);
  static ColorSwatch<int> get green => _makeColorSwatch(0xFF4CAF50);
  static ColorSwatch<int> get red => _makeColorSwatch(0xFFF44336);
  static ColorSwatch<int> get yellow => _makeColorSwatch(0xFFFFEB3B);
  static ColorSwatch<int> get orange => _makeColorSwatch(0xFFFF9800);
  static ColorSwatch<int> get purple => _makeColorSwatch(0xFF9C27B0);
  static ColorSwatch<int> get grey => _makeColorSwatch(0xFF9E9E9E);
  static ColorSwatch<int> get amber => _makeColorSwatch(0xFFFFC107);
}

class ColorSwatch<T extends num> extends Color {
  const ColorSwatch(super.value);

  Color operator [](T index) => Color(value);
  Color get shade50 => Color(value - 0x50000000);
  Color get shade100 => Color(value - 0x30000000);
  Color get shade200 => Color(value - 0x10000000);
}

ColorSwatch<int> _makeColorSwatch(int primary) {
  return ColorSwatch<int>(primary);
}

enum PaintingStyle { fill, stroke }

class Paint {
  Color color = const Color(0xFF000000);
  PaintingStyle style = PaintingStyle.fill;
  double strokeWidth = 1.0;
}

class Canvas {
  void drawLine(Offset p1, Offset p2, Paint paint) {}
  void drawRect(Rect rect, Paint paint) {}
  void drawRRect(RRect rrect, Paint paint) {}
  void drawPath(Path path, Paint paint) {}
  void drawCircle(Offset center, double radius, Paint paint) {}
  void clipRect(Rect rect, {bool doAntiAlias = true}) {}
  void clipPath(Path path, {bool doAntiAlias = true}) {}
  void save() {}
  void restore() {}
  void translate(double dx, double dy) {}
  void rotate(double radians) {}
  void scale(double sx, [double? sy]) {}
}

class Path {
  void moveTo(double x, double y) {}
  void lineTo(double x, double y) {}
  void close() {}
}

class Rect {
  final double left;
  final double top;
  final double right;
  final double bottom;

  const Rect.fromLTRB(this.left, this.top, this.right, this.bottom);

  factory Rect.fromCenter({
    required Offset center,
    required double width,
    required double height,
  }) {
    return Rect.fromLTRB(
      center.dx - width / 2,
      center.dy - height / 2,
      center.dx + width / 2,
      center.dy + height / 2,
    );
  }
}

class RRect {
  const RRect._();

  factory RRect.fromRectAndRadius(Rect rect, Radius radius) {
    return const RRect._();
  }
}

class Radius {
  final double x;
  final double y;

  const Radius.circular(double radius) : x = radius, y = radius;
}

class TextStyle {
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final TextDecoration? decoration;
  final Color? backgroundColor;

  const TextStyle({
    this.color,
    this.fontSize,
    this.fontWeight,
    this.fontStyle,
    this.decoration,
    this.backgroundColor,
  });
}

class FontWeight {
  final int value;

  const FontWeight(this.value);

  static const FontWeight bold = FontWeight(700);
  static const FontWeight normal = FontWeight(400);
  static const FontWeight w300 = FontWeight(300);
  static const FontWeight w500 = FontWeight(500);
}

enum FontStyle { normal, italic }

class TextDecoration {
  final int value;

  const TextDecoration(this.value);

  static const TextDecoration none = TextDecoration(0);
  static const TextDecoration underline = TextDecoration(1);
}

enum TextAlign { left, right, center, justify }

enum TextDirection { ltr, rtl }

enum TextOverflow { clip, ellipsis, fade, visible }

class EdgeInsets {
  final double left;
  final double top;
  final double right;
  final double bottom;

  const EdgeInsets.all(double value)
    : left = value,
      top = value,
      right = value,
      bottom = value;

  const EdgeInsets.only({
    this.left = 0,
    this.top = 0,
    this.right = 0,
    this.bottom = 0,
  });
}
