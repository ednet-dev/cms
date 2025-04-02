library ednet_core;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:expressions/expressions.dart';
import 'package:yaml/yaml.dart';

// Core components
part 'core_repository.dart';

// Domain modeling
part 'domain/bounded_context.dart';
part 'domain/core/serializable.dart';
part 'domain/domain_models.dart';
part 'domain/i_domain_models.dart';
part 'domain/model/aggregate_root/aggregate_root.dart';

// Commands
part 'domain/model/commands/add_command.dart';
part 'domain/model/commands/interfaces/i_basic_command.dart';
part 'domain/model/commands/interfaces/i_command.dart';
part 'domain/model/commands/interfaces/i_entities_command.dart';
part 'domain/model/commands/interfaces/i_entity_command.dart';
part 'domain/model/commands/interfaces/i_transaction.dart';
part 'domain/model/commands/remove_command.dart';
part 'domain/model/commands/set_attribute_command.dart';
part 'domain/model/commands/transaction.dart';

// Command results
part 'domain/model/commands/results/add_command_result.dart';
part 'domain/model/commands/results/command_result.dart';
part 'domain/model/commands/results/i_command_result.dart';
part 'domain/model/commands/results/remove_command_result.dart';
part 'domain/model/commands/results/set_attribute_command_result.dart';
part 'domain/model/commands/results/transaction_result.dart';

// Entities
part 'domain/model/entity/attribute.dart';
part 'domain/model/entity/code.dart';
part 'domain/model/entity/concept.dart';
part 'domain/model/entity/entity.dart';
part 'domain/model/entity/entries.dart';
part 'domain/model/entity/i_attribute.dart';
part 'domain/model/entity/i_concept.dart';
part 'domain/model/entity/id.dart';
part 'domain/model/entity/ientity.dart';
part 'domain/model/entity/ientries.dart';
part 'domain/model/entity/reference.dart';

// Sessions
part 'domain/model/session/i_domain_session.dart';
part 'domain/model/session/session.dart';

// Queries and query processing
part 'domain/model/queries/concept_query.dart';
part 'domain/model/queries/entity_query_result.dart';
part 'domain/model/queries/expression_query.dart';
part 'domain/model/queries/interfaces/i_query.dart';
part 'domain/model/queries/interfaces/i_query_handler.dart';
part 'domain/model/queries/interfaces/i_query_result.dart';
part 'domain/model/queries/query.dart';
part 'domain/model/queries/query_dispatcher.dart';
part 'domain/model/queries/query_result.dart';

// Application services
part 'domain/application/application_service.dart';
part 'domain/application/command.dart';
part 'domain/application/command_handler.dart';
part 'domain/application/command_result.dart';
part 'domain/application/concept_application_service.dart';
part 'domain/application/domain_session.dart';
part 'domain/application/i_application_service.dart';
part 'domain/application/service_factory.dart';

// Application query handlers
part 'domain/application/query_handler/application_query_handler.dart';
part 'domain/application/query_handler/concept_query_handler.dart';
part 'domain/application/query_handler/default_concept_query_handler.dart';
part 'domain/application/query_handler/repository_query_handler.dart';
part 'domain/application/query_dispatcher.dart';

// Repository components
part 'repository/repository.dart';
part 'repository/repository_factory.dart';
part 'repository/in_memory_repository.dart';
part 'repository/openapi_repository.dart';
part 'repository/openapi_repository_factory.dart';
part 'repository/filter_criteria.dart';

// JSON serialization
part 'json_serialization/json_serializable.dart';
part 'json_serialization/json_serializer.dart';
part 'json_serialization/serialization_context.dart';
part 'json_serialization/serialization_error.dart';
part 'json_serialization/serialization_path.dart';
part 'json_serialization/serialization_result.dart';

// Domain model components
part 'domain/model/id/id.dart';
part 'domain/model/id/oid.dart';
part 'domain/model/commands/command.dart';
part 'domain/application/aggregate_root.dart';
part 'domain/application/domain_event.dart';
part 'domain/application/event_publisher.dart';
part 'domain/application/event_store.dart';
part 'domain/application/event_type_registry.dart';
part 'domain/application/i_authorizable_entity.dart';
part 'domain/application/value_object.dart';
part 'domain/application/query.dart';
part 'domain/application/query_result.dart';
part 'domain/application/query_handler.dart';

// Entitlement components
part 'domain/application/entitlement/entitlement.dart';
part 'domain/application/entitlement/security_context.dart';
part 'domain/application/entitlement/authorize_attribute.dart';
part 'domain/application/entitlement/entitlement_configuration.dart';
part 'domain/application/entitlement/authorization_mixin.dart';
part 'domain/application/entitlement/secure_query_handler.dart';
part 'domain/application/entitlement/secure_application_service.dart';

// Policy components
part 'domain/model/policy/attribute_policy.dart';
part 'domain/model/policy/composite_policy.dart';
part 'domain/model/policy/entity_policies.dart';
part 'domain/model/policy/entity_policy_factory.dart';
part 'domain/model/policy/i_policy.dart';
part 'domain/model/policy/policy_engine.dart';
part 'domain/model/policy/policy_evaluator.dart';
part 'domain/model/policy/policy_registry.dart';
part 'domain/model/policy/policy_scope.dart';
part 'domain/model/policy/relationship_policy.dart';
part 'domain/model/policy/time_based_policy.dart';

// Infrastructure components
part 'domain/infrastructure/graph/domain_model_graph.dart';
part 'domain/infrastructure/graph/edge.dart';
part 'domain/infrastructure/graph/edge_direction.dart';
part 'domain/infrastructure/graph/edge_type.dart';
part 'domain/infrastructure/graph/node.dart';
part 'domain/infrastructure/graph/node_type.dart';
part 'domain/infrastructure/repository/interfaces/i_repository.dart';

// Configuration
part 'configuration/bootstrap.dart';
part 'utilities/dsl/bootstrap_domain_model_from_yaml.dart';
