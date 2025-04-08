part of ednet_core_flutter;

/// Defines required constraints for a semantic element in layout
///
/// This class encapsulates layout requirements based on semantics
/// and allows for consistent sizing across the application.
///
/// Part of the EDNet Shell Architecture's layout system.
class SemanticLayoutRequirements {
  /// Minimum required width
  final double minWidth;

  /// Maximum allowed width
  final double maxWidth;

  /// Minimum required height
  final double minHeight;

  /// Maximum allowed height
  final double maxHeight;

  /// Preferred padding for this element
  final EdgeInsets padding;

  /// Required spacing between items
  final double spacing;

  /// The disclosure level that defines the detail level
  final DisclosureLevel disclosureLevel;

  /// Create semantic layout requirements
  const SemanticLayoutRequirements({
    required this.minWidth,
    required this.maxWidth,
    required this.minHeight,
    required this.maxHeight,
    required this.padding,
    this.spacing = 16.0,
    this.disclosureLevel = DisclosureLevel.standard,
  });

  /// Create requirements based on available constraints
  factory SemanticLayoutRequirements.fromConstraints(
    BuildContext context,
    BoxConstraints constraints, {
    String conceptType = 'default',
    DisclosureLevel disclosureLevel = DisclosureLevel.standard,
  }) {
    // Basic sizing rules based on concept type
    double minWidth, maxWidth, minHeight, maxHeight;
    double padding;

    switch (conceptType.toLowerCase()) {
      case 'domain':
        // Domains are high-level containers that should be spacious
        minWidth = constraints.maxWidth * 0.8;
        maxWidth = constraints.maxWidth;
        minHeight = 300;
        maxHeight = constraints.maxHeight;
        padding = 24.0;
        break;

      case 'model':
        // Models are medium-sized containers
        minWidth = constraints.maxWidth * 0.7;
        maxWidth = constraints.maxWidth;
        minHeight = 250;
        maxHeight = constraints.maxHeight;
        padding = 20.0;
        break;

      case 'concept':
        // Concepts are focused containers
        minWidth = constraints.maxWidth * 0.6;
        maxWidth = constraints.maxWidth;
        minHeight = 200;
        maxHeight = constraints.maxHeight;
        padding = 16.0;
        break;

      case 'attribute':
      case 'property':
        // Properties are small, focused elements
        minWidth = constraints.maxWidth * 0.4;
        maxWidth = constraints.maxWidth * 0.8;
        minHeight = 100;
        maxHeight = 300;
        padding = 12.0;
        break;

      default:
        // Default constraints
        minWidth = constraints.maxWidth * 0.5;
        maxWidth = constraints.maxWidth;
        minHeight = 100;
        maxHeight = constraints.maxHeight;
        padding = 16.0;
    }

    // Adjust based on disclosure level
    double sizeMultiplier;
    double paddingMultiplier;

    switch (disclosureLevel) {
      case DisclosureLevel.minimal:
        // Minimal disclosure uses less space
        sizeMultiplier = 0.8;
        paddingMultiplier = 0.7;
        break;
      case DisclosureLevel.basic:
        // Basic disclosure uses slightly less space
        sizeMultiplier = 0.9;
        paddingMultiplier = 0.85;
        break;
      case DisclosureLevel.standard:
        // Standard uses default sizes
        sizeMultiplier = 1.0;
        paddingMultiplier = 1.0;
        break;
      case DisclosureLevel.intermediate:
        // Intermediate uses slightly more space
        sizeMultiplier = 1.05;
        paddingMultiplier = 1.1;
        break;
      case DisclosureLevel.advanced:
        // Advanced disclosure uses more space
        sizeMultiplier = 1.1;
        paddingMultiplier = 1.2;
        break;
      case DisclosureLevel.detailed:
        // Detailed disclosure uses even more space
        sizeMultiplier = 1.15;
        paddingMultiplier = 1.3;
        break;
      case DisclosureLevel.complete:
        // Complete disclosure uses maximum space
        sizeMultiplier = 1.2;
        paddingMultiplier = 1.4;
        break;
      case DisclosureLevel.debug:
        // Debug disclosure uses maximum space plus extra
        sizeMultiplier = 1.25;
        paddingMultiplier = 1.5;
        break;
    }

    // Apply modifiers
    minWidth *= sizeMultiplier;
    minHeight *= sizeMultiplier;
    padding *= paddingMultiplier;

    // Apply device-specific adjustments
    if (MediaQuery.of(context).size.width < 600) {
      // Mobile adjustments
      minWidth = constraints.maxWidth * 0.95;
      maxWidth = constraints.maxWidth;
      padding *= 0.8;
    }

    // Ensure constraints are within available space
    minWidth = minWidth.clamp(0, constraints.maxWidth);
    maxWidth = maxWidth.clamp(minWidth, constraints.maxWidth);
    minHeight = minHeight.clamp(0, constraints.maxHeight);
    maxHeight = maxHeight.clamp(minHeight, constraints.maxHeight);

    return SemanticLayoutRequirements(
      minWidth: minWidth,
      maxWidth: maxWidth,
      minHeight: minHeight,
      maxHeight: maxHeight,
      padding: EdgeInsets.all(padding),
      spacing: padding * 0.667, // Default spacing relative to padding
      disclosureLevel: disclosureLevel,
    );
  }

  /// Create box constraints from these requirements
  BoxConstraints toBoxConstraints() {
    return BoxConstraints(
      minWidth: minWidth,
      maxWidth: maxWidth,
      minHeight: minHeight,
      maxHeight: maxHeight,
    );
  }

  /// Create a themed container based on these requirements
  Widget buildThemedContainer(
    BuildContext context,
    Widget child, {
    String conceptType = 'default',
    bool applyMargin = false,
    bool fillWidth = true,
    bool fillHeight = false,
  }) {
    // Get design tokens from theme
    final theme = Theme.of(context);
    final borderRadius = BorderRadius.circular(8);

    // Base styling by concept type
    Color backgroundColor;
    double elevation;
    Color borderColor;

    switch (conceptType.toLowerCase()) {
      case 'domain':
        backgroundColor = theme.colorScheme.primary.withOpacity(0.1);
        elevation = 2.0;
        borderColor = theme.colorScheme.primary.withOpacity(0.3);
        break;

      case 'model':
        backgroundColor = theme.colorScheme.secondary.withOpacity(0.1);
        elevation = 1.5;
        borderColor = theme.colorScheme.secondary.withOpacity(0.3);
        break;

      case 'concept':
        backgroundColor = theme.colorScheme.surface;
        elevation = 1.0;
        borderColor = theme.colorScheme.onBackground.withOpacity(0.2);
        break;

      case 'attribute':
      case 'property':
        backgroundColor = theme.colorScheme.surface;
        elevation = 0.5;
        borderColor = theme.colorScheme.onBackground.withOpacity(0.1);
        break;

      default:
        backgroundColor = theme.colorScheme.surface;
        elevation = 1.0;
        borderColor = theme.colorScheme.onBackground.withOpacity(0.2);
    }

    // Container width/height based on fill settings
    final width = fillWidth ? maxWidth : null;
    final height = fillHeight ? maxHeight : null;

    // Create the styled container
    return Container(
      width: width,
      height: height,
      margin: applyMargin ? EdgeInsets.all(spacing / 2) : null,
      padding: padding,
      constraints: toBoxConstraints(),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.1),
            blurRadius: elevation * 2,
            offset: Offset(0, elevation),
          ),
        ],
      ),
      child: child,
    );
  }
}
