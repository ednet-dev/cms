import 'package:flutter/material.dart';
import 'dart:developer' as developer;

import '../../generated/one_application.dart';
import '../widgets/canvas/unified_visualization_canvas.dart';
import '../widgets/layout/graph/algorithms/optimized_force_directed.dart';
import '../widgets/layout/graph/layout/layout_algorithm.dart';
import '../widgets/layout/web/header_widget.dart' as header;

/// Graph visualization page for domain models
///
/// This page provides a visual representation of domains, models, and their concepts
/// using an interactive graph view that allows zooming and panning.
class GraphPage extends StatefulWidget {
  /// Route name for this page
  static const String routeName = '/graph';

  /// Creates a graph page
  const GraphPage({super.key});

  @override
  State<GraphPage> createState() => _GraphPageState();
}

class _GraphPageState extends State<GraphPage> with TickerProviderStateMixin {
  late OneApplication _application;
  late LayoutAlgorithm _currentLayoutAlgorithm;
  Matrix4? _currentTransformation;
  bool _isLoading = true;
  String _debugInfo = '';

  @override
  void initState() {
    super.initState();
    developer.log(
      'Initializing GraphPage with new implementation',
      name: 'GraphViz',
    );
    _application = OneApplication();
    _currentLayoutAlgorithm = OptimizedForceDirectedLayout();

    // Defer initialization to ensure application data is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
    });
  }

  void _initializeData() async {
    try {
      developer.log('Loading data for visualization', name: 'GraphViz');

      // Check if domains are available
      if (_application.groupedDomains.isEmpty) {
        setState(() {
          _debugInfo = 'No domain data available. Please try again later.';
          _isLoading = false;
        });
        developer.log(
          'No domain data available for visualization',
          name: 'GraphViz',
        );
        return;
      }

      // Log domain data for debugging
      developer.log(
        'Domains loaded: ${_application.groupedDomains.length} domains, ' +
            'first domain has ${_application.groupedDomains.first.models.length} models',
        name: 'GraphViz',
      );

      setState(() {
        _isLoading = false;
      });
    } catch (e, stack) {
      developer.log(
        'Error initializing graph visualization: $e\n$stack',
        name: 'GraphViz',
      );
      setState(() {
        _debugInfo = 'Error loading visualization: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    developer.log(
      'Building GraphPage with newest implementation',
      name: 'GraphViz',
    );

    return Scaffold(
      appBar: AppBar(
        title: header.HeaderWidget(
          path: const ['Home', 'Graph Visualization'],
          onPathSegmentTapped: (index) {
            if (index == 0) {
              Navigator.popUntil(context, ModalRoute.withName('/'));
            }
          },
          filters: [],
          onAddFilter: (header.FilterCriteria filter) {},
          onBookmark: () {},
        ),
        actions: [
          // Add a refresh button
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh visualization',
            onPressed: () {
              setState(() {
                _isLoading = true;
                _debugInfo = '';
              });
              _initializeData();
            },
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _debugInfo.isNotEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_debugInfo, style: const TextStyle(color: Colors.red)),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isLoading = true;
                          _debugInfo = '';
                        });
                        _initializeData();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              )
              : LayoutBuilder(
                builder: (context, constraints) {
                  // Ensure the canvas has proper constraints
                  if (constraints.maxHeight == 0 || constraints.maxWidth == 0) {
                    return const Center(
                      child: Text('Insufficient space to render visualization'),
                    );
                  }

                  return SizedBox(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                    child: UnifiedVisualizationCanvas(
                      domains: _application.groupedDomains,
                      layoutAlgorithm: _currentLayoutAlgorithm,
                      initialTransformation: _currentTransformation,
                      onTransformationChanged: (matrix) {
                        _currentTransformation = matrix;
                      },
                      onChangeLayoutAlgorithm: (algorithm) {
                        setState(() {
                          _currentLayoutAlgorithm = algorithm;
                        });
                      },
                      debugMode: true, // Enable debug mode to see metrics
                    ),
                  );
                },
              ),
    );
  }
}

/// @deprecated Use GraphPage instead
/// This class is being phased out as part of the visualization refactoring.
/// It will be removed in a future release.
@Deprecated('Use GraphPage with UnifiedVisualizationCanvas instead')
class GraphWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Redirect to the new implementation to maintain backward compatibility
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'This visualization is deprecated. Please use the new unified visualization canvas.',
            style: TextStyle(color: Colors.red),
          ),
        ),
        Expanded(
          child: UnifiedVisualizationCanvas(
            domains: OneApplication().groupedDomains,
            layoutAlgorithm: OptimizedForceDirectedLayout(),
            onTransformationChanged: (_) {},
            onChangeLayoutAlgorithm: (_) {},
            debugMode: false,
          ),
        ),
      ],
    );
  }
}
