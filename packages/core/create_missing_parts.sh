#!/bin/bash

# Script to create missing part files for ednet_core.dart
# Generated on $(date)

echo "Creating missing part files for ednet_core.dart..."

# For domain/model/commands/results/add_command_result.dart
mkdir -p lib/domain/model/commands/results
echo "part of ednet_core;" >lib/domain/model/commands/results/add_command_result.dart

# For domain/model/commands/results/command_result.dart
mkdir -p lib/domain/model/commands/results
echo "part of ednet_core;" >lib/domain/model/commands/results/command_result.dart

# For domain/model/commands/results/i_command_result.dart
mkdir -p lib/domain/model/commands/results
echo "part of ednet_core;" >lib/domain/model/commands/results/i_command_result.dart

# For domain/model/commands/results/remove_command_result.dart
mkdir -p lib/domain/model/commands/results
echo "part of ednet_core;" >lib/domain/model/commands/results/remove_command_result.dart

# For domain/model/commands/results/set_attribute_command_result.dart
mkdir -p lib/domain/model/commands/results
echo "part of ednet_core;" >lib/domain/model/commands/results/set_attribute_command_result.dart

# For domain/model/commands/results/transaction_result.dart
mkdir -p lib/domain/model/commands/results
echo "part of ednet_core;" >lib/domain/model/commands/results/transaction_result.dart

# For domain/model/entity/attribute.dart
mkdir -p lib/domain/model/entity
echo "part of ednet_core;" >lib/domain/model/entity/attribute.dart

# For domain/model/entity/code.dart
mkdir -p lib/domain/model/entity
echo "part of ednet_core;" >lib/domain/model/entity/code.dart

# For domain/model/entity/concept.dart
mkdir -p lib/domain/model/entity
echo "part of ednet_core;" >lib/domain/model/entity/concept.dart

# For domain/model/entity/entries.dart
mkdir -p lib/domain/model/entity
echo "part of ednet_core;" >lib/domain/model/entity/entries.dart

# For domain/model/entity/i_attribute.dart
mkdir -p lib/domain/model/entity
echo "part of ednet_core;" >lib/domain/model/entity/i_attribute.dart

# For domain/model/entity/i_concept.dart
mkdir -p lib/domain/model/entity
echo "part of ednet_core;" >lib/domain/model/entity/i_concept.dart

# For domain/model/entity/ientity.dart
mkdir -p lib/domain/model/entity
echo "part of ednet_core;" >lib/domain/model/entity/ientity.dart

# For domain/model/entity/ientries.dart
mkdir -p lib/domain/model/entity
echo "part of ednet_core;" >lib/domain/model/entity/ientries.dart

# For domain/model/entity/reference.dart
mkdir -p lib/domain/model/entity
echo "part of ednet_core;" >lib/domain/model/entity/reference.dart

# For domain/model/session/i_domain_session.dart
mkdir -p lib/domain/model/session
echo "part of ednet_core;" >lib/domain/model/session/i_domain_session.dart

# For domain/model/session/session.dart
mkdir -p lib/domain/model/session
echo "part of ednet_core;" >lib/domain/model/session/session.dart

# For domain/model/queries/i_query.dart
mkdir -p lib/domain/model/queries
echo "part of ednet_core;" >lib/domain/model/queries/i_query.dart

# For domain/model/queries/i_query_handler.dart
mkdir -p lib/domain/model/queries
echo "part of ednet_core;" >lib/domain/model/queries/i_query_handler.dart

# For domain/model/queries/i_query_result.dart
mkdir -p lib/domain/model/queries
echo "part of ednet_core;" >lib/domain/model/queries/i_query_result.dart

# For domain/application/application_service.dart
mkdir -p lib/domain/application
echo "part of ednet_core;" >lib/domain/application/application_service.dart

# For domain/application/command_handler.dart
mkdir -p lib/domain/application
echo "part of ednet_core;" >lib/domain/application/command_handler.dart

# For domain/application/concept_application_service.dart
mkdir -p lib/domain/application
echo "part of ednet_core;" >lib/domain/application/concept_application_service.dart

# For domain/application/domain_session.dart
mkdir -p lib/domain/application
echo "part of ednet_core;" >lib/domain/application/domain_session.dart

# For domain/application/i_application_service.dart
mkdir -p lib/domain/application
echo "part of ednet_core;" >lib/domain/application/i_application_service.dart

# For domain/application/service_factory.dart
mkdir -p lib/domain/application
echo "part of ednet_core;" >lib/domain/application/service_factory.dart

# For domain/application/query_dispatcher.dart
mkdir -p lib/domain/application
echo "part of ednet_core;" >lib/domain/application/query_dispatcher.dart

# For json_serialization/json_serializable.dart
mkdir -p lib/json_serialization
echo "part of ednet_core;" >lib/json_serialization/json_serializable.dart

# For json_serialization/json_serializer.dart
mkdir -p lib/json_serialization
echo "part of ednet_core;" >lib/json_serialization/json_serializer.dart

# For json_serialization/serialization_context.dart
mkdir -p lib/json_serialization
echo "part of ednet_core;" >lib/json_serialization/serialization_context.dart

# For json_serialization/serialization_error.dart
mkdir -p lib/json_serialization
echo "part of ednet_core;" >lib/json_serialization/serialization_error.dart

# For json_serialization/serialization_path.dart
mkdir -p lib/json_serialization
echo "part of ednet_core;" >lib/json_serialization/serialization_path.dart

# For json_serialization/serialization_result.dart
mkdir -p lib/json_serialization
echo "part of ednet_core;" >lib/json_serialization/serialization_result.dart

# For domain/model/id/id.dart
mkdir -p lib/domain/model/id
echo "part of ednet_core;" >lib/domain/model/id/id.dart

# For domain/model/id/oid.dart
mkdir -p lib/domain/model/id
echo "part of ednet_core;" >lib/domain/model/id/oid.dart

# For domain/model/commands/command.dart
mkdir -p lib/domain/model/commands
echo "part of ednet_core;" >lib/domain/model/commands/command.dart

# Fix existing files without part of declarations
if [ -f lib/domain/model/policy/entity_policies.dart ]; then
    sed -i '' '1s/^/part of ednet_core;\n\n/' lib/domain/model/policy/entity_policies.dart
    echo "Fixed lib/domain/model/policy/entity_policies.dart"
fi

if [ -f lib/domain/model/policy/entity_policy_factory.dart ]; then
    sed -i '' '1s/^/part of ednet_core;\n\n/' lib/domain/model/policy/entity_policy_factory.dart
    echo "Fixed lib/domain/model/policy/entity_policy_factory.dart"
fi

echo "All missing files created successfully!"
