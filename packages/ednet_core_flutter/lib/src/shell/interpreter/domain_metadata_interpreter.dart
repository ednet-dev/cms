import 'package:ednet_core/ednet_core.dart';

/// A class responsible for interpreting and caching metadata from EDNet Core domain models.
///
/// This interpreter extracts and provides easy access to concepts, attributes,
/// relationships, and other metadata from an EDNet Core domain model.
class DomainMetadataInterpreter {
  /// The domain being interpreted
  Domain? _domain;

  /// Maps concept codes to their corresponding concept objects
  final Map<String, Concept> _conceptsMap = {};

  /// Maps concept codes to their attribute maps
  final Map<String, List<Attribute>> _attributesMap = {};

  /// Maps concept codes to their parent concepts
  final Map<String, List<Concept>> _parentConceptsMap = {};

  /// Maps concept codes to their child concepts
  final Map<String, List<Concept>> _childConceptsMap = {};

  /// Loads a domain model for interpretation.
  ///
  /// This extracts all relevant metadata from the domain and caches it
  /// for efficient access.
  void loadDomainModel(Domain domain) {
    _domain = domain;
    _registerAllConcepts(domain);
    _mapRelationships();
  }

  /// Checks if a domain has been loaded.
  bool hasLoadedDomain() {
    return _domain != null;
  }

  /// Gets the code of the loaded domain.
  String getDomainCode() {
    return _domain?.code ?? '';
  }

  /// Gets the total number of concepts registered.
  int getConceptCount() {
    return _conceptsMap.length;
  }

  /// Gets a concept by its code.
  Concept? getConceptByCode(String conceptCode) {
    return _conceptsMap[conceptCode];
  }

  /// Gets all attributes for a concept.
  List<Attribute> getConceptAttributes(String conceptCode) {
    return _attributesMap[conceptCode] ?? [];
  }

  /// Gets all entry concepts (concepts that are entry points).
  List<Concept> getEntryConcepts() {
    return _conceptsMap.values.where((concept) => concept.entry).toList();
  }

  /// Gets parent concepts for a specific concept.
  List<Concept> getParentConcepts(String conceptCode) {
    return _parentConceptsMap[conceptCode] ?? [];
  }

  /// Gets child concepts for a specific concept.
  List<Concept> getChildConcepts(String conceptCode) {
    return _childConceptsMap[conceptCode] ?? [];
  }

  /// Registers all concepts from the domain.
  void _registerAllConcepts(Domain domain) {
    for (final model in domain.models) {
      for (final concept in model.concepts) {
        _conceptsMap[concept.code] = concept;
        _attributesMap[concept.code] = concept.attributes.toList();
      }
    }
  }

  /// Maps parent-child relationships between concepts.
  void _mapRelationships() {
    // Initialize empty lists for all concepts
    for (final conceptCode in _conceptsMap.keys) {
      _parentConceptsMap[conceptCode] = [];
      _childConceptsMap[conceptCode] = [];
    }

    // Map parent-child relationships
    for (final concept in _conceptsMap.values) {
      // Process parent relationships
      for (final parent in concept.parents) {
        if (parent is Neighbor) {
          final destinationConcept = (parent as Neighbor).destinationConcept;
          if (_conceptsMap.containsKey(destinationConcept.code)) {
            _parentConceptsMap[concept.code]?.add(destinationConcept);
          }
        }
      }

      // Process child relationships
      for (final child in concept.children) {
        if (child is Neighbor) {
          final destinationConcept = (child as Neighbor).destinationConcept;
          if (_conceptsMap.containsKey(destinationConcept.code)) {
            _childConceptsMap[concept.code]?.add(destinationConcept);
          }
        }
      }
    }
  }
}
