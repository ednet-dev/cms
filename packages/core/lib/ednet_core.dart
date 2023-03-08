library ednet_core;

import 'dart:math';
import 'dart:convert';

export 'domain/model.dart';

part 'domain/i_domain_models.dart';

part 'domain/domain_models.dart';

part 'domain/session.dart';

part 'i_repository.dart';

part 'core_repository.dart';

part 'gen/ednet_repository.dart';

part 'gen/ednet_library.dart';

part 'gen/ednet_library_app.dart';

part 'gen/ednet_domain_generic.dart';

part 'gen/ednet_domain_specific.dart';

part 'gen/ednet_model_generic.dart';

part 'gen/ednet_model_specific.dart';

part 'gen/ednet_concept_generic.dart';

part 'gen/ednet_concept_specific.dart';

part 'gen/ednet_test.dart';

part 'gen/ednet_web.dart';

part 'gen/random.dart';

part 'gen/random_data.dart';

part 'gen/search.dart';

part 'domain/model/commands/add_command.dart';

part 'domain/model/commands/interfaces/i_basic_command.dart';

part 'domain/model/commands/interfaces/i_entity_command.dart';

part 'domain/model/commands/interfaces/i_entities_command.dart';

part 'domain/model/commands/interfaces/i_command.dart';

part 'domain/model/commands/interfaces/i_transaction.dart';

part 'domain/model/commands/remove_command.dart';

part 'domain/model/commands/set_attribute_command.dart';

part 'domain/model/commands/set_child_command.dart';

part 'domain/model/commands/set_parent_command.dart';

part 'domain/model/commands/transaction.dart';

part 'domain/model/event/past.dart';

part 'domain/model/event/interfaces/i_past_command.dart';

part 'domain/model/event/interfaces/i_command_reaction.dart';

part 'domain/model/event/interfaces/i_past.dart';

part 'domain/model/event/interfaces/i_source_of_command_reaction.dart';

part 'domain/model/event/interfaces/i_source_of_past_reaction.dart';

part 'domain/model/transfer/json.dart';

part 'domain/model/entity/entities.dart';

part 'domain/model/entity/entity.dart';

part 'domain/model/entity/interfaces/i_entity.dart';

part 'domain/model/entity/id.dart';

part 'domain/model/entity/interfaces/i_id.dart';

part 'domain/model/entity/interfaces/i_entities.dart';

part 'domain/model/model_entries.dart';

part 'domain/model/i_model_entries.dart';

part 'domain/model/oid.dart';

part 'domain/model/reference.dart';

part 'meta/attributes.dart';

part 'meta/attribute.dart';

part 'meta/children.dart';

part 'meta/concepts.dart';

part 'meta/concept.dart';

part 'meta/domain.dart';

part 'meta/domains.dart';

part 'meta/models.dart';

part 'meta/neighbor.dart';

part 'meta/parents.dart';

part 'meta/parent.dart';

part 'meta/property.dart';

part 'meta/types.dart';

part 'domain/model/primitives/dart_basic_types.dart';

part 'domain/core/serializable.dart';

part 'utilities/text/transformation.dart';

part 'domain/model/error/exceptions.dart';

part 'domain/model/error/i_validation_exception.dart';

part 'domain/model/error/validation_exception.dart';

part 'domain/model/error/validation_exceptions.dart';

part 'domain/model/aggregate_root/aggregate_root.dart';

/// Authorization
part 'domain/application/i_authorizable_entity.dart';
