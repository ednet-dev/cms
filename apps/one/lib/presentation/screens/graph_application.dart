import 'package:ednet_core/ednet_core.dart';
import 'package:flutter/material.dart';

import '../pages/graph_page.dart';

void main() {
  // runApp(GraphApp());
}

/// @deprecated Use GraphPage instead
/// This application is being phased out as part of the visualization refactoring.
/// It will be removed in a future release. Use GraphPage with UnifiedVisualizationCanvas instead.
@Deprecated('Use GraphPage with UnifiedVisualizationCanvas instead')
class GraphApp extends StatelessWidget {
  const GraphApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Use GraphPage instead, keeping the same interface for backward compatibility
    return MaterialApp(home: const GraphPage());
  }
}

/// @deprecated Use GraphPage with UnifiedVisualizationCanvas instead
/// This class is being phased out as part of the visualization refactoring.
/// It will be removed in a future release.
@Deprecated('Use GraphPage with UnifiedVisualizationCanvas instead')
class GraphWidget extends StatelessWidget {
  GraphWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Use the deprecated GraphWidget from graph_page.dart for compatibility
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'This visualization is deprecated. Please use the new unified visualization canvas.',
            style: TextStyle(color: Colors.red),
          ),
        ),
        Expanded(child: GraphPage()),
      ],
    );
  }
}
