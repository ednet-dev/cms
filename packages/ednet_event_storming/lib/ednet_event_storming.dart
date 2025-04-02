/// A library for supporting Event Storming in Domain-Driven Design
///
/// Event Storming is a collaborative modeling technique that enables teams to
/// explore complex business domains. This library provides tools for capturing
/// and working with the artifacts generated during Event Storming sessions,
/// including domain events, commands, aggregates, policies, and more.
///
/// The library seamlessly integrates with EDNet Core to bridge the gap between
/// collaborative modeling sessions and implementable domain models.
library ednet_event_storming;

import 'package:ednet_core/ednet_core.dart';

export 'src/model/domain_event.dart';
export 'src/model/command.dart';
export 'src/model/aggregate.dart';
export 'src/model/policy.dart';
export 'src/model/external_system.dart';
export 'src/model/hot_spot.dart';
export 'src/model/read_model.dart';

export 'src/session/storming_session.dart';
export 'src/session/event_storming_board.dart';
export 'src/session/participant.dart';

export 'src/visualization/board_renderer.dart';
export 'src/analysis/domain_analyzer.dart';
export 'src/export/model_exporter.dart'; 