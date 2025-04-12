part of ednet_core_flutter;

/// Extension to Domain class to provide session access
extension DomainSessionExtension on Domain {
  /// Get the domain session for this domain
  DomainSession? get session {
    // Access metadata via entity if available
    if (this is Entity) {
      final entity = this as Entity;
      final metadata = entity.getAttribute<Map<String, dynamic>>('metadata');
      if (metadata != null && metadata.containsKey('_session')) {
        return metadata['_session'] as DomainSession?;
      }

      // Try to create a session
      try {
        // Create domain models from domain
        final domainModels = DomainModels(this);
        final newSession = DomainSession(domainModels);

        // Store session in metadata
        final newMetadata = metadata ?? <String, dynamic>{};
        newMetadata['_session'] = newSession;
        entity.setAttribute('metadata', newMetadata);

        return newSession;
      } catch (e) {
        print('Error creating domain session: $e');
      }
    }

    return null;
  }

  /// Set a domain session for this domain
  set session(DomainSession? value) {
    // Access metadata via entity if available
    if (this is Entity) {
      final entity = this as Entity;
      final metadata = entity.getAttribute<Map<String, dynamic>>('metadata') ??
          <String, dynamic>{};
      metadata['_session'] = value;
      entity.setAttribute('metadata', metadata);
    }
  }
}
