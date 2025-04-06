part of ednet_core;

/// A canonical data model for integration between systems.
///
/// The Canonical Model pattern defines a shared data format that is independent
/// of any specific application. This allows different systems to communicate
/// without tightly coupling to each other's internal data structures.
///
/// In EDNet/direct democracy contexts, canonical models enable:
/// * Integration between different democratic platforms (voting, deliberation, etc.)
/// * Data exchange between different jurisdictions and governance levels
/// * Preservation of citizen data across system changes and upgrades
/// * Technological sovereignty by avoiding vendor lock-in
abstract class CanonicalModel<T> {
  /// Converts application-specific data to the canonical format
  ///
  /// This method takes any application-specific data type and converts it
  /// to the canonical representation.
  Map<String, dynamic> toCanonical(T applicationData);

  /// Converts canonical data back to application-specific format
  ///
  /// This method takes data in the canonical format and converts it
  /// to the application-specific type.
  T fromCanonical(Map<String, dynamic> canonicalData);

  /// Validates that the given data conforms to the canonical model
  ///
  /// Returns true if the data is valid, false otherwise.
  bool validate(Map<String, dynamic> canonicalData);

  /// Gets the schema for this canonical model
  ///
  /// The schema should describe the structure and constraints of the canonical model.
  Map<String, dynamic> getSchema();
}

/// A canonical model representing data in a standardized format.
///
/// The [CanonicalModel] provides a common representation for data
/// that can be transformed to/from various external systems' formats.
/// This pattern minimizes dependencies when integrating applications
/// that use different data formats.
///
/// In a direct democracy context, canonical models are crucial for:
/// * Standardizing citizen identity data across voting platforms
/// * Representing proposals and amendments in a system-agnostic way
/// * Defining common formats for voting results and analytics
/// * Integrating with various external identity providers and services
@immutable
class CanonicalModel<T> {
  /// The type identifier for this model (e.g., 'user', 'proposal', 'vote')
  final String type;

  /// The canonical data representation
  final T data;

  /// Optional metadata about this model instance
  final Map<String, dynamic>? metadata;

  /// Creates a new canonical model with the specified type and data.
  ///
  /// The [type] parameter identifies the kind of entity this model represents.
  /// The [data] parameter contains the actual canonical representation.
  /// Optional [metadata] can include additional contextual information.
  const CanonicalModel({required this.type, required this.data, this.metadata});

  /// Creates a copy of this model with optionally modified values.
  CanonicalModel<T> copyWith({
    String? type,
    T? data,
    Map<String, dynamic>? metadata,
  }) {
    return CanonicalModel<T>(
      type: type ?? this.type,
      data: data ?? this.data,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Serializes this model to a JSON string.
  String toJson() {
    return jsonEncode({
      'type': type,
      'data': data,
      if (metadata != null) 'metadata': metadata,
    });
  }

  /// Creates a canonical model from a JSON string.
  static CanonicalModel<Map<String, dynamic>> fromJson(String json) {
    final Map<String, dynamic> decoded = jsonDecode(json);

    return CanonicalModel<Map<String, dynamic>>(
      type: decoded['type'],
      data: decoded['data'],
      metadata: decoded['metadata'],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CanonicalModel<T> &&
        other.type == type &&
        _deepEquals(other.data, data) &&
        _deepEquals(other.metadata, metadata);
  }

  @override
  int get hashCode => Object.hash(type, data, metadata);

  /// Utility for deep equality checking
  bool _deepEquals(dynamic obj1, dynamic obj2) {
    if (obj1 == null && obj2 == null) return true;
    if (obj1 == null || obj2 == null) return false;

    if (obj1 is Map && obj2 is Map) {
      if (obj1.length != obj2.length) return false;
      return obj1.entries.every(
        (entry) =>
            obj2.containsKey(entry.key) &&
            _deepEquals(entry.value, obj2[entry.key]),
      );
    }

    if (obj1 is List && obj2 is List) {
      if (obj1.length != obj2.length) return false;
      for (var i = 0; i < obj1.length; i++) {
        if (!_deepEquals(obj1[i], obj2[i])) return false;
      }
      return true;
    }

    return obj1 == obj2;
  }
}

/// An abstract formatter for converting between canonical and external formats
abstract class ModelFormatter<E, C> {
  /// Converts a canonical model to an external system format
  E toExternalFormat(CanonicalModel<C> canonicalModel);

  /// Converts an external system format to a canonical model
  CanonicalModel<C> fromExternalFormat(E externalFormat);
}

/// Formatter for System A's specific data format
class SystemAFormatter
    implements ModelFormatter<Map<String, dynamic>, Map<String, dynamic>> {
  @override
  Map<String, dynamic> toExternalFormat(
    CanonicalModel<Map<String, dynamic>> canonicalModel,
  ) {
    if (canonicalModel.type == 'user') {
      return {
        'user_id': canonicalModel.data['id'],
        'full_name':
            '${canonicalModel.data['firstName']} ${canonicalModel.data['lastName']}',
        'email_address': canonicalModel.data['email'],
        'user_age': canonicalModel.data['age'],
      };
    }

    // Handle other types or return a default mapping
    return Map.from(canonicalModel.data);
  }

  @override
  CanonicalModel<Map<String, dynamic>> fromExternalFormat(
    Map<String, dynamic> externalFormat,
  ) {
    // Detect format and convert back to canonical
    if (externalFormat.containsKey('user_id') &&
        externalFormat.containsKey('full_name')) {
      final fullNameParts = externalFormat['full_name'].split(' ');
      final firstName = fullNameParts.first;
      final lastName =
          fullNameParts.length > 1 ? fullNameParts.sublist(1).join(' ') : '';

      return CanonicalModel<Map<String, dynamic>>(
        type: 'user',
        data: {
          'id': externalFormat['user_id'],
          'firstName': firstName,
          'lastName': lastName,
          'email': externalFormat['email_address'],
          'age': externalFormat['user_age'],
        },
      );
    }

    // Default fallback
    return CanonicalModel<Map<String, dynamic>>(
      type: 'unknown',
      data: Map.from(externalFormat),
    );
  }
}

/// Formatter for System B's specific data format
class SystemBFormatter
    implements ModelFormatter<Map<String, dynamic>, Map<String, dynamic>> {
  @override
  Map<String, dynamic> toExternalFormat(
    CanonicalModel<Map<String, dynamic>> canonicalModel,
  ) {
    if (canonicalModel.type == 'user') {
      return {
        'userId': canonicalModel.data['id'],
        'userName':
            '${canonicalModel.data['firstName']} ${canonicalModel.data['lastName']}',
        'contactInfo': {'emailAddress': canonicalModel.data['email']},
        'userDetails': {'ageInYears': canonicalModel.data['age']},
      };
    }

    // Handle other types or return a default mapping
    return Map.from(canonicalModel.data);
  }

  @override
  CanonicalModel<Map<String, dynamic>> fromExternalFormat(
    Map<String, dynamic> externalFormat,
  ) {
    // Detect format and convert back to canonical
    if (externalFormat.containsKey('userId') &&
        externalFormat.containsKey('userName')) {
      final nameParts = externalFormat['userName'].split(' ');
      final firstName = nameParts.first;
      final lastName =
          nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

      return CanonicalModel<Map<String, dynamic>>(
        type: 'user',
        data: {
          'id': externalFormat['userId'],
          'firstName': firstName,
          'lastName': lastName,
          'email': externalFormat['contactInfo']?['emailAddress'],
          'age': externalFormat['userDetails']?['ageInYears'],
        },
      );
    }

    // Default fallback
    return CanonicalModel<Map<String, dynamic>>(
      type: 'unknown',
      data: Map.from(externalFormat),
    );
  }
}

/// Validates canonical models against JSON schemas.
class ModelValidator {
  /// The schemas for different model types, indexed by type name
  final Map<String, dynamic> schemas;

  /// Validation errors from the last validation operation
  final List<String> _errors = [];

  /// Creates a new validator with the specified schemas.
  ModelValidator({required this.schemas});

  /// Validates a canonical model against its corresponding schema.
  ///
  /// Returns true if the model is valid, false otherwise.
  /// After validation, errors can be accessed through the [errors] property.
  bool validate(CanonicalModel<Map<String, dynamic>> model) {
    _errors.clear();

    // Get the schema for this model type
    final schema = schemas[model.type];
    if (schema == null) {
      _errors.add('No schema defined for model type: ${model.type}');
      return false;
    }

    // Simple schema validation implementation
    // In a real system, you would use a proper JSON Schema validator

    // Check required fields
    if (schema['required'] is List) {
      for (final field in schema['required']) {
        if (!model.data.containsKey(field) || model.data[field] == null) {
          _errors.add('Required field "$field" is missing');
          return false;
        }
      }
    }

    // Check property types
    if (schema['properties'] is Map) {
      for (final entry in schema['properties'].entries) {
        final propertyName = entry.key;
        final propertySchema = entry.value;

        if (!model.data.containsKey(propertyName)) continue;

        final value = model.data[propertyName];

        // Type validation
        if (propertySchema['type'] == 'string' && value is! String) {
          _errors.add('Field "$propertyName" should be a string');
          return false;
        } else if (propertySchema['type'] == 'number' && value is! num) {
          _errors.add('Field "$propertyName" should be a number');
          return false;
        } else if (propertySchema['type'] == 'boolean' && value is! bool) {
          _errors.add('Field "$propertyName" should be a boolean');
          return false;
        } else if (propertySchema['type'] == 'object' && value is! Map) {
          _errors.add('Field "$propertyName" should be an object');
          return false;
        } else if (propertySchema['type'] == 'array' && value is! List) {
          _errors.add('Field "$propertyName" should be an array');
          return false;
        }

        // Number constraints
        if (value is num && propertySchema['type'] == 'number') {
          if (propertySchema['minimum'] != null &&
              value < propertySchema['minimum']) {
            _errors.add(
              'Field "$propertyName" should be at least ${propertySchema['minimum']}',
            );
            return false;
          }

          if (propertySchema['maximum'] != null &&
              value > propertySchema['maximum']) {
            _errors.add(
              'Field "$propertyName" should be at most ${propertySchema['maximum']}',
            );
            return false;
          }
        }

        // String constraints (very basic implementation)
        if (value is String && propertySchema['type'] == 'string') {
          if (propertySchema['format'] == 'email' && !value.contains('@')) {
            _errors.add(
              'Field "$propertyName" should be a valid email address',
            );
            return false;
          }

          if (propertySchema['minLength'] != null &&
              value.length < propertySchema['minLength']) {
            _errors.add(
              'Field "$propertyName" should be at least ${propertySchema['minLength']} characters long',
            );
            return false;
          }

          if (propertySchema['maxLength'] != null &&
              value.length > propertySchema['maxLength']) {
            _errors.add(
              'Field "$propertyName" should be at most ${propertySchema['maxLength']} characters long',
            );
            return false;
          }
        }
      }
    }

    return true;
  }

  /// Validation errors from the last validation operation
  List<String> get errors => List.unmodifiable(_errors);
}
