/// EDNetFlow: A comprehensive visualization and modeling toolkit for EDNet
///
/// This library provides tools for various domain visualization and modeling techniques:
///
/// 1. **Event Storming**: Collaborative modeling technique for exploring complex business domains
/// 2. **Domain Model Visualization**: Graph-based visualization of domain models with multiple layout algorithms
/// 3. **Process Flow Modeling**: Visualization and modeling of business processes and workflows
/// 4. **Interactive Editing**: Tools for interactive editing of domain models through visual interfaces
///
/// The library seamlessly integrates with EDNet Core to bridge the gap between
/// visual modeling and implementable domain models.
library ednet_flow;

// Core imports
export 'package:flutter/material.dart' show Color, Colors, Offset;

// Selected exports to provide core functionality without naming conflicts
// Domain visualization components
export 'src/graph/node.dart';
export 'src/graph/node_type.dart';
export 'src/graph/edge.dart';
export 'src/graph/edge_type.dart';
export 'src/graph/edge_direction.dart';
export 'src/graph/domain_model_graph.dart';

// Visualization adapters
export 'src/domain_visualization/adapters/core_adapter.dart';

// Layouts and algorithms
export 'src/domain_visualization/layout/layout_algorithm.dart';
export 'src/domain_visualization/layout/graph_layout.dart';
export 'src/domain_visualization/algorithms/circular_layout_algorithm.dart';
export 'src/domain_visualization/algorithms/grid_layout_algorithm.dart';
export 'src/domain_visualization/algorithms/dijkstra_layout_algorithm.dart';
export 'src/domain_visualization/algorithms/mst_layout_algorithm.dart';

// Event storming
export 'src/event_storming/session/storming_session.dart';
export 'src/event_storming/visualization/board_renderer.dart';

// Process Flow
export 'src/process_flow/model/process.dart';
export 'src/process_flow/visualization/process_renderer.dart';

// The codebase requires significant refactoring due to duplicate definitions
// and architectural inconsistencies. See REFACTORING_PLAN.md for details.
//
// For now, this is a minimal export set that should compile without errors.
