import 'package:ednet_one/presentation/widgets/layout/graph/animation.dart';
import 'package:ednet_one/presentation/widgets/layout/graph/meta_domain_canvas.dart';

class AnimationManager {
  final List<Animation> animations = [];

  void addAnimation(Animation animation) {
    animations.add(animation);
  }

  void update(double dt) {
    for (var animation in List.from(animations)) {
      animation.update(dt);
      if (animation.elapsedTime >= animation.duration) {
        animations.remove(animation);
      }
    }
  }
}
