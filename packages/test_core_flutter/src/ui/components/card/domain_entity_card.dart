part of 'package:ednet_core_flutter/ednet_core_flutter.dart';

/// A domain-aware card with semantic styling, animations, and progressive disclosure
/// that integrates with the EDNet Shell Architecture to visualize domain entities.
class DomainEntityCard extends StatefulWidget {
  /// The content of the card
  final Widget child;

  /// Optional accent color for the card
  final Color? accentColor;

  /// Optional header widget displayed at the top of the card
  final Widget? header;

  /// Optional footer widget displayed at the bottom of the card
  final Widget? footer;

  /// Optional badge text to display in the top-right corner
  final String? badgeText;

  /// Callback when the card is tapped
  final VoidCallback? onTap;

  /// Optional icon to display in the top-left
  final IconData? leadingIcon;

  /// Controls the card elevation
  final double? elevation;

  /// Optional concept type to use for theming
  final String? conceptType;

  /// Optional role within the concept for more specific styling
  final String? role;

  /// Border radius of the card
  final double? borderRadius;

  /// Controls if the card should have hover animation
  final bool enableHoverEffect;

  /// Indicates if this card represents an aggregate root
  final bool isAggregateRoot;

  /// Indicates if this card represents a domain concept
  final bool isConcept;

  /// Optional importance level (0-1) to control visual prominence
  final double importance;

  /// The current disclosure level for progressive UI
  final DisclosureLevel disclosureLevel;

  /// Creates a domain entity card with semantic styling
  const DomainEntityCard({
    super.key,
    required this.child,
    this.accentColor,
    this.header,
    this.footer,
    this.badgeText,
    this.onTap,
    this.leadingIcon,
    this.elevation,
    this.conceptType,
    this.role,
    this.borderRadius,
    this.enableHoverEffect = true,
    this.isAggregateRoot = false,
    this.isConcept = false,
    this.importance = 0.5,
    this.disclosureLevel = DisclosureLevel.standard,
  });

  /// Create a DomainEntityCard for a specific entity using the EDNet Core integration
  factory DomainEntityCard.forEntity({
    required Entity entity,
    required Widget child,
    Widget? header,
    Widget? footer,
    VoidCallback? onTap,
    IconData? leadingIcon,
    double? elevation,
    double? borderRadius,
    bool enableHoverEffect = true,
    double importance = 0.5,
    DisclosureLevel disclosureLevel = DisclosureLevel.standard,
  }) {
    // Determine if entity is a concept or aggregate root based on its metadata
    final isConcept = entity.concept.code.toLowerCase().contains('concept');
    // Check for aggregate root (would typically be in metadata or entity properties)
    final isAggregateRoot = entity.concept.entry;

    // Get concept type for proper theming
    final conceptType = entity.concept.code;

    // Generate label for badge if needed (entity ID or code)
    final badgeText = entity.code.isNotEmpty ? entity.code : null;

    // Determine leading icon based on entity type
    final effectiveLeadingIcon = leadingIcon ?? _getIconForEntity(entity);

    return DomainEntityCard(
      child: child,
      header: header,
      footer: footer,
      badgeText: badgeText,
      onTap: onTap,
      leadingIcon: effectiveLeadingIcon,
      elevation: elevation,
      conceptType: conceptType,
      borderRadius: borderRadius,
      enableHoverEffect: enableHoverEffect,
      isAggregateRoot: isAggregateRoot,
      isConcept: isConcept,
      importance: importance,
      disclosureLevel: disclosureLevel,
    );
  }

  /// Get appropriate icon for entity type
  static IconData _getIconForEntity(Entity entity) {
    final conceptCode = entity.concept.code.toLowerCase();

    // Icon selection based on common entity types
    if (conceptCode.contains('aggregate')) {
      return Icons.account_tree;
    } else if (conceptCode.contains('concept')) {
      return Icons.category;
    } else if (conceptCode.contains('attribute')) {
      return Icons.label;
    } else if (conceptCode.contains('relationship')) {
      return Icons.link;
    } else if (conceptCode.contains('model')) {
      return Icons.view_module;
    } else if (conceptCode.contains('domain')) {
      return Icons.domain;
    } else if (conceptCode.contains('project')) {
      return Icons.work;
    } else if (conceptCode.contains('deployment')) {
      return Icons.cloud_upload;
    } else if (conceptCode.contains('environment')) {
      return Icons.public;
    }

    // Default icon
    return Icons.circle;
  }

  @override
  State<DomainEntityCard> createState() => _DomainEntityCardState();
}

class _DomainEntityCardState extends State<DomainEntityCard>
    with SingleTickerProviderStateMixin {
  bool _isHovering = false;
  late AnimationController _animationController;
  late Animation<double> _elevationAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _elevationAnimation = Tween<double>(
      begin: _getElevationForDisclosureLevel(widget.disclosureLevel),
      end: _getElevationForDisclosureLevel(widget.disclosureLevel) + 4.0,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Get elevation based on disclosure level
  double _getElevationForDisclosureLevel(DisclosureLevel level) {
    if (widget.elevation != null) return widget.elevation!;

    switch (level) {
      case DisclosureLevel.minimal:
        return 0;
      case DisclosureLevel.basic:
        return 1;
      case DisclosureLevel.standard:
        return 2;
      case DisclosureLevel.intermediate:
        return 2;
      case DisclosureLevel.advanced:
        return 3;
      case DisclosureLevel.detailed:
        return 3;
      case DisclosureLevel.complete:
        return 4;
      case DisclosureLevel.debug:
        return 0;
    }
  }

  /// Get border radius based on disclosure level
  double _getBorderRadiusForDisclosureLevel(DisclosureLevel level) {
    if (widget.borderRadius != null) return widget.borderRadius!;

    switch (level) {
      case DisclosureLevel.minimal:
        return 4;
      case DisclosureLevel.basic:
        return 8;
      case DisclosureLevel.standard:
        return 12;
      case DisclosureLevel.intermediate:
        return 12;
      case DisclosureLevel.advanced:
        return 16;
      case DisclosureLevel.detailed:
        return 16;
      case DisclosureLevel.complete:
        return 20;
      case DisclosureLevel.debug:
        return 4;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine colors based on theme and props
    final theme = Theme.of(context);
    final Color baseColor = theme.colorScheme.surface;
    final borderRadius =
        _getBorderRadiusForDisclosureLevel(widget.disclosureLevel);

    // Get appropriate accent color
    Color accent = widget.accentColor ?? _getSemanticColor(context);

    // Adjust opacity based on importance and hover state
    final borderOpacity = _isHovering ? 0.8 : (0.3 + (widget.importance * 0.5));

    // Build the card with animations
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.enableHoverEffect ? _scaleAnimation.value : 1.0,
          child: MouseRegion(
            onEnter: (_) {
              if (widget.enableHoverEffect) {
                setState(() => _isHovering = true);
                _animationController.forward();
              }
            },
            onExit: (_) {
              if (widget.enableHoverEffect) {
                setState(() => _isHovering = false);
                _animationController.reverse();
              }
            },
            child: GestureDetector(
              onTap: widget.onTap,
              child: Card(
                elevation: widget.enableHoverEffect
                    ? _elevationAnimation.value
                    : _getElevationForDisclosureLevel(widget.disclosureLevel),
                clipBehavior: Clip.antiAlias,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                  side: BorderSide(
                    color: _isHovering
                        ? accent
                        : accent.withOpacity(
                            widget.isAggregateRoot || widget.isConcept
                                ? borderOpacity
                                : 0.0,
                          ),
                    width: widget.isAggregateRoot ? 2.0 : 1.0,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: baseColor,
                    borderRadius: BorderRadius.circular(borderRadius),
                    gradient: _buildGradient(baseColor, accent),
                    boxShadow: _isHovering
                        ? [
                            BoxShadow(
                              color: accent.withOpacity(0.15),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Special indicator for aggregate roots
                      if (widget.isAggregateRoot)
                        Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: accent,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(borderRadius - 1),
                              topRight: Radius.circular(borderRadius - 1),
                            ),
                          ),
                        ),

                      // Build header if provided
                      if (widget.header != null ||
                          widget.leadingIcon != null ||
                          widget.badgeText != null)
                        _buildHeader(context, accent),

                      // Main content
                      Padding(
                        padding: EdgeInsets.all(context.spacingM),
                        child: widget.child,
                      ),

                      // Build footer if provided
                      if (widget.footer != null) _buildFooter(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Get semantic color based on concept type
  Color _getSemanticColor(BuildContext context) {
    final theme = Theme.of(context);
    final semanticColors = theme.extension<SemanticColorsExtension>();

    if (widget.conceptType != null && semanticColors != null) {
      // Use appropriate semantic color based on concept type
      if (widget.conceptType!.toLowerCase().contains('aggregate')) {
        return semanticColors.entity.withOpacity(0.8);
      } else if (widget.conceptType!.toLowerCase().contains('concept')) {
        return semanticColors.concept;
      } else {
        return semanticColors.entity;
      }
    }

    if (widget.isAggregateRoot && semanticColors != null) {
      return semanticColors.entity.withOpacity(0.8); // For aggregate roots
    }

    if (widget.isConcept && semanticColors != null) {
      return semanticColors.concept;
    }

    return theme.colorScheme.primary;
  }

  Gradient? _buildGradient(Color baseColor, Color accent) {
    if (!_isHovering) {
      return null;
    }

    if (widget.isAggregateRoot) {
      return LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [accent.withOpacity(0.08), baseColor],
        stops: const [0.0, 0.3],
      );
    }

    if (widget.isConcept) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [baseColor, accent.withOpacity(0.08), baseColor],
        stops: const [0.0, 0.5, 1.0],
      );
    }

    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [baseColor, accent.withOpacity(0.05)],
    );
  }

  Widget _buildHeader(BuildContext context, Color accentColor) {
    // Special styles for aggregate roots and concepts
    final bool isSpecial = widget.isAggregateRoot || widget.isConcept;

    return Container(
      decoration: BoxDecoration(
        color: isSpecial ? accentColor.withOpacity(0.05) : null,
        border: Border(
          bottom: BorderSide(
            color: isSpecial
                ? accentColor.withOpacity(0.3)
                : Theme.of(context).dividerColor.withOpacity(0.5),
            width: isSpecial ? 1.5 : 1,
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: context.spacingM,
        vertical: context.spacingS,
      ),
      child: Row(
        children: [
          if (widget.leadingIcon != null) ...[
            Icon(
              widget.leadingIcon,
              color: accentColor,
              size: isSpecial ? 22 : 20,
            ),
            SizedBox(width: context.spacingS),
          ],
          if (widget.header != null) Expanded(child: widget.header!),
          if (widget.badgeText != null) _buildBadge(context, accentColor),

          // Special indicator for aggregate roots and concepts
          if (isSpecial && widget.badgeText == null)
            _buildSpecialIndicator(context, accentColor),
        ],
      ),
    );
  }

  Widget _buildSpecialIndicator(BuildContext context, Color accentColor) {
    final String label =
        widget.isAggregateRoot ? '@aggregate-root' : '@concept';

    // Only show the indicator if disclosure level is detailed or higher
    if (widget.disclosureLevel.index < DisclosureLevel.detailed.index) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.spacingS,
        vertical: context.spacingXs / 2,
      ),
      decoration: BoxDecoration(
        color: accentColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accentColor.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            widget.isAggregateRoot ? Icons.account_tree : Icons.category,
            size: 12,
            color: accentColor,
          ),
          SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: accentColor,
              fontWeight: FontWeight.bold,
              fontSize: 11,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(BuildContext context, Color accentColor) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.spacingS,
        vertical: context.spacingXs / 2,
      ),
      decoration: BoxDecoration(
        color: accentColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accentColor.withOpacity(0.3), width: 1),
      ),
      child: Text(
        widget.badgeText!,
        style: TextStyle(
          color: accentColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    final isSpecial = widget.isAggregateRoot || widget.isConcept;
    final accent = _getSemanticColor(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.spacingM,
        vertical: context.spacingS,
      ),
      decoration: BoxDecoration(
        color: isSpecial
            ? accent.withOpacity(0.03)
            : Theme.of(context).colorScheme.surface.withOpacity(0.5),
        border: Border(
          top: BorderSide(
            color: isSpecial
                ? accent.withOpacity(0.3)
                : Theme.of(context).dividerColor.withOpacity(0.5),
            width: isSpecial ? 1.5 : 1,
          ),
        ),
      ),
      child: widget.footer!,
    );
  }
}

/// A UX adapter that uses DomainEntityCard for entity rendering
class DomainEntityCardAdapter<T extends Entity<T>>
    extends ProgressiveUXAdapter<T> {
  /// Constructor
  DomainEntityCardAdapter(T entity) : super(entity);

  /// Get field descriptors from entity
  List<UXFieldDescriptor> getFieldDescriptors({
    DisclosureLevel? disclosureLevel = DisclosureLevel.basic,
  }) {
    // Create field descriptors from entity attributes
    final result = <UXFieldDescriptor>[];
    final level = disclosureLevel ?? DisclosureLevel.basic;

    for (final attribute in entity.concept.attributes) {
      // Determine field type
      final fieldType = _determineFieldType(attribute.type?.code ?? 'String');

      // Create disclosure level based on attribute properties
      var attrLevel = DisclosureLevel.basic;
      if (attribute.code.startsWith('__')) {
        attrLevel = DisclosureLevel.complete;
      } else if (attribute.code.startsWith('_')) {
        attrLevel = DisclosureLevel.advanced;
      } else if (!attribute.required) {
        attrLevel = DisclosureLevel.intermediate;
      } else {
        attrLevel = DisclosureLevel.minimal;
      }

      // Only add if appropriate for this disclosure level
      if (attrLevel.index <= level.index) {
        result.add(
          UXFieldDescriptor(
            fieldName: attribute.code,
            displayName: _formatDisplayName(attribute.code),
            fieldType: fieldType,
            required: attribute.required,
            disclosureLevel: attrLevel,
          ),
        );
      }
    }

    return result;
  }

  /// Get initial form data for entity
  Map<String, dynamic> getInitialFormData() {
    // Create a map of attribute values
    final result = <String, dynamic>{};

    for (final attribute in entity.concept.attributes) {
      final value = entity.getAttribute(attribute.code);
      if (value != null) {
        result[attribute.code] = value;
      }
    }

    return result;
  }

  /// Determine field type from attribute type
  UXFieldType _determineFieldType(String typeCode) {
    switch (typeCode.toLowerCase()) {
      case 'string':
        return UXFieldType.text;
      case 'text':
      case 'longtext':
        return UXFieldType.longText;
      case 'int':
      case 'double':
      case 'num':
      case 'number':
        return UXFieldType.number;
      case 'datetime':
      case 'date':
        return UXFieldType.date;
      case 'boolean':
      case 'bool':
        return UXFieldType.checkbox;
      default:
        return UXFieldType.text;
    }
  }

  /// Format a field name for display
  String _formatDisplayName(String code) {
    // Add spaces before capital letters and capitalize first letter
    final spaced = code
        .replaceAllMapped(
          RegExp(r'([A-Z])'),
          (match) => ' ${match.group(0)}',
        )
        .trim();

    return spaced.substring(0, 1).toUpperCase() + spaced.substring(1);
  }

  @override
  Widget buildListItem(
    BuildContext context, {
    DisclosureLevel? disclosureLevel,
  }) {
    final level = disclosureLevel ?? DisclosureLevel.minimal;
    return DomainEntityCard.forEntity(
      entity: entity,
      disclosureLevel: level,
      onTap: () {
        // Add navigation or detail view action here
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            entity.toString(),
            style: Theme.of(context).textTheme.titleMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (level.index >= DisclosureLevel.basic.index) ...[
            const SizedBox(height: 4),
            Text(
              entity.concept.code,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget buildDetailView(
    BuildContext context, {
    DisclosureLevel? disclosureLevel,
  }) {
    final level = disclosureLevel ?? DisclosureLevel.basic;
    // Get fields appropriate for this disclosure level
    final filteredFields = filterFieldsByDisclosure(
      getFieldDescriptors(disclosureLevel: level),
      level,
    );

    return DomainEntityCard.forEntity(
      entity: entity,
      disclosureLevel: level,
      header: Text(
        entity.toString(),
        style: Theme.of(context).textTheme.titleMedium,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...filteredFields.map((field) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 150,
                    child: Text(
                      field.displayName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      _formatFieldValue(
                        entity.getAttribute(field.fieldName),
                        field.fieldType,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  @override
  Widget buildForm(
    BuildContext context, {
    DisclosureLevel? disclosureLevel,
  }) {
    final level = disclosureLevel ?? DisclosureLevel.basic;
    // Using getFieldDescriptors to know what fields are available
    // but not directly using the result in this simplified implementation

    return DomainEntityCard.forEntity(
      entity: entity,
      disclosureLevel: level,
      header: Text(
        'Edit ${entity.concept.code}: ${entity.code}',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      child: Text('Form implementation for ${entity.concept.code}'),
    );
  }

  @override
  Widget buildVisualization(
    BuildContext context, {
    DisclosureLevel? disclosureLevel,
  }) {
    final level = disclosureLevel ?? DisclosureLevel.basic;

    return DomainEntityCard.forEntity(
      entity: entity,
      disclosureLevel: level,
      child: Center(
        child: Text('Visualization for ${entity.concept.code}: ${entity.code}'),
      ),
    );
  }

  @override
  bool validateForm() {
    // Implement form validation logic
    return true;
  }

  @override
  Future<bool> submitForm(Map<String, dynamic> formData) async {
    // Implement form submission logic
    try {
      // Update entity with form data
      formData.forEach((key, value) {
        entity.setAttribute(key, value);
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Format a field value for display
  String _formatFieldValue(dynamic value, UXFieldType type) {
    if (value == null) return '-';

    switch (type) {
      case UXFieldType.date:
        if (value is DateTime) {
          return '${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
        }
        return value.toString();
      case UXFieldType.checkbox:
        return value == true ? 'Yes' : 'No';
      default:
        return value.toString();
    }
  }
}
