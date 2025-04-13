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

import 'dart:convert';
import 'package:ednet_core/ednet_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/domain_model_graph.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_flow/ednet_flow.dart';
import 'package:ednet_flow/src/event_storming/model/element.dart';

// Core imports
export 'package:flutter/material.dart' show Color, Colors, Offset;

// Selected parts to provide core functionality without naming conflicts
// Domain visualization components
part 'src/graph/node.dart';
part 'src/graph/node_type.dart';
part 'src/graph/edge.dart';
part 'src/graph/edge_type.dart';
part 'src/graph/edge_direction.dart';
part 'src/graph/domain_model_graph.dart';

// Visualization adapters
part 'src/domain_visualization/adapters/core_adapter.dart';

// Layouts and algorithms
part 'src/domain_visualization/layout/layout_algorithm.dart';
part 'src/domain_visualization/layout/graph_layout.dart';
part 'src/domain_visualization/algorithms/circular_layout_algorithm.dart';
part 'src/domain_visualization/algorithms/grid_layout_algorithm.dart';
part 'src/domain_visualization/algorithms/dijkstra_layout_algorithm.dart';
part 'src/domain_visualization/algorithms/mst_layout_algorithm.dart';

// Event storming
part 'src/event_storming/session/storming_session.dart';
part 'src/event_storming/visualization/board_renderer.dart';

// Process Flow
part 'src/process_flow/model/process.dart';
part 'src/process_flow/visualization/process_renderer.dart';

// The codebase requires significant refactoring due to duplicate definitions
// and architectural inconsistencies. See REFACTORING_PLAN.md for details.
//
// For now, this is a minimal part set that should compile without errors.

part 'src/domain_visualization/card/entity_widget.dart';
