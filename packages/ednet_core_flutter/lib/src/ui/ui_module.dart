part of ednet_core_flutter;

/// Factory for creating UX messages
class UXMessageFactory {
  /// Create a message for entity rendering
  static UXMessage forEntityRender(
    Entity entity, {
    DisclosureLevel disclosureLevel = DisclosureLevel.basic,
    String? correlationId,
  }) {
    return UXMessage(
      id: 'ux.render_${entity.id}',
      type: 'ux.render',
      payload: {
        'entity': entity.toJsonMap(),
        'entityType': entity.concept.code,
        'disclosureLevel': disclosureLevel.toString(),
      },
      source: 'UXMessageFactory',
      metadata: {if (correlationId != null) 'correlationId': correlationId},
    );
  }

  /// Create a message for entity update
  static UXMessage forEntityUpdate(
    Entity entity,
    Map<String, dynamic> changes, {
    String? correlationId,
  }) {
    return UXMessage(
      id: 'ux.update_${entity.id}',
      type: 'ux.update',
      payload: {
        'entity': entity.toJsonMap(),
        'entityType': entity.concept.code,
        'changes': changes,
      },
      source: 'UXMessageFactory',
      metadata: {if (correlationId != null) 'correlationId': correlationId},
    );
  }

  /// Create a message for a form submission
  static UXMessage forFormSubmit(
    Entity entity,
    Map<String, dynamic> formData, {
    String? formId,
    String? correlationId,
  }) {
    return UXMessage(
      id: 'ux.form.submit_${entity.id}',
      type: 'ux.form.submit',
      payload: {
        'entity': entity.toJsonMap(),
        'entityType': entity.concept.code,
        'formData': formData,
        if (formId != null) 'formId': formId,
      },
      source: 'UXMessageFactory',
      metadata: {if (correlationId != null) 'correlationId': correlationId},
    );
  }

  /// Generate a unique ID for a message
  static String generateId() {
    final now = DateTime.now().microsecondsSinceEpoch;
    final random = Random().nextInt(1000000).toString().padLeft(6, '0');
    return '$now-$random';
  }
}

/// Factory for creating Entity instances from serialized data
class ConceptFactory {
  /// Create an entity from a concept and JSON map
  static Entity createEntityFromJsonMap(
    Concept concept,
    Map<String, dynamic> data,
  ) {
    final entity = concept.newEntity();
    entity.fromJsonMap(data);
    return entity;
  }
}

/// Initializes the UX component system
void initializeUXComponents() {
  // Initialize any global state or registries needed by the UX components
  print('UX Components initialized');
}

/// Helper method to get adapter for an entity
UXAdapter findUXAdapter<T extends Entity<T>>(
  T entity, {
  DisclosureLevel? disclosureLevel,
}) {
  return UXAdapterRegistry().getAdapter<T>(
    entity,
    disclosureLevel: disclosureLevel ?? DisclosureLevel.basic,
  );
}
