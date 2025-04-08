import 'dart:async';
import 'dart:ui';

import '../components/system.dart';
import 'animation_manager.dart';

class GameLoop {
  final System system;
  final AnimationManager animationManager;
  final double updateInterval;
  late Timer _timer;

  GameLoop({
    required this.system,
    required this.animationManager,
    this.updateInterval = 1 / 60, // 60 FPS
  });

  void start() {
    _timer = Timer.periodic(
      Duration(milliseconds: (updateInterval * 1000).round()),
      _update,
    );
  }

  void _update(Timer timer) {
    double dt = updateInterval;
    animationManager.update(dt);
    system.update(dt);
    system.render(
      Canvas(PictureRecorder()),
    ); // Replace with your rendering logic
  }

  void stop() {
    _timer.cancel();
  }
}
