class Animation {
  final double duration;
  double elapsedTime = 0;
  final void Function(double progress) onUpdate;
  final void Function() onComplete;

  Animation({
    required this.duration,
    required this.onUpdate,
    required this.onComplete,
  });

  void update(double dt) {
    elapsedTime += dt;
    double progress = (elapsedTime / duration).clamp(0.0, 1.0);
    onUpdate(progress);
    if (elapsedTime >= duration) {
      onComplete();
    }
  }
}
