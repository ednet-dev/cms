library ednet_core;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:expressions/expressions.dart';
import 'package:yaml/yaml.dart';

// Core components
part 'core_repository.dart';
part 'i_repository.dart';

// Domain modeling
// part 'domain/bounded_context.dart';
part 'domain/core/serializable.dart';

part 'domain/domain_models.dart';

part 'domain/i_domain_models.dart';
part 'domain/model/aggregate_root/aggregate_root.dart';

// Entity components
part 'domain/model/oid.dart';
part 'domain/model/entity/entity.dart';
part 'domain/model/entity/entities.dart';
part 'domain/model/entity/id.dart';
part 'domain/model/entity/interfaces/i_entity.dart';
part 'domain/model/entity/interfaces/i_entities.dart';
part 'domain/model/entity/interfaces/i_id.dart';

// Commands
part 'domain/model/commands/add_command.dart';

part 'domain/model/commands/interfaces/i_basic_command.dart';

part 'domain/model/commands/interfaces/i_command.dart';

part 'domain/model/commands/interfaces/i_entities_command.dart';

part 'domain/model/commands/interfaces/i_entity_command.dart';

part 'domain/model/commands/interfaces/i_transaction.dart';

part 'domain/model/commands/interfaces/i_command_reaction.dart';

part 'domain/model/commands/interfaces/i_source_of_command_reaction.dart';

part 'domain/model/commands/interfaces/i_source_of_past_reaction.dart';

part 'domain/model/commands/interfaces/i_past.dart';

part 'domain/model/commands/interfaces/i_past_command.dart';

part 'domain/model/commands/remove_command.dart';

part 'domain/model/commands/set_attribute_command.dart';

part 'domain/model/commands/transaction.dart';

part 'domain/model/commands/past.dart';

part 'domain/model/commands/set_child_command.dart';

part 'domain/model/commands/set_parent_command.dart';

// Queries and query processing
// part 'domain/model/queries/concept_query.dart';
// part 'domain/model/queries/entity_query_result.dart';
// part 'domain/model/queries/expression_query.dart';
// part 'domain/model/queries/interfaces/i_query.dart';
// part 'domain/model/queries/interfaces/i_query_handler.dart';
// part 'domain/model/queries/interfaces/i_query_result.dart';
// part 'domain/model/queries/query.dart';
// part 'domain/model/queries/query_dispatcher.dart';
// part 'domain/model/queries/query_result.dart';

// Application services
// part 'domain/application/command.dart';
part 'domain/application/command_result.dart';

// Repository components
// part 'repository/repository.dart';
// part 'repository/repository_factory.dart';
// part 'repository/in_memory_repository.dart';
// part 'repository/openapi_repository.dart';
// part 'repository/openapi_repository_factory.dart';
part 'repository/filter_criteria.dart';

// Application components
// part 'domain/application/aggregate_root.dart';

// Event components
part 'domain/model/event/event.dart';

// part 'domain/application/domain_event.dart';
// part 'domain/application/event_publisher.dart';
// part 'domain/application/event_store.dart';
// part 'domain/application/event_type_registry.dart';
// part 'domain/application/i_authorizable_entity.dart';
part 'domain/application/value_object.dart';

// Entitlement components
// part 'domain/application/entitlement/entitlement.dart';
// part 'domain/application/entitlement/security_context.dart';
// part 'domain/application/entitlement/authorize_attribute.dart';
// part 'domain/application/entitlement/entitlement_configuration.dart';
// part 'domain/application/entitlement/authorization_mixin.dart';
// part 'domain/application/entitlement/secure_query_handler.dart';
// part 'domain/application/entitlement/secure_application_service.dart';

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

part 'domain/model/policy/policy_violation_exception.dart';

part 'domain/model/policy/policy_evaluation_tracer.dart';
part 'domain/model/error/i_validation_exception.dart';
part 'domain/model/error/validation_exception.dart';
part 'domain/model/error/validation_exceptions.dart';

// Configuration
// part 'configuration/bootstrap.dart';
part 'utilities/dsl/bootstrap_domain_model_from_yaml.dart';

// Utilities
part 'util/text_transformers.dart';

part 'domain/model/reference.dart';
part 'domain/model/transfer/json.dart';
part 'domain/session.dart';
part 'gen/ednet_concept_generic.dart';
part 'gen/ednet_concept_specific.dart';
part 'gen/ednet_domain_generic.dart';
part 'gen/ednet_domain_specific.dart';
part 'gen/ednet_library.dart';
part 'gen/ednet_library_app.dart';
part 'gen/ednet_model_generic.dart';
part 'gen/ednet_model_specific.dart';
part 'gen/ednet_repository.dart';
part 'gen/ednet_web.dart';
part 'gen/i_one_application.dart';
part 'gen/random.dart';
part 'gen/random_data.dart';
part 'gen/search.dart';
part 'meta/attribute.dart';
part 'meta/attributes.dart';
part 'meta/children.dart';
part 'meta/concept.dart';
part 'meta/concepts.dart';
part 'meta/domain.dart';
part 'meta/domains.dart';
part 'meta/models.dart';
part 'meta/neighbor.dart';
part 'meta/parent.dart';
part 'meta/parents.dart';
part 'meta/property.dart';
part 'meta/types.dart';

// Error handling
part 'domain/model/error/exceptions.dart';

// Model components
part 'domain/model/model_entries.dart';

part 'domain/model/i_model_entries.dart';
