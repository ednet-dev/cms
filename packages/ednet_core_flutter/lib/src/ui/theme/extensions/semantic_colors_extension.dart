part of 'package:ednet_core_flutter/ednet_core_flutter.dart';

/// Theme extension for semantic domain-specific colors
class SemanticColorsExtension extends ThemeExtension<SemanticColorsExtension> {
  /// Primary color for entity concepts
  final Color entity;

  /// Primary color for concept types
  final Color concept;

  /// Primary color for attributes
  final Color attribute;

  /// Primary color for relationships
  final Color relationship;

  /// Primary color for models
  final Color model;

  /// Primary color for domains
  final Color domain;

  /// Brightness of the theme
  final Brightness brightness;

  /// Default constructor for SemanticColorsExtension
  const SemanticColorsExtension({
    required this.entity,
    required this.concept,
    required this.attribute,
    required this.relationship,
    required this.model,
    required this.domain,
    required this.brightness,
  });

  /// Factory constructor for light theme
  factory SemanticColorsExtension.light() {
    return SemanticColorsExtension(
      entity: SemanticColors.entity,
      concept: SemanticColors.concept,
      attribute: SemanticColors.attribute,
      relationship: SemanticColors.relationship,
      model: SemanticColors.model,
      domain: SemanticColors.domain,
      brightness: Brightness.light,
    );
  }

  /// Factory constructor for dark theme
  factory SemanticColorsExtension.dark() {
    return SemanticColorsExtension(
      // Brighten colors slightly for dark theme
      entity: Color.lerp(SemanticColors.entity, Colors.white, 0.2)!,
      concept: Color.lerp(SemanticColors.concept, Colors.white, 0.2)!,
      attribute: Color.lerp(SemanticColors.attribute, Colors.white, 0.2)!,
      relationship: Color.lerp(SemanticColors.relationship, Colors.white, 0.2)!,
      model: Color.lerp(SemanticColors.model, Colors.white, 0.2)!,
      domain: Color.lerp(SemanticColors.domain, Colors.white, 0.2)!,
      brightness: Brightness.dark,
    );
  }

  /// Get semantic color for concept type
  Color getColorForConceptType(String conceptType) {
    switch (conceptType.toLowerCase()) {
      case 'entity':
        return entity;
      case 'concept':
        return concept;
      case 'attribute':
        return attribute;
      case 'relationship':
        return relationship;
      case 'model':
        return model;
      case 'domain':
        return domain;
      default:
        return entity; // Default to entity color
    }
  }

  @override
  ThemeExtension<SemanticColorsExtension> copyWith({
    Color? entity,
    Color? concept,
    Color? attribute,
    Color? relationship,
    Color? model,
    Color? domain,
    Brightness? brightness,
  }) {
    return SemanticColorsExtension(
      entity: entity ?? this.entity,
      concept: concept ?? this.concept,
      attribute: attribute ?? this.attribute,
      relationship: relationship ?? this.relationship,
      model: model ?? this.model,
      domain: domain ?? this.domain,
      brightness: brightness ?? this.brightness,
    );
  }

  @override
  ThemeExtension<SemanticColorsExtension> lerp(
    covariant ThemeExtension<SemanticColorsExtension>? other,
    double t,
  ) {
    if (other is! SemanticColorsExtension) {
      return this;
    }

    return SemanticColorsExtension(
      entity: Color.lerp(entity, other.entity, t)!,
      concept: Color.lerp(concept, other.concept, t)!,
      attribute: Color.lerp(attribute, other.attribute, t)!,
      relationship: Color.lerp(relationship, other.relationship, t)!,
      model: Color.lerp(model, other.model, t)!,
      domain: Color.lerp(domain, other.domain, t)!,
      brightness: t < 0.5 ? brightness : other.brightness,
    );
  }
}
