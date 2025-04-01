/// CQRS adapter for Drift integration with EDNet Core
/// 
/// This library provides:
/// - Query adapters for EDNet Core model queries to Drift queries
/// - Command adapters for EDNet Core commands to Drift operations
/// - REST-compatible query interfaces
/// - Query result mapping to domain entities
///
/// It connects the domain model CQRS components with Drift persistence layer.
library cqrs_drift;

import 'dart:async';
import 'package:drift/drift.dart';
import 'package:ednet_core/domain/model.dart' as model;
import 'package:ednet_core/domain/application.dart' as app;
import 'package:ednet_core/ednet_core.dart';

import 'ednet_drift_repository.dart';

part 'src/cqrs/query_adapter.dart';
part 'src/cqrs/command_adapter.dart';
part 'src/cqrs/query_handler.dart';
part 'src/cqrs/drift_repository_extension.dart';
part 'src/cqrs/rest_query_adapter.dart'; 