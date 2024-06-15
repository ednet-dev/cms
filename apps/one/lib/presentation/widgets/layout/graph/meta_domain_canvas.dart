import 'dart:async';
import 'dart:collection';
import 'dart:math';
import 'dart:ui';

import 'package:ednet_core/ednet_core.dart';
import 'package:flutter/material.dart';

// Assume necessary packages and other classes are already imported

class MSTLayoutAlgorithm extends LayoutAlgorithm {
  @override
  Map<String, Offset> calculateLayout(Domains domains, Size size) {
    final positions = <String, Offset>{};
    final edges = <Edge>[];

    for (var domain in domains) {
      final domainPosition = Offset(size.width / 2, size.height / 2);
      positions[domain.code] = domainPosition;

      for (var model in domain.models) {
        final modelPosition = Offset(size.width * 0.25, size.height * 0.25);
        positions[model.code] = modelPosition;
        edges.add(Edge(
            domain.code, model.code, _distance(domainPosition, modelPosition)));

        for (var entity in model.concepts) {
          final entityPosition = Offset(size.width * 0.75, size.height * 0.75);
          positions[entity.code] = entityPosition;
          edges.add(Edge(model.code, entity.code,
              _distance(modelPosition, entityPosition)));

          for (var child in entity.children) {
            final childPosition = Offset(size.width * 0.5, size.height * 0.5);
            positions[child.code] = childPosition;
            edges.add(Edge(entity.code, child.code,
                _distance(entityPosition, childPosition)));
          }
        }
      }
    }

    final mst = _kruskalMST(edges, positions);
    return mst;
  }

  double _distance(Offset a, Offset b) {
    return (a - b).distance;
  }

  Map<String, Offset> _kruskalMST(
      List<Edge> edges, Map<String, Offset> positions) {
    edges.sort((a, b) => a.weight.compareTo(b.weight));
    final parent = <String, String>{};
    final rank = <String, int>{};

    String find(String u) {
      if (parent[u] != u) {
        parent[u] = find(parent[u]!);
      }
      return parent[u]!;
    }

    void union(String u, String v) {
      final rootU = find(u);
      final rootV = find(v);
      if (rootU != rootV) {
        if (rank[rootU]! > rank[rootV]!) {
          parent[rootV] = rootU;
        } else if (rank[rootU]! < rank[rootV]!) {
          parent[rootU] = rootV;
        } else {
          parent[rootV] = rootU;
          rank[rootU] = rank[rootU]! + 1;
        }
      }
    }

    for (var key in positions.keys) {
      parent[key] = key;
      rank[key] = 0;
    }

    final mst = <Edge>[];
    for (var edge in edges) {
      if (find(edge.u) != find(edge.v)) {
        mst.add(edge);
        union(edge.u, edge.v);
      }
    }

    final mstPositions = <String, Offset>{};
    for (var edge in mst) {
      mstPositions[edge.u] = positions[edge.u]!;
      mstPositions[edge.v] = positions[edge.v]!;
    }

    return mstPositions;
  }
}

class DijkstraLayoutAlgorithm extends LayoutAlgorithm {
  @override
  Map<String, Offset> calculateLayout(Domains domains, Size size) {
    final positions = <String, Offset>{};
    final graph = <String, Map<String, double>>{};

    for (var domain in domains) {
      positions[domain.code] = Offset(size.width / 2, size.height / 2);
      graph[domain.code] = {};

      for (var model in domain.models) {
        final modelPosition = Offset(size.width * 0.25, size.height * 0.25);
        positions[model.code] = modelPosition;
        graph[domain.code]![model.code] =
            _distance(positions[domain.code]!, modelPosition);

        for (var entity in model.concepts) {
          final entityPosition = Offset(size.width * 0.75, size.height * 0.75);
          positions[entity.code] = entityPosition;
          graph[model.code]![entity.code] =
              _distance(modelPosition, entityPosition);

          for (var child in entity.children) {
            final childPosition = Offset(size.width * 0.5, size.height * 0.5);
            positions[child.code] = childPosition;
            graph[entity.code]![child.code] =
                _distance(entityPosition, childPosition);
          }
        }
      }
    }

    final dijkstraPositions = _dijkstra(graph, domains.first.code, positions);
    return dijkstraPositions;
  }

  double _distance(Offset a, Offset b) {
    return (a - b).distance;
  }

  Map<String, Offset> _dijkstra(Map<String, Map<String, double>> graph,
      String start, Map<String, Offset> positions) {
    final distances = <String, double>{};
    final previous = <String, String?>{};
    final pq = SplayTreeMap<double, List<String>>();

    for (var node in graph.keys) {
      distances[node] = double.infinity;
      previous[node] = null;
      pq.putIfAbsent(double.infinity, () => []).add(node);
    }

    distances[start] = 0;
    pq.putIfAbsent(0, () => []).add(start);

    while (pq.isNotEmpty) {
      final u = pq[pq.firstKey()]!.removeAt(0);
      if (pq[pq.firstKey()]!.isEmpty) {
        pq.remove(pq.firstKey());
      }

      for (var neighbor in graph[u]!.keys) {
        final alt = distances[u]! + graph[u]![neighbor]!;
        if (alt < distances[neighbor]!) {
          pq[distances[neighbor]!]!.remove(neighbor);
          if (pq[distances[neighbor]!]!.isEmpty) {
            pq.remove(distances[neighbor]!);
          }
          distances[neighbor] = alt;
          previous[neighbor] = u;
          pq.putIfAbsent(alt, () => []).add(neighbor);
        }
      }
    }

    final dijkstraPositions = <String, Offset>{};
    for (var node in positions.keys) {
      dijkstraPositions[node] = positions[node]!;
    }

    return dijkstraPositions;
  }
}

class NetworkFlowLayoutAlgorithm extends LayoutAlgorithm {
  @override
  Map<String, Offset> calculateLayout(Domains domains, Size size) {
    final positions = <String, Offset>{};
    final graph = <String, Map<String, double>>{};

    for (var domain in domains) {
      positions[domain.code] = Offset(size.width / 2, size.height / 2);
      graph[domain.code] = {};

      for (var model in domain.models) {
        final modelPosition = Offset(size.width * 0.25, size.height * 0.25);
        positions[model.code] = modelPosition;
        graph[domain.code]![model.code] =
            _distance(positions[domain.code]!, modelPosition);

        for (var entity in model.concepts) {
          final entityPosition = Offset(size.width * 0.75, size.height * 0.75);
          positions[entity.code] = entityPosition;
          graph[model.code]![entity.code] =
              _distance(modelPosition, entityPosition);

          for (var child in entity.children) {
            final childPosition = Offset(size.width * 0.5, size.height * 0.5);
            positions[child.code] = childPosition;
            graph[entity.code]![child.code] =
                _distance(entityPosition, childPosition);
          }
        }
      }
    }

    final maxFlow = _edmondsKarp(graph, domains.first.code, domains.last.code);
    // You can use the maxFlow result to adjust positions if needed

    return positions;
  }

  double _distance(Offset a, Offset b) {
    return (a - b).distance;
  }

  double _edmondsKarp(
      Map<String, Map<String, double>> graph, String source, String sink) {
    final residualGraph = <String, Map<String, double>>{};
    for (var u in graph.keys) {
      residualGraph[u] = {};
      for (var v in graph[u]!.keys) {
        residualGraph[u]![v] = graph[u]![v]!;
      }
    }

    final parent = <String?, String?>{};
    double maxFlow = 0;

    bool bfs(String source, String sink) {
      final visited = <String>{};
      final queue = Queue<String>();
      queue.add(source);
      visited.add(source);
      parent[source] = null;

      while (queue.isNotEmpty) {
        final u = queue.removeFirst();
        for (var v in residualGraph[u]!.keys) {
          if (!visited.contains(v) && residualGraph[u]![v]! > 0) {
            queue.add(v);
            visited.add(v);
            parent[v] = u;
            if (v == sink) return true;
          }
        }
      }
      return false;
    }

    while (bfs(source, sink)) {
      double pathFlow = double.infinity;
      for (var v = sink; v != source; v = parent[v]!) {
        final u = parent[v]!;
        pathFlow = min(pathFlow, residualGraph[u]![v]!);
      }

      for (var v = sink; v != source; v = parent[v]!) {
        final u = parent[v]!;
        residualGraph[u]![v] = residualGraph[u]![v]! - pathFlow;
        residualGraph[v]!.putIfAbsent(u, () => 0);
        residualGraph[v]![u] = residualGraph[v]![u]! + pathFlow;
      }

      maxFlow += pathFlow;
    }

    return maxFlow;
  }
}

class Edge {
  final String u;
  final String v;
  final double weight;

  Edge(this.u, this.v, this.weight);
}

// Update the UI to include new layout algorithms
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

// Implement MetaDomainPainter and other required classes here

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
      _paintDomain(canvas, domain, positions);
    }

    system.render(canvas);
  }

  void _paintDomain(
      Canvas canvas, Domain domain, Map<String, Offset> positions) {
    Offset domainPosition = positions[domain.code]!;
    Node domainNode = _createNode(domainPosition, Colors.blue);
    system.addNode(domainNode);

    for (var model in domain.models) {
      Offset modelPosition = positions[model.code]!;
      Node modelNode = _createNode(modelPosition, Colors.green);
      system.addNode(modelNode);

      for (var entity in model.concepts) {
        Offset entityPosition = positions[entity.code]!;
        Node entityNode = _createNode(entityPosition, Colors.red);
        system.addNode(entityNode);

        for (var child in entity.children) {
          Offset childPosition = positions[child.code]!;
          Node childNode = _createNode(childPosition, Colors.red);
          system.addNode(childNode);

          _drawLine(canvas, entityPosition, childPosition);
        }
      }
    }
  }

  Node _createNode(Offset position, Color color) {
    Node node = Node();
    node.addComponent(PositionComponent(position));
    node.addComponent(RenderComponent(
      Paint()..color = color,
      Rect.fromCenter(center: position, width: 100, height: 50),
    ));
    return node;
  }

  void _drawLine(Canvas canvas, Offset start, Offset end) {
    canvas.drawLine(
      start,
      end,
      Paint()..color = Colors.black,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class RankedEmbeddingLayoutAlgorithm extends LayoutAlgorithm {
  final double nodeWidth = 100.0;
  final double nodeHeight = 50.0;
  final double verticalGap = 80.0;
  final double horizontalGap = 30.0;

  @override
  Map<String, Offset> calculateLayout(Domains domains, Size size) {
    final positions = <String, Offset>{};

    for (var domain in domains) {
      final root = TreeNode(domain.code, Offset(size.width / 2, verticalGap));
      positions[domain.code] = root.position;
      _calculatePositions(
          root, domain.models.toList(), 0, size.width, positions);
    }

    return positions;
  }

  void _calculatePositions(TreeNode parent, List<Entity> collection,
      double xMin, double xMax, Map<String, Offset> positions) {
    if (collection.isEmpty) return;

    final y = parent.position.dy + verticalGap;
    final width = (xMax - xMin) / max(1, collection.length);

    for (var i = 0; i < collection.length; i++) {
      final item = collection[i];
      final x = xMin + i * width + width / 2;
      final childNode = TreeNode(item.code, Offset(x, y));
      parent.children.add(childNode);
      positions[childNode.key] = childNode.position;
      _calculatePositions(childNode, item.concept.children.toList(),
          xMin + i * width, xMin + (i + 1) * width, positions);
    }
  }
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

// AVL Tree Node class
class TreeNode {
  String key;
  Offset position;
  TreeNode? left;
  TreeNode? right;
  int height;
  List<TreeNode> children;

  TreeNode(this.key, this.position)
      : height = 1,
        children = [];
}

// AVL Tree implementation for balanced search tree
class AVLTree {
  TreeNode? root;

  int height(TreeNode? node) {
    return node?.height ?? 0;
  }

  int max(int a, int b) {
    return (a > b) ? a : b;
  }

  TreeNode? rightRotate(TreeNode y) {
    if (y.left == null) return y; // Added null check
    TreeNode x = y.left!;
    TreeNode? T2 = x.right;

    x.right = y;
    y.left = T2;

    y.height = max(height(y.left), height(y.right)) + 1;
    x.height = max(height(x.left), height(x.right)) + 1;

    return x;
  }

  TreeNode? leftRotate(TreeNode x) {
    if (x.right == null) return x; // Added null check
    TreeNode y = x.right!;
    TreeNode? T2 = y.left;

    y.left = x;
    x.right = T2;

    x.height = max(height(x.left), height(x.right)) + 1;
    y.height = max(height(y.left), height(y.right)) + 1;

    return y;
  }

  int getBalance(TreeNode? node) {
    if (node == null) return 0;
    return height(node.left) - height(node.right);
  }

  TreeNode insert(TreeNode? node, String key, Offset position) {
    if (node == null) return TreeNode(key, position);

    if (key.compareTo(node.key) < 0) {
      node.left = insert(node.left, key, position);
    } else if (key.compareTo(node.key) > 0) {
      node.right = insert(node.right, key, position);
    } else {
      return node;
    }

    node.height = max(height(node.left), height(node.right)) + 1;

    int balance = getBalance(node);

    if (balance > 1 && key.compareTo(node.left!.key) < 0) {
      return rightRotate(node)!;
    }

    if (balance < -1 && key.compareTo(node.right!.key) > 0) {
      return leftRotate(node)!;
    }

    if (balance > 1 && key.compareTo(node.left!.key) > 0) {
      node.left = leftRotate(node.left!)!;
      return rightRotate(node)!;
    }

    if (balance < -1 && key.compareTo(node.right!.key) < 0) {
      node.right = rightRotate(node.right!)!;
      return leftRotate(node)!;
    }

    return node;
  }

  Offset? search(TreeNode? node, String key) {
    if (node == null) return null;

    if (key == node.key) return node.position;

    if (key.compareTo(node.key) < 0) {
      return search(node.left, key);
    } else {
      return search(node.right, key);
    }
  }

  void insertNode(String key, Offset position) {
    root = insert(root, key, position);
  }

  Offset? getNodePosition(String key) {
    return search(root, key);
  }
}

// Graph data structure using adjacency list
class Graph {
  Map<String, List<String>> adjacencyList = {};

  void addEdge(String u, String v) {
    adjacencyList.putIfAbsent(u, () => []).add(v);
    adjacencyList.putIfAbsent(v, () => []).add(u);
  }

  List<String>? getNeighbors(String u) {
    return adjacencyList[u];
  }
}

class LayoutAlgorithmIcon extends StatelessWidget {
  final IconData icon;
  final String name;
  final VoidCallback onTap;

  LayoutAlgorithmIcon({
    required this.icon,
    required this.name,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 40.0),
          Text(name, style: TextStyle(fontSize: 12.0)),
        ],
      ),
    );
  }
}

class ForceDirectedLayoutAlgorithm extends LayoutAlgorithm {
  final AVLTree avlTree = AVLTree();
  final Map<String, Offset> velocity = {};
  final double repulsionForce = 1000.0; // Adjusted repulsion force
  final double springForce = 0.1; // Spring force constant
  final int iterations = 1000; // Number of iterations for the algorithm
  final double damping =
      0.85; // Velocity damping factor to stabilize the layout

  @override
  Map<String, Offset> calculateLayout(Domains domains, Size size) {
    final forces = <String, Offset>{};

    final random = Random();
    _initializePositions(domains, size, random);

    for (var i = 0; i < iterations; i++) {
      _applyForces(forces);
      _updatePositions(forces);
    }

    return _getPositions();
  }

  void _initializePositions(Domains domains, Size size, Random random) {
    for (var domain in domains) {
      avlTree.insertNode(
          domain.code,
          Offset(random.nextDouble() * size.width,
              random.nextDouble() * size.height));

      for (var model in domain.models) {
        avlTree.insertNode(
            model.code,
            Offset(random.nextDouble() * size.width,
                random.nextDouble() * size.height));

        for (var entity in model.concepts) {
          avlTree.insertNode(
              entity.code,
              Offset(random.nextDouble() * size.width,
                  random.nextDouble() * size.height));

          for (var child in entity.children) {
            avlTree.insertNode(
                child.code,
                Offset(random.nextDouble() * size.width,
                    random.nextDouble() * size.height));
          }
        }
      }
    }
  }

  void _applyForces(Map<String, Offset> forces) {
    final positions = _getPositions();

    for (var entry in positions.entries) {
      final position = entry.value;
      var force = Offset.zero;

      for (var otherEntry in positions.entries) {
        if (entry.key == otherEntry.key) continue;

        final direction = position - otherEntry.value;
        final distance = max(direction.distance, 0.1); // Avoid division by zero
        final repulsion =
            direction / distance * repulsionForce / (distance * distance);

        force += repulsion;
      }

      forces[entry.key] = force;
    }

    for (var domain in positions.keys) {
      for (var model in positions.keys) {
        if (domain == model) continue;
        final direction = positions[domain]! - positions[model]!;
        final distance = max(direction.distance, 1.0);
        final attraction =
            direction / distance * springForce * log(distance + 1);

        forces[domain] = forces[domain]! - attraction;
        forces[model] = forces[model]! + attraction;
      }
    }
  }

  void _updatePositions(Map<String, Offset> forces) {
    final positions = _getPositions();

    for (var entry in positions.entries) {
      final force = forces[entry.key]!;
      final velocity =
          (this.velocity[entry.key] ?? Offset.zero) + force * springForce;

      avlTree.insertNode(entry.key, entry.value + velocity);
      this.velocity[entry.key] = velocity * damping;
    }
  }

  Map<String, Offset> _getPositions() {
    final positions = <String, Offset>{};
    void traverse(TreeNode? node) {
      if (node == null) return;
      positions[node.key] = node.position;
      traverse(node.left);
      traverse(node.right);
    }

    traverse(avlTree.root);
    return positions;
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

enum NodeType {
  domain,
  model,
  entity,
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

    _positionRoots(domains, center, positions);

    return positions;
  }

  void _positionRoots(
      Domains domains, Offset center, Map<String, Offset> positions) {
    final rootCount = domains.length;
    final rootAngleStep = 2 * pi / rootCount;
    for (int i = 0; i < rootCount; i++) {
      final domain = domains.elementAt(i);
      final angle = i * rootAngleStep;
      final rootPosition =
          center + Offset(rootRadius * cos(angle), rootRadius * sin(angle));
      positions[domain.code] = rootPosition;

      _positionChildren(
          domain, rootPosition, positions, 1, angle, rootAngleStep / 2);
    }
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

enum LayoutAlgorithmType {
  forceDirected,
  grid,
  circular,
  masterDetail,
}

abstract class LayoutAlgorithm {
  Map<String, Offset> calculateLayout(Domains domains, Size size);
}

// Add BFS and DFS traversal algorithms

class GraphTraversal {
  final Graph graph;

  GraphTraversal(this.graph);

  List<String> bfs(String start) {
    List<String> visited = [];
    Queue<String> queue = Queue();
    queue.add(start);

    while (queue.isNotEmpty) {
      String node = queue.removeFirst();
      if (!visited.contains(node)) {
        visited.add(node);
        graph.getNeighbors(node)?.forEach((neighbor) {
          if (!visited.contains(neighbor)) {
            queue.add(neighbor);
          }
        });
      }
    }
    return visited;
  }

  List<String> dfs(String start) {
    List<String> visited = [];
    _dfsHelper(start, visited);
    return visited;
  }

  void _dfsHelper(String node, List<String> visited) {
    if (visited.contains(node)) return;
    visited.add(node);
    graph.getNeighbors(node)?.forEach((neighbor) {
      if (!visited.contains(neighbor)) {
        _dfsHelper(neighbor, visited);
      }
    });
  }
}
