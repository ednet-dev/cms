part of ednet_core_flutter;

/// A class that adapts layout requirements based on both concept semantics
/// and device characteristics
class LayoutAdapter {
  /// The current context used for layout calculations
  final BuildContext context;

  /// Create a new layout adapter
  LayoutAdapter(this.context);

  /// Get appropriate constraints for a concept within available space
  BoxConstraints getConstraintsForConcept(
    String conceptType,
    BoxConstraints constraints, {
    DisclosureLevel disclosureLevel = DisclosureLevel.standard,
  }) {
    // Basic sizing rules based on concept type
    double minWidth, maxWidth, minHeight, maxHeight;

    switch (conceptType.toLowerCase()) {
      case 'domain':
        // Domains are high-level containers that should be spacious
        minWidth = constraints.maxWidth * 0.8;
        maxWidth = constraints.maxWidth;
        minHeight = 300;
        maxHeight = constraints.maxHeight;
        break;

      case 'model':
        // Models are medium-sized containers
        minWidth = constraints.maxWidth * 0.7;
        maxWidth = constraints.maxWidth;
        minHeight = 250;
        maxHeight = constraints.maxHeight;
        break;

      case 'concept':
        // Concepts are focused containers
        minWidth = constraints.maxWidth * 0.6;
        maxWidth = constraints.maxWidth;
        minHeight = 200;
        maxHeight = constraints.maxHeight;
        break;

      case 'attribute':
      case 'property':
        // Properties are small, focused elements
        minWidth = constraints.maxWidth * 0.4;
        maxWidth = constraints.maxWidth * 0.8;
        minHeight = 100;
        maxHeight = 300;
        break;

      default:
        // Default constraints
        minWidth = constraints.maxWidth * 0.5;
        maxWidth = constraints.maxWidth;
        minHeight = 100;
        maxHeight = constraints.maxHeight;
    }

    // Adjust based on disclosure level
    switch (disclosureLevel) {
      case DisclosureLevel.minimal:
        // Minimal disclosure uses less space
        minWidth *= 0.8;
        minHeight *= 0.7;
        break;
      case DisclosureLevel.basic:
        // Basic disclosure uses slightly less space
        minWidth *= 0.9;
        minHeight *= 0.8;
        break;
      case DisclosureLevel.standard:
        // Standard uses default sizes
        break;
      case DisclosureLevel.intermediate:
        // Intermediate uses slightly more space
        minWidth *= 1.05;
        minHeight *= 1.05;
        break;
      case DisclosureLevel.advanced:
        // Advanced disclosure uses more space
        minWidth *= 1.1;
        minHeight *= 1.1;
        break;
      case DisclosureLevel.detailed:
        // Detailed disclosure uses even more space
        minWidth *= 1.15;
        minHeight *= 1.15;
        break;
      case DisclosureLevel.complete:
        // Complete disclosure uses maximum space
        minWidth *= 1.2;
        minHeight *= 1.2;
        break;
      case DisclosureLevel.debug:
        // Debug disclosure uses maximum space plus extra
        minWidth *= 1.25;
        minHeight *= 1.25;
        break;
    }

    // Apply device-specific adjustments
    if (MediaQuery.of(context).size.width < 600) {
      // Mobile adjustments
      minWidth = constraints.maxWidth * 0.95;
      maxWidth = constraints.maxWidth;
    }

    // Ensure constraints are within available space
    minWidth = minWidth.clamp(0, constraints.maxWidth);
    maxWidth = maxWidth.clamp(minWidth, constraints.maxWidth);
    minHeight = minHeight.clamp(0, constraints.maxHeight);
    maxHeight = maxHeight.clamp(minHeight, constraints.maxHeight);

    return BoxConstraints(
      minWidth: minWidth,
      maxWidth: maxWidth,
      minHeight: minHeight,
      maxHeight: maxHeight,
    );
  }

  /// Build a concept container with appropriate layout based on concept type
  Widget buildConceptContainer({
    required BuildContext context,
    required String conceptType,
    required Widget child,
    bool fillWidth = true,
    bool fillHeight = false,
    DisclosureLevel disclosureLevel = DisclosureLevel.standard,
  }) {
    // Get appropriate constraints for this concept
    return LayoutBuilder(
      builder: (context, constraints) {
        final semanticConstraints = getConstraintsForConcept(
          conceptType,
          constraints,
          disclosureLevel: disclosureLevel,
        );

        // Apply appropriate container styling based on concept type
        return _buildStyledContainer(
          context: context,
          conceptType: conceptType,
          child: child,
          constraints: semanticConstraints,
          fillWidth: fillWidth,
          fillHeight: fillHeight,
          disclosureLevel: disclosureLevel,
        );
      },
    );
  }

  /// Build a flow layout for arrangement of multiple items
  Widget buildFlowLayout({
    required BuildContext context,
    required List<Widget> children,
    double spacing = 16.0,
    double runSpacing = 16.0,
    DisclosureLevel disclosureLevel = DisclosureLevel.standard,
  }) {
    // Adjust spacing based on disclosure level
    double adjustedSpacing = spacing;
    double adjustedRunSpacing = runSpacing;

    switch (disclosureLevel) {
      case DisclosureLevel.minimal:
        adjustedSpacing *= 0.7;
        adjustedRunSpacing *= 0.7;
        break;
      case DisclosureLevel.basic:
        adjustedSpacing *= 0.85;
        adjustedRunSpacing *= 0.85;
        break;
      case DisclosureLevel.standard:
        // Standard uses default sizes
        break;
      case DisclosureLevel.intermediate:
        adjustedSpacing *= 1.1;
        adjustedRunSpacing *= 1.1;
        break;
      case DisclosureLevel.advanced:
        adjustedSpacing *= 1.2;
        adjustedRunSpacing *= 1.2;
        break;
      case DisclosureLevel.detailed:
        adjustedSpacing *= 1.3;
        adjustedRunSpacing *= 1.3;
        break;
      case DisclosureLevel.complete:
        adjustedSpacing *= 1.4;
        adjustedRunSpacing *= 1.4;
        break;
      case DisclosureLevel.debug:
        adjustedSpacing *= 1.5;
        adjustedRunSpacing *= 1.5;
        break;
    }

    return Wrap(
      spacing: adjustedSpacing,
      runSpacing: adjustedRunSpacing,
      children: children,
    );
  }

  /// Get padding appropriate for a concept
  EdgeInsets getPaddingForConcept(
    String conceptType, {
    DisclosureLevel disclosureLevel = DisclosureLevel.standard,
  }) {
    // Base padding by concept type
    double basePadding;
    switch (conceptType.toLowerCase()) {
      case 'domain':
        basePadding = 24.0;
        break;
      case 'model':
        basePadding = 20.0;
        break;
      case 'concept':
        basePadding = 16.0;
        break;
      case 'attribute':
      case 'property':
        basePadding = 12.0;
        break;
      default:
        basePadding = 16.0;
    }

    // Adjust based on disclosure level
    double adjustedPadding = basePadding;
    switch (disclosureLevel) {
      case DisclosureLevel.minimal:
        adjustedPadding *= 0.7;
        break;
      case DisclosureLevel.basic:
        adjustedPadding *= 0.85;
        break;
      case DisclosureLevel.standard:
        // Standard uses default
        break;
      case DisclosureLevel.intermediate:
        adjustedPadding *= 1.1;
        break;
      case DisclosureLevel.advanced:
        adjustedPadding *= 1.2;
        break;
      case DisclosureLevel.detailed:
        adjustedPadding *= 1.3;
        break;
      case DisclosureLevel.complete:
        adjustedPadding *= 1.4;
        break;
      case DisclosureLevel.debug:
        adjustedPadding *= 1.5;
        break;
    }

    // Adjust for device
    if (MediaQuery.of(context).size.width < 600) {
      adjustedPadding *= 0.8;
    }

    return EdgeInsets.all(adjustedPadding);
  }

  /// Private helper to build styled container based on concept type
  Widget _buildStyledContainer({
    required BuildContext context,
    required String conceptType,
    required Widget child,
    required BoxConstraints constraints,
    required bool fillWidth,
    required bool fillHeight,
    required DisclosureLevel disclosureLevel,
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
    final width = fillWidth ? constraints.maxWidth : null;
    final height = fillHeight ? constraints.maxHeight : null;

    // Apply padding based on concept type and disclosure level
    final padding = getPaddingForConcept(
      conceptType,
      disclosureLevel: disclosureLevel,
    );

    // Create the styled container
    return Container(
      width: width,
      height: height,
      constraints: constraints,
      padding: padding,
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
