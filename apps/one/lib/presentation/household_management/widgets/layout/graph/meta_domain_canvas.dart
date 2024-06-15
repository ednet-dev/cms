import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:ednet_core/ednet_core.dart';
import 'package:flutter/material.dart';

class MetaDomainPainter extends CustomPainter {
  final Domains domains;
  final TransformationController transformationController;
  final LayoutAlgorithm layoutAlgorithm;
  final List<UXDecorator> decorators;
  final bool isDragging;
  final System system;
  final AnimationManager animationManager;

  MetaDomainPainter({
    required this.domains,
    required this.transformationController,
    required this.layoutAlgorithm,
    required this.decorators,
    required this.isDragging,
    required this.system,
    required this.animationManager,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final positions = layoutAlgorithm.calculateLayout(domains, size);

    system.nodes.clear();

    for (var domain in domains) {
      Offset domainPosition = positions[domain.code]!;
      Node domainNode = Node();
      domainNode.addComponent(PositionComponent(domainPosition));
      domainNode.addComponent(RenderComponent(
        Paint()..color = Colors.blue,
        Rect.fromCenter(center: domainPosition, width: 100, height: 50),
      ));
      system.addNode(domainNode);

      for (var model in domain.models) {
        Offset modelPosition = positions[model.code]!;
        Node modelNode = Node();
        modelNode.addComponent(PositionComponent(modelPosition));
        modelNode.addComponent(RenderComponent(
          Paint()..color = Colors.green,
          Rect.fromCenter(center: modelPosition, width: 100, height: 50),
        ));
        system.addNode(modelNode);

        for (var entity in model.concepts) {
          Offset entityPosition = positions[entity.code]!;
          Node entityNode = Node();
          entityNode.addComponent(PositionComponent(entityPosition));
          entityNode.addComponent(RenderComponent(
            Paint()..color = Colors.red,
            Rect.fromCenter(center: entityPosition, width: 100, height: 50),
          ));
          system.addNode(entityNode);

          for (var child in entity.children) {
            Offset childPosition = positions[child.code]!;
            Node childNode = Node();
            childNode.addComponent(PositionComponent(childPosition));
            childNode.addComponent(RenderComponent(
              Paint()..color = Colors.red,
              Rect.fromCenter(center: childPosition, width: 100, height: 50),
            ));
            system.addNode(childNode);

            canvas.drawLine(
              entityPosition,
              childPosition,
              Paint()..color = Colors.black,
            );
          }
        }
      }
    }

    system.render(canvas);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

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
        Duration(milliseconds: (updateInterval * 1000).round()), _update);
  }

  void _update(Timer timer) {
    double dt = updateInterval;
    animationManager.update(dt);
    system.update(dt);
    system
        .render(Canvas(PictureRecorder())); // Replace with your rendering logic
  }

  void stop() {
    _timer.cancel();
  }
}

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

abstract class Component {
  void update(double dt);

  void render(Canvas canvas);
}

class PositionComponent extends Component {
  Offset position;

  PositionComponent(this.position);

  @override
  void update(double dt) {
    // Update logic for position
  }

  @override
  void render(Canvas canvas) {
    // Render logic for position (e.g., drawing a marker)
  }
}

class RenderComponent extends Component {
  final Paint paint;
  final Rect rect;

  RenderComponent(this.paint, this.rect);

  @override
  void update(double dt) {
    // Update logic for rendering
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(rect, paint);
  }
}

class Node {
  final List<Component> components = [];

  void addComponent(Component component) {
    components.add(component);
  }

  void update(double dt) {
    for (var component in components) {
      component.update(dt);
    }
  }

  void render(Canvas canvas) {
    for (var component in components) {
      component.render(canvas);
    }
  }
}

class System {
  final List<Node> nodes = [];

  void addNode(Node node) {
    nodes.add(node);
  }

  void update(double dt) {
    for (var node in nodes) {
      node.update(dt);
    }
  }

  void render(Canvas canvas) {
    for (var node in nodes) {
      node.render(canvas);
    }
  }
}

class MetaDomainCanvas extends StatefulWidget {
  final Domains domains;
  final LayoutAlgorithm layoutAlgorithm;
  final List<UXDecorator> decorators;

  MetaDomainCanvas({
    required this.domains,
    required this.layoutAlgorithm,
    required this.decorators,
  });

  @override
  _MetaDomainCanvasState createState() => _MetaDomainCanvasState();
}

class _MetaDomainCanvasState extends State<MetaDomainCanvas> {
  late TransformationController _transformationController;
  late LayoutAlgorithm _currentAlgorithm;
  bool _isDragging = false;
  late GameLoop _gameLoop;
  late System _system;
  late AnimationManager _animationManager;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
    _currentAlgorithm = widget.layoutAlgorithm;
    _system = System();
    _animationManager = AnimationManager();
    _gameLoop = GameLoop(
      system: _system,
      animationManager: _animationManager,
    );
    _gameLoop.start();
  }

  void _onInteractionStart(ScaleStartDetails details) {
    setState(() {
      _isDragging = true;
    });
  }

  void _onInteractionEnd(ScaleEndDetails details) {
    setState(() {
      _isDragging = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: _onInteractionStart,
      onScaleEnd: _onInteractionEnd,
      child: InteractiveViewer(
        transformationController: _transformationController,
        onInteractionUpdate: (details) {
          setState(() {
            _transformationController.value = _transformationController.value
              ..translate(
                  details.focalPointDelta.dx, details.focalPointDelta.dy)
              ..scale(details.scale);
          });
        },
        minScale: 0.1,
        maxScale: 5.0,
        child: CustomPaint(
          size: Size.infinite,
          painter: MetaDomainPainter(
            domains: widget.domains,
            transformationController: _transformationController,
            layoutAlgorithm: _currentAlgorithm,
            decorators: widget.decorators,
            isDragging: _isDragging,
            system: _system,
            animationManager: _animationManager,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _gameLoop.stop();
    super.dispose();
  }
}

enum NodeType {
  domain,
  model,
  entity,
}

abstract class LayoutAlgorithm {
  Map<String, Offset> calculateLayout(Domains domains, Size size);
}

class ForceDirectedLayoutAlgorithm extends LayoutAlgorithm {
  final Map<String, Offset> velocity = {};

  @override
  Map<String, Offset> calculateLayout(Domains domains, Size size) {
    final positions = <String, Offset>{};
    final forces = <String, Offset>{};

    final random = Random();
    const int iterations = 1000;
    const double repulsionForce = 10000.0;
    const double springForce = 0.1;

    for (var domain in domains) {
      positions[domain.code] = Offset(
          random.nextDouble() * size.width, random.nextDouble() * size.height);

      for (var model in domain.models) {
        positions[model.code] = Offset(random.nextDouble() * size.width,
            random.nextDouble() * size.height);

        for (var entity in model.concepts) {
          positions[entity.code] = Offset(random.nextDouble() * size.width,
              random.nextDouble() * size.height);

          for (var child in entity.children) {
            positions[child.code] = Offset(random.nextDouble() * size.width,
                random.nextDouble() * size.height);
          }
        }
      }
    }

    for (var i = 0; i < iterations; i++) {
      for (var entry in positions.entries) {
        final position = entry.value;
        var force = Offset.zero;

        for (var otherEntry in positions.entries) {
          if (entry.key == otherEntry.key) continue;

          final direction = position - otherEntry.value;
          final distance = max(direction.distance, 1.0);
          final repulsion =
              direction / distance * repulsionForce / (distance * distance);

          force += repulsion;
        }

        forces[entry.key] = force;
      }

      for (var entry in positions.entries) {
        final force = forces[entry.key]!;
        final velocity =
            (this.velocity[entry.key] ?? Offset.zero) + force * springForce;

        positions[entry.key] = entry.value + velocity;
        this.velocity[entry.key] = velocity * 0.95;
      }
    }

    return positions;
  }
}

class GridLayoutAlgorithm extends LayoutAlgorithm {
  @override
  Map<String, Offset> calculateLayout(Domains domains, Size size) {
    final positions = <String, Offset>{};

    double x = 50;
    double y = 50;
    const double stepX = 200;
    const double stepY = 100;

    for (var domain in domains) {
      positions[domain.code] = Offset(x, y);
      y += stepY;

      for (var model in domain.models) {
        positions[model.code] = Offset(x + stepX, y);
        y += stepY;

        for (var entity in model.concepts) {
          positions[entity.code] = Offset(x + 2 * stepX, y);
          y += stepY;
        }

        y += stepY;
      }

      x += 3 * stepX;
      y = 50;
    }

    return positions;
  }
}

abstract class UXDecorator {
  void apply(Canvas canvas, Offset position, double scale);
}

class HighlightDecorator implements UXDecorator {
  final Color color;
  final double thickness;

  HighlightDecorator({required this.color, this.thickness = 2.0});

  @override
  void apply(Canvas canvas, Offset position, double scale) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness / scale;
    final rect = Rect.fromCenter(
        center: position, width: 110 / scale, height: 60 / scale);
    canvas.drawRect(rect, paint);
  }
}

class TooltipDecorator implements UXDecorator {
  final String tooltip;
  final TextStyle textStyle;

  TooltipDecorator({required this.tooltip, required this.textStyle});

  @override
  void apply(Canvas canvas, Offset position, double scale) {
    final textSpan = TextSpan(text: tooltip, style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, position + Offset(0, -50 / scale));
  }
}

class CircularLayoutAlgorithm extends LayoutAlgorithm {
  final double rootRadius;
  final double levelDistance;
  final double nodeSize;

  CircularLayoutAlgorithm({
    this.rootRadius = 100.0,
    this.levelDistance = 150.0,
    this.nodeSize = 50.0,
  });

  @override
  Map<String, Offset> calculateLayout(Domains domains, Size size) {
    final positions = <String, Offset>{};
    final center = Offset(size.width / 2, size.height / 2);

    // Position roots in a circle
    final rootCount = domains.length;
    final rootAngleStep = 2 * pi / rootCount;
    for (int i = 0; i < rootCount; i++) {
      final domain = domains.elementAt(i);
      final angle = i * rootAngleStep;
      final rootPosition =
          center + Offset(rootRadius * cos(angle), rootRadius * sin(angle));
      positions[domain.code] = rootPosition;

      // Position children recursively
      _positionChildren(
          domain, rootPosition, positions, 1, angle, rootAngleStep / 2);
    }

    return positions;
  }

  void _positionChildren(
      Entity parent,
      Offset parentPosition,
      Map<String, Offset> positions,
      int level,
      double angle,
      double angleRange) {
    final children = parent.concept.children;
    if (children.isEmpty) return;

    final angleStep = angleRange / children.length;
    for (int i = 0; i < children.length; i++) {
      final child = children.elementAt(i);
      final childAngle = angle - angleRange / 2 + i * angleStep + angleStep / 2;
      final childPosition = parentPosition +
          Offset(
              levelDistance * cos(childAngle), levelDistance * sin(childAngle));
      positions[child.code] = childPosition;

      _positionChildren(child, childPosition, positions, level + 1, childAngle,
          angleStep / 2);
    }
  }
}

class MasterDetailLayoutAlgorithm extends LayoutAlgorithm {
  final double nodeWidth;
  final double nodeHeight;
  final double levelGap;

  MasterDetailLayoutAlgorithm({
    this.nodeWidth = 200.0,
    this.nodeHeight = 100.0,
    this.levelGap = 50.0,
  });

  @override
  Map<String, Offset> calculateLayout(Domains domains, Size size) {
    final positions = <String, Offset>{};
    double currentX = levelGap;
    double currentY = levelGap;

    for (var domain in domains) {
      positions[domain.code] = Offset(currentX, currentY);

      for (var model in domain.models) {
        currentY += nodeHeight + levelGap;
        positions[model.code] = Offset(currentX, currentY);

        for (var entity in model.concepts) {
          currentY += nodeHeight + levelGap;
          positions[entity.code] =
              Offset(currentX + nodeWidth + levelGap, currentY);

          for (var child in entity.children) {
            currentY += nodeHeight + levelGap;
            positions[child.code] =
                Offset(currentX + 2 * (nodeWidth + levelGap), currentY);
          }
        }
      }
      currentX += 3 * (nodeWidth + levelGap);
      currentY = levelGap;
    }

    return positions;
  }
}
