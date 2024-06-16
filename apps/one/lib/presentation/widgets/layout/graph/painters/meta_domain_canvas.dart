import 'package:ednet_core/ednet_core.dart';
import 'package:flutter/material.dart';

import '../algorithms/circular_layout_algorithm.dart';
import '../algorithms/force_directed_layout_algorithm.dart';
import '../algorithms/grid_layout_algorithm.dart';
import '../algorithms/master_detail_layout_algorithm.dart';
import '../algorithms/ranked_embedding_layout_algorithm.dart';
import '../animations/animation_manager.dart';
import '../animations/game_loop.dart';
import '../components/layout_algorithm_icon.dart';
import '../components/system.dart';
import '../decorators/u_x_decorator.dart';
import '../layout/layout_algorithm.dart';
import 'meta_domain_painter.dart';

class MetaDomainCanvas extends StatefulWidget {
  final Domains domains;
  final LayoutAlgorithm layoutAlgorithm;
  final List<UXDecorator> decorators;

  const MetaDomainCanvas({
    super.key,
    required this.domains,
    required this.layoutAlgorithm,
    required this.decorators,
  });

  @override
  MetaDomainCanvasStateState createState() => MetaDomainCanvasStateState();
}

class MetaDomainCanvasStateState extends State<MetaDomainCanvas> {
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

  void _changeLayoutAlgorithm(LayoutAlgorithm algorithm) {
    setState(() {
      _currentAlgorithm = algorithm;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LayoutAlgorithmIcon(
                icon: Icons.auto_fix_high,
                name: 'Force Directed',
                onTap: () =>
                    _changeLayoutAlgorithm(ForceDirectedLayoutAlgorithm()),
              ),
              LayoutAlgorithmIcon(
                icon: Icons.grid_on,
                name: 'Grid',
                onTap: () => _changeLayoutAlgorithm(GridLayoutAlgorithm()),
              ),
              LayoutAlgorithmIcon(
                icon: Icons.circle,
                name: 'Circular',
                onTap: () => _changeLayoutAlgorithm(CircularLayoutAlgorithm()),
              ),
              LayoutAlgorithmIcon(
                icon: Icons.format_indent_increase,
                name: 'Master Detail',
                onTap: () =>
                    _changeLayoutAlgorithm(MasterDetailLayoutAlgorithm()),
              ),
              LayoutAlgorithmIcon(
                icon: Icons.account_tree,
                name: 'Ranked Tree',
                onTap: () =>
                    _changeLayoutAlgorithm(RankedEmbeddingLayoutAlgorithm()),
              ),
            ],
          ),
          Expanded(
            child: GestureDetector(
              onScaleStart: _onInteractionStart,
              onScaleEnd: _onInteractionEnd,
              child: InteractiveViewer(
                transformationController: _transformationController,
                onInteractionUpdate: (details) {
                  setState(() {
                    _transformationController.value =
                        _transformationController.value
                          ..translate(details.focalPointDelta.dx,
                              details.focalPointDelta.dy)
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
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _gameLoop.stop();
    super.dispose();
  }
}
