library ednet_core;

// Dart imports
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:expressions/expressions.dart';
import 'package:meta/meta.dart';
import 'package:yaml/yaml.dart';

// Export existing model and domain components
// export 'domain/model/entity/entity.dart'
//    if (dart.library.html) 'domain/model/entity/entity_web.dart';
// export 'meta/concept.dart';
// export 'meta/attribute.dart';
// export 'domain/model.dart';
// export 'meta/domain.dart';
// export 'domain/model/entity/id.dart';

// Export patterns
// export 'domain/patterns/common/base_message.dart';
// export 'domain/patterns/common/channel.dart';
// export 'domain/patterns/filter/message_filter.dart';
// export 'domain/patterns/aggregator/aggregator.dart';
// export 'domain/patterns/canonical/canonical_model.dart';
// export 'domain/patterns/ui/ui_module.dart';

// packages/core/lib/domain/patterns/common/base_message.dart
part 'domain/patterns/common/base_message.dart';

// Core components - existing parts
part 'domain/core/constants.dart';
part 'domain/core/random_id.dart';
part 'domain/core/time.dart';
part 'domain/core/type.dart';
part 'domain/core/validation.dart';

// Core components
part 'core_repository.dart';
part 'i_repository.dart';

// Domain modeling
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

// Application services
part 'domain/application/command_result.dart';
part 'domain/application/value_object.dart';

// Repository components
part 'repository/filter_criteria.dart';

// Event components
part 'domain/model/event/event.dart';

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

// Error handling
part 'domain/model/error/i_validation_exception.dart';
part 'domain/model/error/validation_exception.dart';
part 'domain/model/error/validation_exceptions.dart';
part 'domain/model/error/exceptions.dart';

// Configuration
part 'utilities/dsl/bootstrap_domain_model_from_yaml.dart';

// Utilities
part 'util/text_transformers.dart';
part 'domain/model/reference.dart';
part 'domain/model/transfer/json.dart';
part 'domain/session.dart';

// Generated code
part 'domain/model/model_entries.dart';
part 'domain/model/i_model_entries.dart';
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

// Metadata
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

// Enterprise Integration Patterns
part 'domain/patterns/aggregator/aggregator.dart';
part 'domain/patterns/common/channel.dart';
part 'domain/patterns/common/http_types.dart';
part 'domain/patterns/filter/ednet_core_message_filter.dart';
part 'domain/patterns/channel/adapter/channel_adapter.dart';
part 'domain/patterns/canonical/canonical_model.dart';
part 'domain/patterns/filter/message_filter.dart';
