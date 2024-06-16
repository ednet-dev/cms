import 'dart:ui';

abstract class Component {
  void update(double dt);

  void render(Canvas canvas);
}
